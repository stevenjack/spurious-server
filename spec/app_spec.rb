require "helper/spec"

describe Spurious::Server::App do
  subject(:app) { Spurious::Server::App.new(double('Spurious::Server::State::Factory')) }

  describe "#receive_data(data)" do
    let(:data) { {:type => :init} }

    it "responds to an init message" do
      expect(EventMachine).to receive(:send_data)
      app.receive_data(data.to_json)
    end

    it "sends an error back if payload is malformed" do
      response = "{\"type\":\"error\",\"response\":{\"message\":\"JSON payload malformed\"}}"
      expect(EventMachine).to receive(:send_data).with(anything(), response, response.length)
      app.receive_data("{ Test / Malformed }")
    end

    it "sends and error back if the type is not recognised" do
      data[:type] = 'test'
      response = "{\"type\":\"error\",\"response\":{\"message\":\"Type: test is not recognised\"}}"
      expect(EventMachine).to receive(:send_data).with(anything(), response, response.length)
      app.receive_data(data.to_json)
    end

  end

end
