require "helper/spec"

describe Spurious::Server::App do

  describe "#receive_data(data)" do
    let(:data) { {:type => :init}

    it "responds to an init message" do

      expect(Spurious::Server::State::Factory).to receive(:create).with(data)
      subject.receive_data(data)

    end

  end

end
