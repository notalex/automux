require 'automux/controller/support'
require 'automux/controller/base'
require 'automux/controller/recipes'
require 'automux/controller/blueprints'
require 'automux/controller/messages'

module Automux::Controller
  class << self
    def base_inheriting_classes
      constants.select { |constant_name| const_get(constant_name) < Base }
    end
  end
end
