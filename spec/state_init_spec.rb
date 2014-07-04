require "helper/spec"

describe Spurious::Server::State::Init do

  it "Pulls down the docker images down and sends response back to client" do
    app_double = double('Spurious::Server::App')
    state = Spurious::Server::State::Init.new({:type => :init}, app_double)

    expect(app_double).to receive(:send_data).exactly(6).times
    state.execute!

  end

end

