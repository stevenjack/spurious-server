require 'docker'
require 'peach'
require 'spurious/server'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Init < Base
        attr_accessor :completed_containers, :docker_host

        def initialize(connection, config, docker_host)
          super(connection, config)
          connection_timeouts 2, 600, 600
          @docker_host = docker_host
        end

        def execute!

          raise "Containers have already been initilised, please run 'spurious start'" if spurious_containers.length > 0



          send("Pulling containers from the registry can take some time, please be patient...", :info, false, :blue)

          containers = app_config.length
          index = 0

          app_config.each do |name, meta|
            image_meta = {}.tap do |h|
              h['fromImage'] = meta[:image]
              h['Env']       = meta[:env] unless meta[:env].nil?
            end
            container_cmd = []

            if meta[:image] == 'smaj/spurious-s3'
              container_cmd = ['-h', meta[:hostname]]
            end

            create_container = Proc.new do
              begin
                send "Creating #{name} container", :debug
                Docker::Container.create("name" => name, "Image" => meta[:image], 'Cmd' => container_cmd)
              rescue Docker::Error::ArgumentError, Docker::Error::NotFoundError
              rescue Excon::Errors::Conflict
                error "#{name} container already exists"
              end
              index = index + 1
              operation_complete(containers == index)
            end

            create_image = Proc.new do
              begin
                send "Pulling latest version of #{name} from registry", :debug
                Docker::Image.create(image_meta)
              rescue Docker::Error::ArgumentError, Docker::Error::NotFoundError, Excon::Errors::Timeout, Excon::Errors::SocketError
              end
            end

            EM.defer(create_image, create_container)
          end
        end

        def operation_complete(complete)
          if complete
            send("#{app_config.length} containers successfully initialized", :info, false, :green)
            send("Please add the following to your /etc/hosts file:\n\n#{docker_host} spurious.sqs.local spurious.s3.local spurious.dynamodb.local spurious.browser.local\n", :info, true, :blue)
          end
        end

      end
    end
  end
end
