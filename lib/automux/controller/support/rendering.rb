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
          execute Automux::Library::MiniErb.new(File.read(path)).result(@binding)
        end

        private ###

        # The full file path will be deduced using current controller name.
        #   So for Blueprints, the file will be searched under $HOME/.automux/blueprints.
        # The file will be a bash script with erb support. Hence the need of a @binding object.
        def deduce_full_path(view)
          views_folder_name = demodulize(self.class.name).downcase
          File.join(Paths.root, Paths.views, views_folder_name, "#{ view }.sh.erb")
        end

        def execute(result)
          modified_result = remove_empty_lines(result)

          if ENV['AUTOMUX_ENV'] == 'test'
            File.open('/tmp/results', 'w') { |f| f.write(modified_result) }
            exit
          else
            exec(modified_result)
          end
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
