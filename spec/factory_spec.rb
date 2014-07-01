require "helper/spec"

describe Spurious::Server::State::Factory do

  it "Returns an instance based on the specified type" do
    app_double = double('Spurious::Server::App')
    config_stub = { 'test/image' => {:foo => :bar} }
    state = Spurious::Server::State::Factory.create(:init, app_double, config_stub)

    expect(state).to be_a(Spurious::Server::State::Init)
  end

end

