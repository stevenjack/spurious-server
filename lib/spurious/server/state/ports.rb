require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Ports < Base

        attr_accessor :docker_host_ip

        def initialize(connection, config, docker_host_ip)
          super(connection, config)
          @docker_host_ip = docker_host_ip
        end

        def execute!
          ports = {}
          spurious_containers.peach do |container|
            config = container_config(container.json["Name"])
            ports[sanitize(container.json["Name"])] = []

            if !container.json["NetworkSettings"]["Ports"].nil? then

              container.json["NetworkSettings"]["Ports"].each do |guest, mapping|
                mapping.each do |map|
                  ports[sanitize(container.json["Name"])] << {
                    :Host       => docker_host_ip,
                    :HostPort   => map["HostPort"]
                 }
                end
              end

            end

          end
          send ports, true

          connection.unbind
        rescue Exception => e
          puts e.message
        end

      end
    end
  end
end
