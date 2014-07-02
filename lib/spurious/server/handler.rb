require 'docker'

module Spurious
  module Server
    class Handler

      attr_accessor :config

      @@current_status = 'nothing'

      def initialize(config)
        @config = config
      end

      def call(type)
        {:}.tap do |payload|
          config.each_key do |image|
            say "Pulling #{image} from the public repo...", :green
            Docker::Image.create('fromImage' => image)
          end
          say "#{config.length} containers successfully initialized"
        end
      end

    end
  end
end
