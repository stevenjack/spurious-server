require "helper/spec"

describe Spurious::Server do
  let(:ip) { '127.0.0.1' }
  let(:port) { 4590 }

  it "starts a server and receives data" do
    EventMachine.run {

      Spurious::Server.handle(ip, port).call
      expect_any_instance_of(Spurious::Server::App).to receive(:receive_data)
      EventMachine.connect ip, port, Helper::Client

      event_timer

    }
  end

end
