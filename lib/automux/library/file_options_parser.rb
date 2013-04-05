require 'optparse'

module Automux
  module Library
    class FileOptionsParser
      attr_reader :opts, :argv

      def initialize(path, argv)
        @opts = parse_opts(path)
        @argv = argv
      end

      def getopts
        argv.shift while argv[0].to_s.match(/^\w/)
        argv.getopts(*opts)
      end

      private ###

      # Scan blueprint for patterns like "-\w" or '-\w' to get a options list.
      def parse_opts(path)
        File.read(path).scan(/['|"]-(\w:?)['|"]/m).flatten
      end
    end
  end
end
