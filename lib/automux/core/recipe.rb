module Automux
  module Core
    class Recipe
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def read
        path = File.join(Automux::Paths.data, "recipes/#{ name }")
        File.read(path)
      end
    end
  end
end
