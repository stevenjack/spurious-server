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
          @docker_host_ip = docker_host_ip
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
                Thread.new do
                  sleep 5
                  port = container.json["NetworkSettings"]["Ports"]['4568/tcp'].first['HostPort']
                  Net::HTTP.get(URI("http://#{docker_host_ip}:#{port}/host-details?host=#{docker_host_ip}&port=#{port}"))
                end
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
