require 'yaml'
require 'optparse'

module Automux
  module Library
    class YamlParser
      class << self
        def load_file(file)
          data_string = File.read(file)
          opts_replaced_string = replace_opts_with_user_input(data_string)
          YAML.load(opts_replaced_string)
        end

        private ###

        def replace_opts_with_user_input(string)
          blueprint_opts = string.scan(/'-(\w+:?)'/m).flatten
          user_input_values = get_options(blueprint_opts)
          replace_opts(string, user_input_values)
        end

        def replace_opts(string, values)
          values.each do |k, v|
            # Interpolate #{ v } - to substitute literal booleans.
            string.gsub!(/'-(#{ k }):?'/m, "#{ v }")
          end

          string
        end

        def get_options(opts)
          ARGV.shift while ARGV[0].to_s.match(/^\w/)
          ARGV.getopts(*opts)
        end
      end
    end
  end
end
