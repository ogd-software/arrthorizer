module Arrthorizer
  module Rails
    class Configuration
      FileNotFound = Class.new(Arrthorizer::ArrthorizerException)

      def self.load
        # Convert the configuration file contents to
        # a runtime configuration.
      end

      def self.config
        @config ||= YAML.load_file(config_file_location)
      rescue Errno::ENOENT
        raise FileNotFound, "Arrthorizer requires a config file at #{config_file_name}"
      end

      def self.config_file_location
        ::Rails.root.join config_file_name
      end

      def self.config_file_name
        "config/arrthorizer.yml"
      end
    end
  end
end