require 'yaml'

module Automux
  module Core
    class Blueprint
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def read
        YAML.load_file(File.join(Automux::Paths.data, "blueprints/#{ name }.yml"))
      end
    end
  end
end
