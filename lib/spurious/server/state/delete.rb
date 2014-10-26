require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Delete < Base

        def initialize(connection, config)
          super
          connection_timeouts 2, 600, 600
        end

        def execute!
          containers = spurious_containers.length - 1

          spurious_containers.each_with_index do |container, index|
            container_name   = container.json["Name"].gsub('/', '')
            container_config = config.for(container_name)
            container_meta   = container.json

            remove_container = Proc.new do
              send "Removing #{container_name}", :debug
              container.delete(:force => true)

              unless container_config[:ignore] && container_config[:ignore][:delete]
                image = container_config[:image]

                Docker::Image.get(container_meta["Image"]).tap do |image|
                  image.remove(:force => true)
                end
              end

              index_to_check = index + 1
              containers == index_to_check
            end

            EM.defer(remove_container, operation_complete)

          end
        end

        def operation_complete
          Proc.new do |complete|
            send("5 containers successfully removed", :info, true, :green) if complete
          end
        end
      end
    end
  end
end
