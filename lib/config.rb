require 'singleton'
module CashDash
  class Config 
    include Singleton
    def get_config
      if @config.nil?
        config_path = File.join(File.dirname(__FILE__), '..', 'config.yml')
        @config = YAML::load(File.new(config_path))
      else
        @config
      end
    end
  end
end
