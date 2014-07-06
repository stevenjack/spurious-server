require 'docker'

module Spurious
  module Server
    module State
      class Init
        attr_accessor :connection

        def initialize(payload, connection)
          @payload    = payload
          @connection = connection
        end

        def execute!
          [1,2,3,4,5,6].each do |index|
            connection.send_data 'foo'
          end

          connection.unbind
        end

      end
    end
  end
end
