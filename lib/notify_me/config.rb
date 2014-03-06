require 'delegate'
require 'yaml'
require 'singleton'

module NotifyMe
  class Config < SimpleDelegator

    include Singleton

    def self.deploy() instance.deploy; end
    def self.app() instance.app; end

    def initialize
      config_file = File.expand_path(File.join('..', '..', '..', 'config', 'config.yml'), __FILE__)
      raise "Configuration file '#{config_file}' is misssing!" unless File.exist?(config_file)

      config = YAML.load_file(config_file)
      super(Hashie::Mash.new(config))
    end
  end
end
