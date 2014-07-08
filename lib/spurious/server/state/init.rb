require 'docker'
require 'peach'
require 'spurious/server'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Init < Base

        def execute!

          app_config.each do |name, meta|
            begin
              send "Pulling #{name} from the public repo..."
              image_meta = { 'fromImage' => meta[:image]}
              image_meta['Env'] = meta[:env] unless meta[:env].nil?
              Docker::Image.create(image_meta)

              send "Creating container with name: #{name}"
              Docker::Container.create("name" => name, "Image" => meta[:image])

            rescue Exception => e
              case e.message
              when /409 Conflict/
                puts "Container with name: #{name} already exists"
              end
            end
          end

          send "#{config.app.length} containers successfully initialized"
#          connection.close_connection
        end

      end
    end
  end
end
