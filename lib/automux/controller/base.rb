module Automux
  module Controller
    class Base
      include Support::Rendering
      extend Support::Filters

      attr_reader :params

      def initialize(params)
        @params = params
      end
    end
  end
end
