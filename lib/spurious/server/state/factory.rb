require 'spurious/server/state/init'

module Spurious
  module Server
    module State
      module Factory

        def self.create(payload, *args)
          case payload[:type]
          when :init
            Init.new(payload, *args)
          end
        end

      end
    end
  end
end
