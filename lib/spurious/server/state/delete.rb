require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Delete < Base

        def initialize(connection, config)
          super
          connection_timeouts 1, 15, 5
        end

        def execute!
          containers = spurious_containers.length
          spurious_containers.peach do |container|
            container_name = container.json["Name"]
            send "Removing container #{container_name}..."
            container.tap do |c|
              c.kill
              c.delete(:force => true)
            end
            send "Container #{container_name} removed"
            image = config.for(container_name.gsub('/', ''))[:image]
            send "Removing image #{image}..."
            Docker::Image.create('fromImage' => image).tap do |image|
              image.remove(:force => true)
            end
            send "Image #{container_name} removed"
          end
          send "#{containers} containers successfully removed", true
        rescue Exception => e
          puts e.backtrace
          puts e.message
        end
      end
    end
  end
end
