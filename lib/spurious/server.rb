require "spurious/server/version"
require "eventmachine"
require "spurious/server/app"

module Spurious
  module Server

    def self.handle(ip, port, docker_host)
      Proc.new do
        EventMachine.start_server ip, port, Spurious::Server::App, docker_host
      end
    end

  end
end
