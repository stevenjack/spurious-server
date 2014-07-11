require "spurious/server/state/factory"
require "spurious/server/config"

require "eventmachine"
require "json"

module Spurious
  module Server
    class App < EventMachine::Connection

      def initialize(docker_host)
        @docker_host = docker_host
      end

      def docker_host_ip
        @docker_host[/\/\/([0-9\.]+):/,1]
      end

      def receive_data data
          payload = parse_payload data
          state(payload[:type]).execute!
      rescue Exception => e
        puts e.message
        state(:error).tap { |s| s.message = "JSON payload malformed" }.execute!
      end

      protected

      def state(type)
        Spurious::Server::State::Factory.create(type, self, config, docker_host_ip)
      end

      def config
        @config ||= Spurious::Server::Config.new(config_location)
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
