require 'docker'

module Spurious
  module Server
    module State
      class Init
        attr_accessor :connection, :config

        def initialize(connection, config)
          @connection = connection
          @config     = config
        end

        def execute!
          config.each do |type, meta|
            send "Pulling #{meta[:image]} from the public repo..."
            Docker::Image.create('fromImage' => meta[:image])
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
