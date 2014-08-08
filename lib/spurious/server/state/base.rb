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
            config.name_exists?(sanitize(container.json["Name"]))
          end.sort do |e1, e2|
            app_config.keys.index(sanitize(e1.json["Name"])) <=> app_config.keys.index(sanitize(e2.json["Name"]))
          end
        end

        def app_config
          config.app
        end

        def container_config(image)
          config.for sanitize(image)
        end

        def send(data, close = false)
          connection.send_data "#{JSON.generate({:type => state_identifer, :response => data, :close => close})}\n"
        end

        def error(message, close = false)
          connection.send_data "#{JSON.generate({:type => 'error', :response => message, :close => close})}\n"
        end

        def sanitize(name)
          name.gsub('/', '')
        end

        def docker_available?

        end

        private

        def state_identifer
          self.class.to_s.downcase.split("::").last
        end

      end
    end
  end
end


