require "docker"
require "json"

module Spurious
  module Server
    module State
      class Error
        attr_reader :message, :connection

        def initialize(message, connection)
          @message    = message
          @connection = connection
        end

        def execute!
          send :type => 'error', :response => { :message => message }
        end

        protected

        def send(data)
          connection.send_data JSON.generate(data)
        end

      end
    end
  end
end
