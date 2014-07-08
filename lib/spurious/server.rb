require "spurious/server/version"
require "eventmachine"
require "spurious/server/app"

module Spurious
  module Server

    def self.handle(ip, port)
      Proc.new do
        EventMachine.start_server ip, port, Spurious::Server::App
      end
    end

  end
end
