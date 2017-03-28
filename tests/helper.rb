require 'coveralls'
Coveralls.wear!

require File.expand_path('../../lib/fog/digitalocean', __FILE__)

Bundler.require(:test)

Excon.defaults.merge!(:debug_request => true, :debug_response => true)

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'helpers', '*_helper.rb'))].each do |path|
  file = path.gsub(%r{\.rb$}, '')
  require file
end

# This overrides the default 600 seconds timeout during live test runs
unless Fog.mocking?
  Fog.timeout = ENV['FOG_TEST_TIMEOUT'] || 2_000
  Fog::Logger.warning "Setting default fog timeout to #{Fog.timeout} seconds"
end

def lorem_file
  File.open(File.dirname(__FILE__) + '/lorem.txt', 'r')
end

def array_differences(array_a, array_b)
  (array_a - array_b) | (array_b - array_a)
end
