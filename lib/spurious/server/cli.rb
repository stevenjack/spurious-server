require "thor"
require "spurious/server"
require "spurious/server/options"
require "eventmachine"
require "em-synchrony"
require "spoon"

module Spurious
  module Server
    class CLI < Thor
      include Thor::Actions

      PID     = File.expand_path "~/.spurious-server.pid"
      TIMEOUT = 5

      namespace :"spurious-server"

      desc "start", "Starts the spurious-server as a daemon"
      def start
        check_and_clear_id
        if docker_daemon_available?
          say "Starting server...", :blue
          pid = can_fork? ? Process.fork(&server_proc) : Spoon.spawn(bin_path, "run-proc")
          say "Started with pid: ##{pid}", :green
          File.write(PID, pid)
        end
      end

      desc "status", "Shows the status of the spurious-server daemon"
      def status
        message = pid_exists? ? "Server running (pid: ##{pid})" : "Server not running"
        status  = pid_exists? ? :green : :red
        say message, status
      end

      desc "stop", "Stops the spurious-server daemon"
      def stop
        error "Server isn't running..." unless pid_exists?
        error "Process isn't runnng..." unless is_process_running?

        say "Stopping server...", :blue
        kill_process!
        say "Server successfully stopped", :green
      end

      desc "run-proc", "Runs the server proc"
      def run_proc
        server_proc.call
      end

      desc "restart", "Restarts the spurious-server daemon"
      def restart
        stop
        start
      end

      private

      def remove_pid!
        File.delete PID
      end

      def kill_process!
        Process.kill("HUP", pid)
        remove_pid!
      end

      def docker_daemon_available?
        say "Checking is docker daemon is available...", :blue
        Excon.defaults[:connect_timeout] = Excon.defaults[:read_timeout] = TIMEOUT
        Docker.info
        true
      rescue Excon::Errors::SocketError, Excon::Errors::Timeout, Docker::Error::TimeoutError => e
        error "Connection to the docker daemon (#{ENV["DOCKER_HOST"]}) failed... Check that it's running"
        false
      end

      def server_proc
        options            = Spurious::Server::Options.new ENV
        ENV["DOCKER_HOST"] = options.ssl_docker_host

        Proc.new do
          EventMachine.synchrony Spurious::Server.handle(options)
          exit
        end
      end

      def check_and_clear_id
        if pid_exists? && ! is_process_running?
          say "Process isn't running but PID file exists.. removing", :red
          File.delete PID
        elsif pid_exists?
          error "Server already running"
        end
      end

      def is_process_running?
        Process.getpgid pid.to_i
        true
      rescue Errno::ESRCH
        false
      end

      def error(message)
        say message, :red
        exit -1
      end

      def pid_exists?
        File.exists? PID
      end

      def pid
        File.read(PID).to_i
      end

      def can_fork?
        RUBY_PLATFORM != "java"
      end

      def bin_path
        File.absolute_path(
          File.join(
            File.dirname(__FILE__),
            "..",
            "..",
            "..",
            "bin",
            "spurious-server"
          )
        )
      end
    end
  end
end
