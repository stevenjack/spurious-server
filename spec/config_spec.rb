require "helper/spec"

describe Spurious::Server::Config do
  let(:expected_hash) {
    {
      :image => 'foo/bar',
      :name => 'foo-bar',
      :link => [
        'foo:bar'
      ],
      :env => [
        { :FOO => 'bar' }
      ]
    }
  }
  let (:config_location) { File.join(File.dirname(__FILE__),'fixtures', 'config.yaml') }
  let (:config) { Spurious::Server::Config.new(config_location) }

  describe ".app" do
    it "Loads the config from a yaml file" do
      expect(config.app).to be_a(Hash)
    end

    it "Has the data needed to be a container" do
      expect(config.app[:test]).to eq(expected_hash)
    end

  end

  describe ".name_exists(image_id)" do
    it "Indicates that an name exists in the config" do
      expect(config.name_exists? expected_hash[:name]).to be_truthy
    end
  end

end
