require "helper/spec"

describe Spurious::Server::State::Init do

  it "Pulls down the docker images down and sends response back to client" do
    connection_double = double('Spurious::Server::App')
    state = Spurious::Server::State::Init.new({:type => :init}, connection_double)

    expect(connection_double).to receive(:send_data).exactly(6).times
    expect(connection_double).to receive(:unbind)
    state.execute!

  end

end

