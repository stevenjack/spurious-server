require "helper/spec"

describe Spurious::Server::App do
  subject(:app) { Spurious::Server::App.new(double('Spurious::Server::State::Factory')) }

  describe "#receive_data(data)" do
    let(:data) { "{\"type\":\"init\"}" }

    it "responds to an init message" do

      #expect(Spurious::Server::State::Factory).to receive(:create).with(data)
      expect(EventMachine).to receive(:send_data)
      app.receive_data(data)

    end

  end

end
