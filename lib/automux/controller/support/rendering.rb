module Automux
  module Controller
    module Support
      module Rendering

        def render(view)
          path = deduce_full_path(view)
          render_file(path)
        end

        # There are two requirements to render a file.
        # 1. @binding
        # 2. file_name
        def render_file(path)
          result = Automux::Library::MiniErb.new(File.read(path)).result(@binding)
          modified_result = remove_empty_lines(result)
          environmental_execute modified_result
        end

        private ###

        # The full file path will be deduced using current controller name.
        #   So for Blueprints, the file will be searched under $HOME/.automux/blueprints.
        # The file will be a bash script with erb support. Hence the need of a @binding object.
        def deduce_full_path(view)
          views_folder_name = demodulize(self.class.name).downcase
          File.join(Paths.root, Paths.views, views_folder_name, "#{ view }.sh.erb")
        end

        def environmental_execute(result)
          send("#{ ENV['AUTOMUX_ENV'] }_execute", result)
        end

        def production_execute(result)
          exec(result)
        end

        def test_execute(result)
          File.open('/tmp/results', 'w') { |f| f.write(result) }
          exit
        end

        # The recipe files can have empty lines for clarity. Remove them here.
        def remove_empty_lines(string)
          string.gsub(/\n\s+\n/, "\n")
        end

        # Remove all parent namespacing.
        def demodulize(class_name)
          class_name.split('::').last
        end
      end
    end
  end
end
