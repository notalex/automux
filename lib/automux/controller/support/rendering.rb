module Automux
  module Controller
    module Support
      module Rendering
        def render(result)
          modified_result = remove_empty_lines(result)
          if ENV['AUTOMUX_ENV'] == 'test'
            modified_result
          else
            exec(modified_result)
          end
        end

        private ###

        def remove_empty_lines(string)
          string.split("\n").reject { |text| text.strip.empty? }.join("\n")
        end
      end
    end
  end
end
