require 'docker'

module Spurious
  module Server
    module State
      class Init
        attr_accessor :connection, :config

        def initialize(payload, connection, config)
          @payload    = payload
          @connection = connection
          @config     = config
        end

        def execute!
          config.each_key do |image|
            send "Pulling #{image} from the public repo..."
            Docker::Image.create('fromImage' => image)
          end
          send "#{config.length} containers successfully initialized"

          connection.unbind
        end

        protected

        def send(data)
          connection.send_data data
        end

      end
    end
  end
end
