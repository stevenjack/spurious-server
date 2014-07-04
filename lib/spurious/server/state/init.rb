module Spurious
  module Server
    module State
      class Init
        attr_accessor :app

        def initialize(payload, app)
          @payload = payload
          @app     = app
        end

        def execute!
          [1,2,3,4,5,6].each do |index|
            app.send_data 'foo'
          end
        end

      end
    end
  end
end
