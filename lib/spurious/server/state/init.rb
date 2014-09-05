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
          @docker_host = docker_host
        end

        def execute!
          this = self
          completed_containers = 0

          app_config.each do |name, meta|
            image_meta = { 'fromImage' => meta[:image]}
            image_meta['Env'] = meta[:env] unless meta[:env].nil?
            container_cmd = []

            if meta[:image] == 'smaj/spurious-s3'
              container_cmd = ['-h', docker_host]
            end

            container_operation = Proc.new do

              begin
                this.send "Creating container with name: #{name}"
                Docker::Container.create("name" => name, "Image" => meta[:image], 'Cmd' => container_cmd)
              rescue Exception => e
                case e.message
                when /409 Conflict/
                  this.error "Container with name: #{name} already exists"
                else
                  this.error "Error creating container: #{e.message}"
                end
              end

            end

            container_callback = Proc.new do
              completed_containers = completed_containers + 1
              this.send("#{config.app.length} containers successfully initialized", true) if completed_containers == app_config.length
            end

            image_operation = Proc.new do
              begin
                this.send "Pulling #{name} from the public repo..."
                Docker::Image.create(image_meta)
              rescue Exception => e
                this.error "Error pulling down image: #{e.message}"
              end

            end

            image_callback = Proc.new do
              EM.add_timer(1) do
                EM.defer(container_operation, container_callback)
              end
            end

            EM.add_timer(1) do
              EM.defer(image_operation, image_callback)
            end
          end

        end

      end
    end
  end
end
