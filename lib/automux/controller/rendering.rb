module Automux
  module Controller
    module Rendering
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
