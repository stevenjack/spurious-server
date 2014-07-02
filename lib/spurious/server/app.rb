require 'rack/response'
require 'rack/request'

module Spurious
  module Server
    class App
      attr_accessor :options


      def initialize(options)
        @options = options
      end


      def call(env)
        request = Rack::Request.new(env)

        case request.path_info
        when /init/
          handler.call('init')
          response_for('Init some stuff')

        when /status/

        when /start/

        when /stop/

        when /update/

        when /delete/

        else
          response_for('Not found', 404)
        end

      end

      protected

      def response_for(body = '', status = 200)
        Rack::Response.new(
          body,
          status,
          { "Content-Type" => "text/html" }
        ).finish
      end

    end
  end
end
