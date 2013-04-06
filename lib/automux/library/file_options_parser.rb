require 'optparse'

module Automux
  module Library
    class FileOptionsParser
      attr_reader :path

      def initialize(path)
        @path = path
      end

      def getopts
        options = file_opts_with_nil_values(path)

        OptionParser.new do |parser|
          options.keys.each do |opt_name|
            parser.on(opt_name) { |value| options[opt_name] = value }
          end
        end.parse!

        options
      end

      private ###

      def file_opts_with_nil_values(path)
        opts = get_file_opts(path)
        Hash[opts.zip]
      end

      # Scan for patterns like "-\w" or '-\w' to get a opts list.
      def get_file_opts(path)
        File.read(path).scan(/['|"](-\w:?)['|"]/m).flatten
      end
    end
  end
end
