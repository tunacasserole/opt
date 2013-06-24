#
#                   Copyright (c) 2012 BUILDIT.IO, Inc.
#                          ALL RIGHTS RESERVED
#
#  THIS PROGRAM CONTAINS PROPRIETARY INFORMATION OF BUILDIT.IO, INC.
#  --------------------------------------------------------------------
#
#  THIS PROGRAM CONTAINS THE CONFIDENTIAL AND/OR PROPRIETARY INFORMATION
#  OF BUILDIT.IO, INC. ANY DUPLICATION, MODIFICATION, DISTRIBUTION, PUBLIC
#  PERFORMANCE, OR PUBLIC DISPLAY OF THIS PROGRAM, OR ANY PORTION OR
#  DERIVATION THEREOF WITHOUT THE EXPRESS WRITTEN CONSENT OF
#  BUILDIT.IO, INC. IS STRICTLY PROHIBITED.  USE OR DISCLOSURE OF THIS
#  PROGRAM DOES NOT CONVEY ANY RIGHTS TO REPRODUCE, DISCLOSE OR DISTRIBUTE
#  ITS CONTENTS, OR TO MANUFACTURE, USE, OR SELL ANYTHING THAT CONTAINS IN
#  WHOLE OR IN PART ANY ASPECT OF THIS PROGRAM.
#

class Opt::Gen::ModelWorker < Buildit::Gen::Scaffold::Worker
  
  # when invoked, this method will clear out all files and directories related to the supplied model.
  def self.destroy(model)
    initiate "Destroying the server model"
    base_folder  = File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'core', model.namespace.underscore)
    file_name    = File.join(base_folder, "#{model.model_name.underscore}.rb")
    
    model_folder = File.join(base_folder, model.model_name.underscore)
    
    FileUtils.rm_rf(model_folder) if File.exists? model_folder
    FileUtils.rm_rf(file_name)   if File.exists? file_name
    complete
  end
  
  # this method is responsible for building the model file and related files if they do not already exist. This should be a simple
  # file generation based on ERB. The primary files that will be created by this worker are;
  #   - vendor/gems/[package_name]/core/[model_name].rb
  #
  # In addition to creating this file, it will also pass control to other registered workers to determine if they want to
  # contribute to the file given the importance it plays. The method will start by preparing the initial structure of the file.
  # Once completed it will pass control to those workers that plan to participate via the [prepare_model] method. After each
  # registered worker is processed, the method will complete the contents of the file by closing out the class definition.
  def self.prepare(model)
    initiate "Preparing the server model"
    base_folder = File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'core', model.namespace.underscore)
    FileUtils.mkdir_p(base_folder)
    
    file_name = File.join(base_folder, "#{model.model_name.underscore}.rb")
    
    unless File.exists? file_name
      content = ::ERB.new(self.template_start).result(binding)
      Buildit::Framework.configuration.scaffolders.buildit_service.each do |worker|
        content << "\n\n" << worker.send(:prepare_model, model) if worker.respond_to? :prepare_model
      end
      content << ERB.new(self.template_end).result(binding)
      File.open(file_name, 'w') {|file| file.puts content}
    end
    complete
  end

  
  # the following is the primary processing method for this worker responsible for processing the models primary configuration file. This worker will
  # in turn pass control to other registered workers that wish to participate in the processing of the model file. This will be evident for each 
  # worker that implements the process_model method.
  def self.process(model)
    initiate "Creating the server model"
    file_name = File.join(Rails.root.to_s, 'vendor', 'gems', model.package_name, 'core', "#{model.namespace.underscore}", "#{model.model_name.underscore}.rb")
    contents = Buildit::Util::File.read_contents(file_name)
    
    Buildit::Framework.configuration.scaffolders.buildit_service.each do |worker|
      contents = worker.send(:process_model, model, contents) || contents if worker.respond_to? :process_model
    end
    
    File.open(file_name, 'w') { |file| file.puts contents}
    complete
  end
  
  
  private
  
  # the following is the baseline template for the start of the model file. Unlike other prepare methods seen on different
  # construction workers, this one allows other workers to contribute to the generation of the initial template. The start is
  # the initial class definition and the basic metadata needed for the model. All other template setup activities will be the
  # responsibility of the individual registered workers.
  def self.template_start
<<-EOF
class <%= model.namespace %>::<%= model.model_name %> < ActiveRecord::Base

  # MIXINS (Start) ======================================================================
  include <%= model.namespace %>::<%= model.model_name %>::Helpers
  # MIXINS (End)


  # METADATA (Start) ====================================================================
  self.table_name   = :<%= model.table_name %>
  self.primary_key  = :<%= model.primary_attribute %>
  # METADATA (End)
EOF
  end
  
  # this method provides the finalization content of the initial template. Unless any special handling is required, it is
  # assumed that this will close the class definition only.
  def self.template_end
<<-EOF

end # class <%= model.namespace %>::<%= model.model_name %>

EOF
  end
end