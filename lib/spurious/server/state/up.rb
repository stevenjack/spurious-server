require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Up < Base

        def execute!
          spurious_containers.peach do |container|
            config = container_config(container.json["Name"])
            send "Starting container #{container.json["Name"]}..."
            meta = {"PublishAllPorts" => true}
            puts config
            meta["Links"] = config[:link] unless config[:link].nil?
            container.start meta
          end
          send "#{spurious_containers.length} containers successfully started"

          connection.unbind
        rescue Exception => e
          puts e.message
        end

      end
    end
  end
end
