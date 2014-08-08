require "spurious/server/version"
require "eventmachine"
require "spurious/server/app"

module Spurious
  module Server

    def self.handle(options)
      Proc.new do
        EventMachine.start_server(
          options.server_ip,
          options.server_port,
          Spurious::Server::App,
          options.docker_host
        )
      end
    end

  end
end
