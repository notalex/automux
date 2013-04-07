require 'yaml'

module Automux
  module Library
    class YamlParser  # :nodoc:
      class << self
        def load_file(file_path, parsed_options)
          data_string = File.read(file_path)
          opts_replaced_string = replace_opts(data_string, parsed_options)
          YAML.load(opts_replaced_string)
        end

        private ###

        # Replace patterns like "-\w" with matching commandline option.
        def replace_opts(string, parsed_options)
          parsed_options.each do |k, v|
            # Interpolate #{ v } - to substitute literal booleans.
            string.gsub!(/['|"](#{ k }):?['|"]/m, "#{ v }")
          end

          string
        end
      end
    end
  end
end
