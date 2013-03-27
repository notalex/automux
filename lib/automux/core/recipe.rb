module Automux
  module Core
    class Recipe < Base
      attr_reader :name, :path

      def initialize(path)
        @name = File.basename(path)
        @path = path
      end
    end
  end
end
