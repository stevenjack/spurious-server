require "spurious/server/state/factory"
require "spurious/server/config"

require "eventmachine"
require "json"

module Spurious
  module Server
    class App < EventMachine::Connection

      def receive_data data
        payload = parse_payload data
        state(payload[:type]).execute!
      rescue Exception => e
        state(:error).tap { |s| s.message = "JSON payload malformed" }.execute!
      end

      protected

      def state(type)
        Spurious::Server::State::Factory.create(type, self, config)
      end

      def config
        @config ||= Spurious::Server::Config.new(config_location).app
      end

      def config_location
        File.join(File.dirname(__FILE__), '..','..', '..', 'config', 'images.yaml')
      end

      def parse_payload(payload)
        JSON.parse(payload.strip, :symbolize_names => true)
      end

    end
  end
end
