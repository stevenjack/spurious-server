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
          spurious_containers.each do |container|
            begin
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
              error(e.message)
            end
          end

          send "#{spurious_containers.length} containers successfully started", true

          connection.unbind
        rescue Exception => e
          puts e.message
        end

      end
    end
  end
end
