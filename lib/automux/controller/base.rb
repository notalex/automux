module Automux
  module Controller
    class Base
      extend Filters

      attr_reader :params

      def initialize(params)
        @params = params
      end

      def render(result)
        if ENV['AUTOMUX_ENV'] == 'test'
          result
        else
          exec(result)
        end
      end
    end
  end
end
