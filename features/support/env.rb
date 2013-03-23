ENV['AUTOMUX_ENV'] = 'test'

$LOAD_PATH << File.expand_path('../../../lib', __FILE__)
require 'automux'

require 'minitest/spec'
World(MiniTest::Assertions)
MiniTest::Spec.new(nil)
