require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Stop < Base

        def execute!
          spurious_containers.peach do |container|
            send "Stopping container #{container.json["Name"]}..."
            container.stop
          end
          send "#{spurious_containers.length} containers successfully stopped", true

          connection.unbind
        rescue Exception => e
          puts e.message
        end
      end
    end
  end
end
