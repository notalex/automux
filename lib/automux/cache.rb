require 'automux/cache/blueprint'
require 'automux/cache/recipe'

module Automux::Cache
  class << self
    def module_constants
      constants.select { |constant_name| const_get(constant_name).is_a?(Module) }
    end
  end
end
