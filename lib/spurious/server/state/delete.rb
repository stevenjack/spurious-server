require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Delete < Base

        def execute!
          spurious_containers.peach do |container|
            send "Removing container #{container.json["Name"]}..."
            container.tap do |c|
              c.kill
              c.delete(:force => true)
            end
          end
          send "#{spurious_containers.length} containers successfully removed"

          connection.unbind
        rescue Exception => e
          puts e.message
        end
      end
    end
  end
end
