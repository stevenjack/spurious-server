require 'yaml'

module Spurious
  module Server
    class Config
      attr_accessor :app

      def initialize(config_location)
        @app = YAML::load_file(config_location)
      end

      def name_exists?(name)
        app.has_key? name
      end

      def for(name)
        app[name]
      end

    end
  end
end
