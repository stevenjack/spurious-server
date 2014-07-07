require 'yaml'

module Spurious
  module Server
    class Config
      attr_accessor :app

      def initialize(config_location)
        @app = YAML::load_file(config_location)
      end

    end
  end
end
