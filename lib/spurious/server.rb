require "spurious/server/version"
require "eventmachine"
require "spurious/server/app"

module Spurious
  module Server

    @@containers = []

    def self.add_container(name, meta)
      @@containers[name] = meta
    end

    def self.get_container(name)
      @@containers[name]
    end

    def self.run!
      EventMachine.start_server '0.0.0.0', 4590, Spurious::Server::App
    end

  end
end
