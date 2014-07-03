require "spurious/server/version"
require "eventmachine"
require "spurious/server/app"

module Spurious
  module Server

    def self.run!
      EventMachine.start_server '0.0.0.0', 4590, Spurious::Server::App
    end

  end
end
