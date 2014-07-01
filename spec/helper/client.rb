require 'eventmachine'

module Helper
  class Client < EventMachine::Connection

    attr_accessor :received_data
    attr_reader :data_to_send

    def initialize(data_to_send = 'test')
      @data_to_send = data_to_send
    end

    def post_init
      send_data data_to_send
    end

    def receive_data(data)
      received_data = data
    end
  end
end
