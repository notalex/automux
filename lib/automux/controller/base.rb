module Automux
  module Controller
    class Base
      extend Filters

      attr_reader :params

      def initialize(params)
        @params = params
      end

      def render(result)
        exec(result)
      end
    end
  end
end
