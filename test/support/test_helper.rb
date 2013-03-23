ENV['AUTOMUX_ENV'] = 'test'
$LOAD_PATH << File.expand_path('../../../lib', __FILE__)

require 'minitest/autorun'
require 'automux'
require 'support/hash_factory'
require 'support/factories'
