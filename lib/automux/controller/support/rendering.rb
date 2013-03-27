module Automux
  module Controller
    module Support
      module Rendering
        def render(view)
          path =
          if FileTest.exists?(view)
            view
          else
            views_folder_name = demodulize(self.class.name).downcase
            File.join(Paths.views, views_folder_name, view)
          end

          execute Automux::Library::MiniErb.new(File.read(path)).result(@binding)
        end

        private ###

        def execute(result)
          modified_result = remove_empty_lines(result)

          if ENV['AUTOMUX_ENV'] == 'test'
            File.open('/tmp/results', 'w') { |f| f.write(modified_result) }
          else
            exec(modified_result)
          end
        end

        def remove_empty_lines(string)
          string.split("\n").reject { |text| text.strip.empty? }.join("\n")
        end

        def demodulize(class_name)
          class_name.split('::').last
        end
      end
    end
  end
end
