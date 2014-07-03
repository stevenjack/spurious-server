require "eventmachine"
require "json"

module Spurious
  module Server
    class App < EventMachine::Connection
      attr_accessor :state_factory

      def intialize(state_factory)
        @state_factory = state_factory
      end

      def receive_data data
        payload = parse_payload data

        case payload[:type]
        when "init"
          send_data "Foo"
        end
      end

      protected

      def parse_payload(payload)
        JSON.parse(payload, :symbolize_names => true)
      rescue
        error("JSON payload malformed")
      end

      def error(message)
        JSON.generate({:error => message})
      end



    end
  end
end
