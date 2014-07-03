require "eventmachine"

module Spurious
  module Server
    class App < EventMachine::Connection

      def receive_data data
        if data =~ /init/i
          #send_data "STAT version #{options[:version]}\nEND\n"
        else
          #send_data "Command: #{data} is unexpected\n"
        end
      end

    end
  end
end
