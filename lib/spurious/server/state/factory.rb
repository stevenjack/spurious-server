require 'spurious/server/state/init'
require 'spurious/server/state/start'
require 'spurious/server/state/stop'
require 'spurious/server/state/delete'
require 'spurious/server/state/update'
require 'spurious/server/state/ports'
require 'spurious/server/state/error'

module Spurious
  module Server
    module State
      module Factory

        def self.create(type, connection, config, options)
          case type.to_sym
          when :init
            Init.new(connection, config)
          when :start
            Start.new(connection, config, options.docker_host)
          when :stop
            Stop.new(connection, config)
          when :ports
            Ports.new(connection, config, options.docker_host)
          when :delete
            Delete.new(connection, config)
          when :update
            Update.new(connection, config)
          when :error
            Error.new(connection)
          else
            Error.new(connection, "Type: #{type} is not recognised")
          end
        end

      end
    end
  end
end
