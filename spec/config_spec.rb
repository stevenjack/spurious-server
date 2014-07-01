require "helper/spec"

describe Spurious::Server::Config do
  let(:expected_hash) {
    {
      'foo-bar' => {
        :image => 'foo/bar',
        :link => [
          'foo:bar'
        ],
        :env => {
          'FOO' => 'bar'
        }
      }
    }
  }
  let (:config_location) { File.join(File.dirname(__FILE__),'fixtures', 'config.yaml') }
  let (:config) { Spurious::Server::Config.new(config_location) }

  describe ".app" do
    it "Loads the config from a yaml file" do
      expect(config.app).to be_a(Hash)
    end

    it "Has the data needed to be a container" do
      expect(config.app['foo-bar']).to eq(expected_hash['foo-bar'])
    end

  end

  describe ".name_exists(name)" do
    it "Indicates that an name exists in the config" do
      expect(config.name_exists? expected_hash.keys[0]).to be_truthy
    end
  end

end
