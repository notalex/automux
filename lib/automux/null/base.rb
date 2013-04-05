module Automux
  module Null
    class Base
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def path
        '/dev/null'
      end
    end
  end
end
