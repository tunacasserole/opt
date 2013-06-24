Buildit::Framework.configure do
  # register this gem with the framework
  config.gems.opt            = {name: "opt", path: Opt::Engine.root.to_s, allow_unpacking: true}
  
  config.service_paths          += [File.join(Opt::Engine.root, "app/services", "**")]
  #config.model_paths            += [File.join(Opt::Engine.root, "app/models", "**")]
end # Buildit::Framework.configure

Opt::Engine.configure do
  config.i18n.load_path += Dir[Opt::Engine.root.join('config', 'locales', '**/*.{rb,yml}').to_s]  
end