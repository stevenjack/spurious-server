$: << File.join(File.dirname(__FILE__), '..', '..', 'lib')

require 'spurious/server'
require 'spurious/server/app'
require 'spurious/server/state/factory'
require 'spurious/server/config'
require 'helper/client'
require 'json'
require 'rack/test'

RSpec.configure do |conf|
    conf.include Rack::Test::Methods
end
