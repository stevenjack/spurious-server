require "helper/spec"

describe Spurious::Server do

  it "starts a server and receives data" do
    EventMachine.run {

      Spurious::Server.run!
      expect_any_instance_of(Spurious::Server::App).to receive(:receive_data)
      EventMachine.connect '0.0.0.0', 4590, Helper::Client

      event_timer

    }
  end

end
