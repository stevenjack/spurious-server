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
          send("[status] Pulling containers from the registry can take some time, please be patient...", false, :blue)

          containers = app_config.length
          index = 0

          app_config.each do |name, meta|
            image_meta = {}.tap do |h|
              h['fromImage'] = meta[:image]
              h['Env']       = meta[:env] unless meta[:env].nil?
            end

            if meta[:image] == 'smaj/spurious-s3'
              container_cmd = ['-h', docker_host]
            end

            create_container = Proc.new do
              begin
                send "[creating] #{name} container"
                Docker::Container.create("name" => name, "Image" => meta[:image], 'Cmd' => container_cmd)
                index = index + 1
                operation_complete(containers == index)
              rescue Docker::Error::ArgumentError, Docker::Error::NotFoundError
              rescue Excon::Errors::Conflict
                error "[error] #{name} container already exists"
              rescue Exception => e
                error "[error] creating container: #{e.message}"
              end
            end

            create_image = Proc.new do
              begin
                send "[registry] pulling latest for #{name}"
                Docker::Image.create(image_meta)
              rescue Docker::Error::ArgumentError, Docker::Error::NotFoundError
              end
            end

            EM.defer(create_image, create_container)
          end

        end

        def operation_complete(complete)
          send("[status] 6 containers successfully initialized", true, :green) if complete
        end

      end
    end
  end
end
