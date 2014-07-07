require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Ports < Base

        def execute!
          ports = {}
          spurious_containers.peach do |container|
            config = container_config(container.json["Name"])
            ports[sanitize(container.json["Name"])] = []
puts "Container: #{container.json["Name"]} ports: ", container.json["NetworkSettings"]["Ports"]

            container.json["NetworkSettings"]["Ports"].each do |guest, mapping|
              ports[sanitize(container.json["Name"])] << {
                :GuestPort  => guest.split('/').first,
                :HostPort   => mapping["HostPort"]
              }
            end

          end
puts ports
          send ports

          connection.unbind
        rescue Exception => e
          puts e.message
        end

      end
    end
  end
end
