require "helper/spec"

describe Spurious::Server::Config do

  describe ".app" do
    let (:config_location) { File.join(File.dirname(__FILE__),'fixtures', 'config.yaml') }
    let (:config) { Spurious::Server::Config.new(config_location) }

    it "Loads the config from a yaml file" do
      expect(config.app).to be_a(Hash)
    end

    it "Has the data needed to be a container" do
      expected_hash = {
        :image => 'foo/bar',
        :name => 'foo-bar',
        :link => [
          'foo:bar'
        ],
        :env => [
          { :FOO => 'bar' }
        ]
      }

      expect(config.app[:test]).to eq(expected_hash)
    end

  end

end
