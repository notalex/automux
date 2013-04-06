require 'optparse'

module Automux
  module Library
    class FileOptionsParser
      attr_reader :options

      def initialize(path)
        @options = parse_opts(path)
      end

      def getopts
        OptionParser.new do |parser|
          options.keys.each do |opt_name|
            parser.on(opt_name) { |value| options[opt_name] = value }
          end
        end.parse!

        options
      end

      private ###

      # Scan blueprint for patterns like "-\w" or '-\w' to get a options list.
      def parse_opts(path)
        opts = File.read(path).scan(/['|"](-\w:?)['|"]/m).flatten
        Hash[opts.zip]
      end
    end
  end
end
