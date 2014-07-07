require 'docker'
require 'peach'
require 'spurious/server'

module Spurious
  module Server
    module State
      class Base
        attr_accessor :connection, :config

        def initialize(connection, config)
          @connection = connection
          @config     = config
        end

        def execute!
          raise NotImplementedError("You must implement execute!")
        end

        protected

        def spurious_containers
          Docker::Container.all(:all => true).select do |container|
            config.name_exists?(container.json["Name"])
          end
        end

        def app_config
          config.app
        end

        def container_config(image)
          config.for image
        end

        def send(data)
          connection.send_data JSON.generate({:type => state_identifer, :response => data}) + "\n"
        end

        private

        def state_identifer
          self.class.to_s.downcase.split("::").last
        end

      end
    end
  end
end


