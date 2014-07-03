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
          payload[:response] = 'Foo'
        else
          payload.tap do |p|
            p[:response] = { :message => "Type: #{payload[:type]} is not recognised" } unless p[:type] == 'error'
            p[:type] = 'error'
          end
        end

        send_payload payload
      end

      protected

      def parse_payload(payload)
        JSON.parse(payload, :symbolize_names => true)
      rescue
        error("JSON payload malformed")
      end

      def send_payload(payload)
        send_data(JSON.generate(payload))
      end

      def error(message)
        {:type => 'error', :response => { :message => message}}
      end

    end
  end
end
