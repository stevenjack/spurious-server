module Spurious
  module Server
    class Options
      attr_reader :docker_full_path, :docker_host, :docker_port, :docker_api, :server_port, :server_ip, :write_timeout, :read_timeout

      def initialize(env)
        @docker_host      = env['DOCKER_HOST'].nil? ? 'localhost' : env['DOCKER_HOST'][/\/\/([0-9\.]+):/,1]
        @docker_port      = env['DOCKER_HOST'].nil? ? nil : env['DOCKER_HOST'][/:([0-9]+)/,1]
        @docker_api       = !env['DOCKER_HOST'].nil?
        @server_port      = env.fetch('SPURIOUS_SERVER_PORT', 4590)
        @server_ip        = env.fetch('SPURIOUS_SERVER_IP', '0.0.0.0')
        @write_timeout    = env.fetch('EXCON_WRITE_TIMEOUT', 30000)
        @read_timeout     = env.fetch('EXCON_READ_TIMEOUT', 30000)
      end

    end
  end
end
