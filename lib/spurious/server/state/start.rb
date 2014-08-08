require 'docker'
require 'peach'
require 'spurious/server/state/base'
require 'net/http'

module Spurious
  module Server
    module State
      class Start < Base
        attr_accessor :docker_host

        def initialize(connection, config, docker_host)
          super(connection, config)
          @docker_host = docker_host
        end

        def execute!
          started_containers = 0
          spurious_containers.each do |container|
            begin
              started_containers = started_containers + 1
              config = container_config(container.json["Name"])
              send "Starting container #{container.json["Name"]}..."
              meta = {"PublishAllPorts" => true}
              meta["Links"] = config[:link] unless config[:link].nil?
              container.start meta

              if container.json["Name"] == '/spurious-sqs' then
                port_setup = Proc.new do
                  port = container.json["NetworkSettings"]["Ports"]['4568/tcp'].first['HostPort']
                  Net::HTTP.get(URI("http://#{docker_host}:#{port}/host-details?host=#{docker_host}&port=#{port}"))
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

          send "#{started_containers} containers successfully started", true

          connection.unbind
        rescue Exception => e
          puts e.message
        end

      end
    end
  end
end
