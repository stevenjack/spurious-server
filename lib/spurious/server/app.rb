require "spurious/server/state/factory"
require "spurious/server/config"

require "eventmachine"
require "json"

module Spurious
  module Server
    class App < EventMachine::Connection
      attr_accessor :options

      def initialize(options)
        @options = options
      end

      def receive_data data
          payload = parse_payload data
          state(payload[:type]).execute!
      rescue Excon::Errors::Timeout, Excon::Errors::SocketError => e
          error('Connection to the docker daemon has failed, please check that docker is running on the host or VM', true)
      rescue StandardError => e
        state(:error).tap { |s| s.message = "" }.execute!
      end

      def error(message, close = false)
        send_data "#{JSON.generate({:type => 'error', :response => message, :close => close, :colour => :red})}\n"
      end

      protected

      def state(type)
        Spurious::Server::State::Factory.create(type, self, config, options)
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
