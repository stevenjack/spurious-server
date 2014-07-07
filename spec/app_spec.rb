require "helper/spec"

describe Spurious::Server::App do
  subject(:app) { Spurious::Server::App.new('blah')}

  describe "#receive_data(data)" do
    let(:data) { {:type => :init} }
    let(:state) { double('Spurious::Server::State::Init', :execute! => nil) }

    it "responds to an init message" do
      expect(state).to receive(:execute!)
      expect(Spurious::Server::State::Factory).to receive(:create).and_return(state)
      app.receive_data(data.to_json)
    end

    it "sends an error back if payload is malformed" do
      response = "{\"type\":\"error\",\"response\":{\"message\":\"JSON payload malformed\"}}"
      expect(EventMachine).to receive(:send_data).with(anything(), response, response.length)
      app.receive_data("{ Test / Malformed }")
    end

    it "sends an error back if the type is not recognised" do
      data[:type] = 'test'
      response = "{\"type\":\"error\",\"response\":{\"message\":\"Type: test is not recognised\"}}"
      expect(EventMachine).to receive(:send_data).with(anything(), response, response.length)
      app.receive_data(data.to_json)
    end

  end

end
