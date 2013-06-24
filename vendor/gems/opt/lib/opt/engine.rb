module Opt
  class Engine < ::Rails::Engine
    config.autoload_paths << File.join(self.root, 'lib') << File.join(self.root, 'core')
  end
end