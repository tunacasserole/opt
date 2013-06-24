class Opt::Gen::Initializer

  def self.run!
    Buildit::Framework.configuration.scaffolders.buildit_service -= [Buildit::Gen::Scaffold::Service::SearchWorker]
    Buildit::Framework.configuration.scaffolders.buildit_service -= [Buildit::Gen::Scaffold::Service::StateWorker]    
    Buildit::Framework.configuration.scaffolders.buildit_service -= [Buildit::Gen::Scaffold::Service::ModelWorker]      
    #Buildit::Framework.configuration.scaffolders.buildit_client -= [Buildit::Gen::Scaffold::Desktop::ExplorerWorker]    
    Buildit::Framework.configuration.scaffolders.buildit_service += [Opt::Gen::SearchWorker]
    Buildit::Framework.configuration.scaffolders.buildit_service += [Opt::Gen::StateWorker]
    Buildit::Framework.configuration.scaffolders.buildit_service += [Opt::Gen::ModelWorker]    
    #Buildit::Framework.configuration.scaffolders.buildit_client += [Opt::Gen::ExplorerWorker]    
  end
end