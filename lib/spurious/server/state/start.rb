require 'docker'
require 'peach'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Start < Base
        attr_accessor :host_ip

        def initialize(connnection, config, host_ip)
          super(connection, config)
          @host_ip = host_ip
        end

        def execute!
          spurious_containers.each do |container|
            config = container_config(container.json["Name"])
            send "Starting container #{container.json["Name"]}..."
            meta = {"PublishAllPorts" => true}
            meta["Links"] = config[:link] unless config[:link].nil?
            container.start meta

            if container.json["Name"] == 'spurious-sqs' then
              port = container.json["NetworkSettings"]["Ports"]['4568/tcp'].first['HostPort']
              `curl http://#{host_ip}:#{port}/host-details?host=#{host_ip}&port=#{port}`
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
