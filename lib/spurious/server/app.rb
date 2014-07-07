require "eventmachine"
require "json"

module Spurious
  module Server
    class App < EventMachine::Connection

      def receive_data data
        payload = parse_payload data
        state(payload[:type]).execute!
      rescue
        state(:error).tap { |s| s.message = "JSON payload malformed" }.execute!
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
      end

    end
  end
end
