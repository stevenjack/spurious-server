require 'docker'
require 'peach'
require 'json'
require 'spurious/server/state/base'

module Spurious
  module Server
    module State
      class Update < Base

        def execute!
          ['stop', 'delete', 'init', 'up'].each do |state|
            connection.receive_data(JSON.generate({:type => state}))
          end
        end

      end
    end
  end
end
