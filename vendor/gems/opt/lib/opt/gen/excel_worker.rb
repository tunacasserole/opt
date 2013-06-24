require 'spreadsheet'

class Opt::Gen::ExcelWorker < Opt::Gen::Worker

  def self.constants
    @format = Spreadsheet::Format.new(:weight => :bold)
    @template_folder = File.join(Rails.root, 'vendor','gems','opt','db','import','templates')    
    @template_file = File.join(@template_folder, "core_data_template_#{Time.now.round(3).to_s.chomp(' -0700').gsub(':','-').gsub(' ','_').chop.chop.chop}.xls")
    @book = Spreadsheet::Workbook.new
  end

  def self.run(model)
    constants
    process model
    @book.write @template_file = File.join(@template_folder, "#{model.model_name + '_' + Time.now.round(3).to_s.chomp(' -0700').gsub(':','-').gsub(' ','_').chop.chop.chop.chop.chop.chop.chop.chop.chop}.xls")
  end

  def self.run_all
    constants
    models = Buildit::ModelMeta.all.each.sort_by(&:model_name)
    models.each {|m| process m}
    @book.write @template_file
  end

  def self.process(model)
    initiate "Creating the excel file"
    #puts 'processing model: ' + model.model_name
    write_sheet = @book.create_worksheet :name => model.table_name
    write_sheet.row(0).set_format(0, @format)
    write_sheet.row(0).push 'display'
    model.attribute_meta.reject {|a| a.mapping_type == 'MAPPED' or a.attribute_name == 'display' or a.attribute_name == 'is_destroyed' or a.attribute_name == model.primary_attribute}.each_with_index do |a, i| 
      #puts 'processing attribute: ' + a.attribute_name
      column = ""
      column << "*" if !a.allows_null 
      column << "(l)" if Buildit::ValidationMeta.all(:attribute_meta_id => a.attribute_meta_id).first
      column << "#{a.attribute_name}"
      write_sheet.row(0).set_format(i+1, @format)
      write_sheet.row(0).push column
    end
  end

end
