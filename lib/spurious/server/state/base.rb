require 'docker'
require 'peach'
require 'spurious/server'
require 'excon'

module Spurious
  module Server
    module State
      class Base
        attr_accessor :connection, :config

        def initialize(connection, config)
          @connection      = connection
          @config          = config
          connection_timeouts
        end

        def connection_timeouts(connect = 1, read = 5, write = 5)
          Excon.defaults[:write_timeout]   = write
          Excon.defaults[:read_timeout]    = read
          Excon.defaults[:connect_timeout] = connect
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

        def send(data, close = false, colour = :white)
          connection.send_data "#{JSON.generate({:type => state_identifer, :response => data, :close => close, :colour => colour})}\n"
        end

        def error(message, close = false)
          connection.error(message, close)
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


