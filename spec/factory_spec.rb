require "helper/spec"

describe Spurious::Server::State::Factory do

  describe ".create" do

    it "creates a new state based on a type" do
      object = Spurious::Server::State::Factory.create('init', {:some => :data})
      expect(object).to be(Spurious::Server::State::Init)
    end

  end

end
