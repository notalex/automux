module Automux
  module Controller
    class Base
      include Automux::Controller::Rendering
      extend Filters

      attr_reader :params

      def initialize(params)
        @params = params
      end
    end
  end
end
