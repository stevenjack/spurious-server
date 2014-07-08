require 'docker'
require 'peach'
require 'spurious/server'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Init < Base

        attr_accessor :completed_containers

        def execute!
          this = self
          completed_containers = 0

          app_config.each do |name, meta|
            image_meta = { 'fromImage' => meta[:image]}
            image_meta['Env'] = meta[:env] unless meta[:env].nil?

            container_operation = Proc.new do

              begin
                this.send "Creating container with name: #{name}"
                Docker::Container.create("name" => name, "Image" => meta[:image])
              rescue Exception => e
                case e.message
                when /409 Conflict/
                  this.error "Container with name: #{name} already exists"
                end
              end

            end

            container_callback = Proc.new do
              completed_containers = completed_containers + 1
              this.send("#{config.app.length} containers successfully initialized", true) if completed_containers == app_config.length
            end

            image_operation = Proc.new do
              this.send "Pulling #{name} from the public repo..."
              Docker::Image.create(image_meta)
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
