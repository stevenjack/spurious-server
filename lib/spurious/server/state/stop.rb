require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Stop < Base

        def initialize(connection, config)
          super
          connection_timeouts 2, 600, 600
        end

        def execute!
          containers = spurious_containers.length - 1

          spurious_containers.each_with_index do |container, index|
            stop_containers = Proc.new do

              send "Stopping #{container.json["Name"].gsub('/', '')}", :debug
              container.stop
              index_to_check = index + 1
              containers == index_to_check
            end
            EM.defer(stop_containers, operation_complete)
          end
        end

        def operation_complete
          Proc.new do |complete|
            send("Stopped 6 containers", :info, true, :green) if complete
          end
        end

      end
    end
  end
end
