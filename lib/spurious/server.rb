require "spurious/server/version"
require "eventmachine"
require "spurious/server/app"

module Spurious
  module Server

    TIMEOUT     = 5
    SHELL_RED   = "\e[31m"
    SHELL_GREEN = "\e[32m"
    SHELL_CLEAR = "\e[0m"

    def self.docker_daemon_available?(daemon_action)
      if daemon_action == 'start'
        puts "#{SHELL_GREEN} Checking docker daemon is available...#{SHELL_CLEAR}"
        Excon.defaults[:connect_timeout] = Excon.defaults[:read_timeout] = TIMEOUT
        !Docker.info.nil?
      end
      true
    rescue Excon::Errors::SocketError, Excon::Errors::Timeout, Docker::Error::TimeoutError => e
      puts "#{SHELL_RED} Connecting to the docker daemon (#{ENV["DOCKER_HOST"]}) failed... Check that it's running"
      exit -1
    end

    def self.handle(options)
      Proc.new do
        EventMachine.start_server(
          options.server_ip,
          options.server_port,
          Spurious::Server::App,
          options
        )
      end
    end

  end
end
