require "eventmachine"
require "json"

module Spurious
  module Server
    class App < EventMachine::Connection

      def receive_data data
        payload = parse_payload data
        state(payload[:type]).execute!
      rescue Exception => e
        send_payload error("JSON payload malformed")
      end

      protected

      def state(type)
        Spurious::Server::State::Factory.create(type, self, config)
      end

      def config
        @config ||= Spurious::Server::Config.new(config_location)
      end

      def config_location
        File.join(File.dirname(__FILE__), '..','..', '..', 'config', 'images.yaml')
      end

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
