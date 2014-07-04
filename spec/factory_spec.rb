require "helper/spec"

describe Spurious::Server::State::Factory do

  it "Returns an instance based on the specified type" do
    app_double = double('Spurious::Server::App')
    state = Spurious::Server::State::Factory.create({:type => :init}, app_double)

    expect(state).to be_a(Spurious::Server::State::Init)
  end

end

