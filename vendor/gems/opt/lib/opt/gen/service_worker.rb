class Opt::Gen::ServiceWorker < Buildit::Gen::Scaffold::Worker
  
  def self.destroy(model)
    initiate "Destroying the server model service"
    complete
  end


  def self.prepare(model)
    initiate "Preparing the server model service"
    file_path =  File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'core', "#{model.namespace.underscore}", "#{model.model_name.underscore}") 
    file_name =  File.join(file_path, "service.rb")
    FileUtils.mkdir_p(file_path)
    
    unless File.exists? file_name
      content = ::ERB.new(self.template).result(binding)
      File.open(file_name, 'w') {|file| file.puts content}
    end
    complete
  end


  def self.process(model)
    initiate "Creating the server model service"
    file_name = File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'core', "#{model.namespace.underscore}", "#{model.model_name.underscore}.rb")
    contents = Buildit::Util::File.read_contents(file_name)
    
    Buildit::Framework.configuration.scaffolders.buildit_service.each do |worker|
      contents = worker.send(:process_model, model, contents) || contents if worker.respond_to? :process_model
    end
    
    File.open(file_name, 'w') { |file| file.puts contents}
    complete
  end
  
  
  private
  
  def self.template
<<-EOF
class <%= model.namespace %>::<%= model.model_name %>::Service
  include Buildit::Service::Base

  service '<%= model.model_name %>', '<%= model.namespace %>.service'

  connected_mode(Buildit::Service::Backend::Crud) do |config|
    config.model = <%= model.namespace %>::<%= model.model_name %>
  end

end # class <%= model.namespace %>::<%= model.model_name %>::Service
EOF
  end
  

end