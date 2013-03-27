require 'automux/controller/support'
require 'automux/controller/base'
require 'automux/controller/recipes'

module Automux::Controller
  class << self
    def base_inheriting_classes
      constants.select { |constant_name| const_get(constant_name) < Base }
    end
  end
end
