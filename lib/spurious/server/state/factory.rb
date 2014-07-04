require 'spurious/server/state/init'

module Spurious
  module Server
    module State
      module Factory

        def self.create(payload, app)
          case payload[:type]
          when :init
            Init.new(payload, app)
          end
        end

      end
    end
  end
end
