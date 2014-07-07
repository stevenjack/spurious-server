require "docker"
require "json"

module Spurious
  module Server
    module State
      class Error
        attr_reader :connection
        attr_accessor :message

        def initialize(connection, message = nil)
          @connection = connection
          @message    = message
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
