require 'docker'
require 'peach'
require 'spurious/server/state/base'
require 'net/http'

module Spurious
  module Server
    module State
      class Start < Base
        attr_accessor :docker_host_ip

        def initialize(connection, config, docker_host_ip)
          super(connection, config)
          connection_timeouts 2, 600, 600
          @docker_host_ip = docker_host_ip
        end

        def execute!
          started_containers = 0

          raise "Containers haven't been initialised, please run 'spurious init' first." if spurious_containers.length == 0

          spurious_containers.each do |container|
            begin
              started_containers = started_containers + 1
              config = container_config(container.json["Name"])
              send "Starting #{container.json["Name"].gsub('/', '')}", :debug
              meta = {}.tap do |m|
                m["PublishAllPorts"] = true
                m["Links"] = config[:link] unless config[:link].nil?
              end

              container.start meta

              if container.json["Name"] == '/spurious-sqs' then
                port_setup = Proc.new do
                  begin
                    container_config = app_config['spurious-sqs']
                    port = container.json["NetworkSettings"]["Ports"]['4568/tcp'].first['HostPort']
                    Net::HTTP.get(URI("http://#{docker_host_ip}:#{port}/host-details?host=#{container_config[:hostname]}&port=#{port}"))
                  rescue StandardError => e
                  end
                end
                EM.add_timer(5) { EM.defer(port_setup) }
              end
            rescue Exception => e
              started_containers = started_containers - 1
              case e.message
              when /304 Not Modified/
                error('Container is already running...')
              else
                error(e.message)
              end
            end
          end

          send("Started #{started_containers} containers", :info, true, :green)
        end

      end
    end
  end
end
