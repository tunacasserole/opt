require 'colored'

class Opt::Gen::SeedWorker <  Opt::Gen::Worker

  @@folder_name = File.join(Rails.root, 'vendor','gems','opt','db','meta')
  @@file_name = 'core_data table assignment, v6.xlsx'
  @@poly_hash = {'stockable_id' => 'StockLedgerActivity','noteable_id' => 'Note','pickable_id' => 'PickTicket'}
  @@skip_tabs = ['main','Instructions','lookups','sequences']
  @@skip_these_tables = ['container_details','users','location_users','skus2','state_codes','person','vouchers','person_sites','bin_tags','customer_tags','location_tags','price_changes','promotions','site_tags','sku_tags','style_tags','supplier_programs','supplier_program_details','supplier_tags','tags']
  @@skip_these = ['manifest_id','customer_account_id','vehicle_id','demand_forecast_profile_id','pallet_id','landed_cost_model_id','fob_point']
  @@exceptions = []
  @@encoding_options = {
      :invalid           => :replace,  # Replace invalid byte sequences
      :undef             => :replace,  # Replace anything not defined in ASCII
      :replace           => '',        # Use a blank for those replacements
  }

  def self.file_path
    File.join(Rails.root.to_s, 'vendor', 'gems', 'opt', 'db', 'seed')
  end

  def self.error_file_path
    File.join(Rails.root.to_s, 'vendor', 'gems', 'opt', 'db', 'error')
  end

  def self.file_name(tab,type)
    timestamp = Time.now.strftime('%Y%m%d%H%M%S')
    if type == 'error'
      File.join(error_file_path,  "#{timestamp}_#{tab}_error.txt")
    else
      if type == 'stats'
        File.join(error_file_path,  "#{timestamp}_#{tab}_stats.txt")
      else
        File.join(file_path, "#{timestamp}_#{tab}.rb")
      end
    end
  end

#  def self.destroy()
#    initiate "Destroying the  file"
#    FileUtils.rm_rf(self.file_name) if File.exists?(self.file_name)
#    complete
#  end # def self.destroy

  def self.excel_to_hash(folder_name, file_name, tab_name)
    # Takes an excel folder name, file name and tab name, and returns an array of hashed, stripped, transposed rows
    # Sample call:  @@models = excel_to_hash File.join(Rails.root, db, meta), @@meta_file, 'application_models'
    rows = []
    file = File.open(File.join(folder_name, file_name), mode = 'r')
    excel = Excelx.new(file.path, nil, :ignore)
    puts folder_name + '/' + file_name + ' tab: ' + tab_name unless excel.sheets.index(tab_name)
    excel.default_sheet = excel.sheets.index(tab_name) + 1
    if excel.first_row && excel.first_column #Avoid errors on blank sheets
      header = excel.row(1)
      (2..excel.last_row).each do |i|
        next unless excel.row(i)[0]
        row = Hash[[header, excel.row(i)].transpose]
        row.each_key{|x| row[x] = row[x].to_s.strip if row[x]}
        rows << row
      end
    end
    return rows

  end

  def self.run(options = {})

    #Create a stats file for this run
    @@stats_file = File.open(self.file_name('current', 'stats'),'w')

    if options[:type] != "table"
      initiate "Preparing the  file"
      FileUtils.mkdir_p(file_path)

      file = File.open(File.join(@@folder_name, @@file_name), mode = 'r')
      #excel = Excelx.new(file.path, nil, :ignore)

      @@core_data_main = excel_to_hash @@folder_name, @@file_name, 'main'

      seq = '0'
      @@core_data_main.each {|row| seq = row['sequence'] if row['table_name'].classify == options[:restart]} if options[:restart]

      #Create hashes to speed up parent and other lookups
      @@parent_hash = {}
      Buildit::ModelMeta.all.each {|model| @@parent_hash[model.primary_attribute.to_s.downcase] = model.model_name}
      @@model_name_hash = @@parent_hash.invert
      @@lookup_hash = Hash.new(Array.new)
      Buildit::Lookup.all.each {|lookup_row| @@lookup_hash[lookup_row.category] << lookup_row.code }



      @@core_data_main.each do |row|
        next if options[:restart] and row['sequence'] < seq or @@skip_these_tables.include? row['table_name']
        tab = row['table_name']
        # remove the file if it already exists
        file_name_write = self.file_name(tab,'content')
        FileUtils.rm_rf(file_name_write.to_s) if File.exists?(file_name_write.to_s)
        file_name_write = self.file_name(tab,'error')
        FileUtils.rm_rf(file_name_write.to_s) if File.exists?(file_name_write.to_s)
        complete

        # create the files
        if not @@skip_tabs.include?tab
          puts "#{tab} -  #{Time.now.strftime("%H:%M:%S").yellow}"
          @@core_data_tab = excel_to_hash @@folder_name, @@file_name, tab
          if not @@core_data_tab.blank?
            file_contents(tab)
          end
          complete
        end

        break if options[:type] == "single"        # Single run
      end
    else
      table_contents(options[:mark_model])
    end

    #Close the stats file
    @@stats_file.close

  end

  def self.file_contents(tab)
    #Opt::Meta::Base.constants
    #model_headers = File.join(Rails.root,'vendor/gems/opt/db/meta/model_headers.xlsx')
    data_file = File.open(self.file_name(tab, ''), 'w')
    error_file = File.open(self.file_name(tab, 'error'), 'w')

    @@stats_file.print "#{tab} : Start : #{Time.now.strftime("%H:%M:%S")} \n"
    @@stats_file.flush()  # Write to stats immediately

    @@core_data_tab = excel_to_hash @@folder_name, @@file_name, tab


     # if not @@core_data_main.blank? -- Not needed since checking when called
     superclass = 'Opt'
     if tab == 'users'
       superclass = 'Buildit'
     end
      exceptions = ::ERB.new('').result(binding)
      row_counter = 1
      error_counter = 0
      critical_error_counter = 0
      tab_meta = tab.classify
      content  = "#{superclass}::#{tab_meta}.delete_all\n"
      data_file.print content


      @@core_data_tab.each do |row|
        error_flag = 0               #Initialize error flags for each row
        critical_error_flag = 0
        column_counter = 1

        content = "#{superclass}::#{tab_meta}.create("

        row.keys.each do |key|

          key_name = key.to_s.sub('*','').sub('(l)','')
          if key_name != 'main!A1' and key_name != ' ' and key_name != '' and !@@skip_these.include? key_name
            column_counter += 1
            if column_counter <= 2 #first column
              content << ":#{@@model_name_hash[tab_meta].to_s} => \"#{Buildit::Util::Guid.generate()}\""
            end

            key_value = row[key].to_s.sub('.0','').encode Encoding.find('ASCII'), @@encoding_options    #strip out non-ASCII
            key_value = key_value.gsub /"/, ''  # Fix for string s that have "
            key_value.chop! if key_value.end_with? '.'

            if key_name.end_with? '_id' and !key_name.end_with? 'user_id'
              if @@poly_hash.has_key? key_name
                #parent = Buildit::ModelMeta.all(:model_name => row[key.chop.chop.chop + '_type'].demodulize).first
                parent = @@poly_hash[key_name]
              else
                #parent = Buildit::ModelMeta.all(:primary_attribute => a_name).first || Buildit::ModelMeta.all.reject {|x| !a_name.index(x.model_name.singularize.foreign_key)}.first
                parent = @@parent_hash[key_name]
              end
              if !parent
                exceptions << "Could not locate parent model for #{key_name} - #{row_counter}\n"
                key_value = " "
                if key.to_s.start_with? '*'
                  critical_error_flag = 1
                else
                  error_flag = 1
                end
                #next
              else
                parent_row = ('Opt::' + parent).constantize.where(:display => key_value).first
                if !parent_row
                  exceptions << "Could not locate parent row for #{key_name} - #{row_counter}\n"
                  #next
                  key_value = " "
                  if key.to_s.start_with? '*'
                    critical_error_flag = 1
                  else
                    error_flag = 1
                  end
                else
                  key_value = parent_row.send(key_name)
                end
              end
            else
              if key.to_s.start_with? '(l)' or key.to_s.start_with? '*(l)' or Buildit::Lookup.where(:category => key_name.upcase).first
                if @@lookup_hash[key_name].include? key_value.upcase
                  key_value = key_value.upcase
                else
                  exceptions << "Could not locate lookup for #{key_name} - #{row_counter} - #{key_value}\n"

                  #Special case -- Critical error
                  if key.to_s.start_with? '*(l)'
                    #critical_error_flag = 1  #Not with lookups
                  else
                    error_flag = 1
                  end
                end
              end
            end

            #Special case for Users - Search by first name and last name
            if key_name.end_with? 'user_id'
              if key_value != ""
                name = key_value.split(",")
                first_name = name[1].strip if !name[1].nil?  # Some may only have first name or last name
                last_name = name[0].strip  if !name[0].nil?
              else
                first_name = ""
                last_name = ""
              end
              parent_row = Buildit::User.where(:first_name => first_name, :last_name=>last_name).first
              if !parent_row
                exceptions << "Could not locate parent row for #{key_name} - #{row_counter}\n"
                #next
                key_value = " "
                if key.to_s.start_with? '*'
                  critical_error_flag = 1
                else
                  error_flag = 1
                end
              else
                key_value = parent_row.send(key_name)
              end
            end

            content << ",:#{key_name} =>" << "\"" << "#{key_value}" << "\""
            end
        end
        content << ")\n"

        data_file.print content
        data_file.flush()

        row_counter += 1
        error_counter += error_flag
        critical_error_counter += critical_error_flag
      end

      #end -- Not needed since checking when called
       error_file.print exceptions

       # Close the files
       data_file.close
       error_file.close

       #Print Stats
       @@stats_file.print "Number of rows - #{row_counter - 1} \n"
       @@stats_file.print "Number of critical errors - #{critical_error_counter} \n"
       @@stats_file.print "Number of rows in error - #{error_counter} \n"
       @@stats_file.print "#{tab} : End : #{Time.now.strftime("%H:%M:%S")} \n"
       @@stats_file.flush()  # Write to stats immediately

       #Run the seed
       system ('rake buildit:db:seed')
  end

  def self.table_contents(mark_model)

    model = ('Opt::Mark' + mark_model +'Dev').constantize
    data_file = File.open(self.file_name(('Mark' + mark_model).tableize, ''), 'w')
    mark_inventory = model.all #(:limit => 10)
    column_names = model.column_names

    content = ""

    mark_inventory.each do  |i|
      content << "#{model}.create("

      column_names.each do |col|
        content << "#{col} => \"#{i.send(col)}\","
      end

      content.chop!
      content << ")\n"

    end

    data_file.print content
    data_file.flush()
  end

  private
end

