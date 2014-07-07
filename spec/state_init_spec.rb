require "helper/spec"

describe Spurious::Server::State::Init do

  it "Pulls down the docker images down and sends response back to client" do
    connection_double = double('Spurious::Server::App')
    config_stub = {
      :foo => {
        :image => 'foo/bar'
      }
    }
    state = Spurious::Server::State::Init.new({:type => :init}, connection_double, config_stub)
    allow(Docker::Image).to receive(:create).once.with('fromImage' => 'foo/bar').and_return(true)

    expect(connection_double).to receive(:send_data).exactly(2).times
    expect(connection_double).to receive(:unbind)
    state.execute!

  end

end

