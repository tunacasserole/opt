Buildit::Framework.configure do  
  config.initializers                     += [Opt::Gen::Initializer]
end


Buildit::Framework.register_scaffolders(:opt, :service, [

  # register generators
  Opt::Gen::Worker,
  #Opt::Gen::CsvWorker,
  #Opt::Gen::ExcelWorker,
  Opt::Gen::HubWorker,
  #Opt::Gen::SearchWorker

])

