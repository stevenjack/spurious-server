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
            a_config = app_config[container.json['Name'].gsub('/', '')]
            config = container_config(container.json["Name"])
            ports[sanitize(container.json["Name"])] = []

            if !container.json["NetworkSettings"]["Ports"].nil? then
              host = a_config

              container.json["NetworkSettings"]["Ports"].each do |guest, mapping|
                mapping.each do |map|
                  ports[sanitize(container.json["Name"])] << {
                    :Host       => a_config.fetch(:hostname, docker_host_ip),
                    :HostPort   => map["HostPort"]
                 }
                end
              end

            end

          end
          send ports, :info, true

          connection.unbind
        rescue Exception => e
          puts e.message
          raise('There was a problem connecting to the Docker API (check that docker is running or if not running under linux check the VM hosting docker is running and the API is accesbile')
        end

      end
    end
  end
end
