require "eventmachine"

module Spurious
  module Server
    class App < EventMachine::Connection
      attr_accessor :state_factory

      def intialize(state_factory)
        @state_factory = state_factory
      end

      def receive_data data
        #if data =~ /init/i
          send_data "Foo"
        #else
          #send_data "Command: #{data} is unexpected\n"
        #end
      end

    end
  end
end
