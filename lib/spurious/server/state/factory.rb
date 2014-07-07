require 'spurious/server/state/init'
require 'spurious/server/state/error'

module Spurious
  module Server
    module State
      module Factory

        def self.create(type, connection, config)
          case type.to_sym
          when :init
            Init.new(connection, config)
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
