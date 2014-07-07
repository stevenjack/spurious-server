require 'yaml'

module Spurious
  module Server
    class Config
      attr_accessor :app

      def initialize(config_location)
        @app = YAML::load_file(config_location)
      end

      def image_exists?(image_id)
        app.any? do |type, meta|
          meta[:image] == image_id
        end
      end

    end
  end
end
