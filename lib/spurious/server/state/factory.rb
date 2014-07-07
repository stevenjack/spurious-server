require 'spurious/server/state/init'
require 'spurious/server/state/error'

module Spurious
  module Server
    module State
      module Factory

        def self.create(type, connection, config)
          case type
          when :init
            Init.new(connection, config)
          else
            Error.new("Type: #{type} is not recognised", connection)
          end
        end

      end
    end
  end
end
