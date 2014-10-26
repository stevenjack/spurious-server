module Spurious
  module Server
    class Options
      attr_reader :docker_full_path, :docker_host, :docker_port, :docker_api, :server_port, :server_ip, :write_timeout, :read_timeout, :cert_path

      def initialize(env)
        @docker_host      = env['DOCKER_HOST'].nil? ? 'localhost' : env['DOCKER_HOST'][/\/\/([0-9a-z\.]+):/,1]
        @docker_port      = env['DOCKER_HOST'].nil? ? nil : env['DOCKER_HOST'][/:([0-9]+)/,1]
        @docker_api       = !env['DOCKER_HOST'].nil?
        @server_port      = env.fetch('SPURIOUS_SERVER_PORT', 4590)
        @server_ip        = env.fetch('SPURIOUS_SERVER_IP', '0.0.0.0')
        @write_timeout    = env.fetch('EXCON_WRITE_TIMEOUT', 30000)
        @read_timeout     = env.fetch('EXCON_READ_TIMEOUT', 30000)
        @cert_path        = env.fetch('DOCKER_CERT_PATH', nil)
        setup_ssl if @cert_path
      end

      def ssl_docker_host
        "https://#{docker_host}:#{docker_port}"
      end

      protected

      def setup_ssl
        Docker.options = {
          :client_cert => valid_cert_path?('cert.pem'),
          :client_key  => valid_cert_path?('key.pem'),
          :ssl_ca_file => valid_cert_path?('ca.pem')
        }
      end

      def valid_cert_path?(cert)
        File.join(absolute_cert_path, cert).tap do |path|
          raise "Could not find: #{path}, please check it exists in your DOCKER_CERTS_PATH folder" unless File.exists? path
        end
      end

      def absolute_cert_path
        @absolute_cert_path ||= File.expand_path cert_path
      end
    end
  end
end
