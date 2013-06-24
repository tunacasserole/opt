class Opt::Gen::CsvWorker < Opt::Gen::Worker
  
  def self.prepare(model)
    initiate "Preparing the csv file"
    template_folder = File.join(Dir.home, 'Dropbox', 'horizon', 'data', 'templates')
    template_file =  File.join(template_folder, "#{model.table_name}.csv") 
    #FileUtils.mkdir_p(template_folder)
    #unless File.exists? template_file
      content = ::ERB.new('').result(binding)
      File.open(template_file, 'w') {|file| file.print ''}
    #end
    complete
  end

  def self.process(model)
    initiate "Creating the csv file"
    template_folder = File.join(Dir.home, 'Dropbox', 'horizon', 'data', 'templates')
    template_file =  File.join(template_folder, "#{model.table_name}.csv") 
    contents = Buildit::Util::File.read_contents(template_file)
    contents << 'display,'
    #logger.debug 'process' + model.primary_attribute
    model.attribute_meta.reject {|a| a.mapping_type == 'MAPPED' or a.attribute_name == 'display' or a.attribute_name == 'is_destroyed' or a.attribute_name == model.primary_attribute}.each_with_index do |a, i| 
      contents << "*" if !a.allows_null
      contents << "(l)" if Buildit::ValidationMeta.all(:attribute_meta_id => a.attribute_meta_id).first
      contents << "#{a.attribute_name},"
      #contents << "," if a.attribute_name != 'is_destroyed'
    end
    contents.chop!
    contents << "\n"
    File.open(template_file, 'w') { |file| file.print contents}
    complete
  end

end