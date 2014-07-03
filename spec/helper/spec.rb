$: << File.join(File.dirname(__FILE__), '..', '..', 'lib')

require "spurious/server"
require "spurious/server/app"
require "spurious/server/state/factory"
require "helper/client"
require "eventmachine"
require "json"

def event_timer(timeout = 1)
  EventMachine.add_timer timeout do
    puts 'Second passed, stopping event loop'
    EventMachine.stop_event_loop
  end
end


