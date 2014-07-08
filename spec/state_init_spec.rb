require "helper/spec"

describe Spurious::Server::State::Init do

  it "Pulls down the docker images down and sends response back to client" do
    connection_double = double('Spurious::Server::App')
    config_stub = {
      :foo => {
        :image => 'foo/bar',
        :name => 'foo-bar'
      }
    }
    config = double('Spurious::Server::Config', :app => config_stub, :length => 0)

    state = Spurious::Server::State::Init.new(connection_double, config)
    allow(Docker::Image).to receive(:create).once.with('fromImage' => 'foo/bar').and_return(true)
    allow(Docker::Container).to receive(:create).once.with('name' => 'foo-bar', 'Image' => 'foo/bar').and_return(true)

    allow(EM).to receive(:add_timer).twice

    state.execute!

  end

end

