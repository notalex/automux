module Automux
  module Core
    class Blueprint < Base
      attr_reader :name, :path, :source_blueprint, :opts

      def initialize(path)
        @name = File.basename(path, '.yml')
        @path = path
        @opts = parse_opts(path) if saved_record?
      end

      def read(options = [])
        Automux::Library::YamlParser.load_file(path, options)
      end

      def get_binding
        binding
      end

      def source=(blueprint)
        @source_blueprint = blueprint
      end

      class << self
        def build_by_name(name)
          path = File.join(Automux::Paths.blueprints_container, "#{ name }.yml")
          new(path)
        end
      end

      private ###

      # Scan blueprint for patterns like "-\w" or '-\w' to get a options list.
      def parse_opts(file_path)
        File.read(file_path).scan(/['|"]-(\w:?)['|"]/m).flatten
      end
    end
  end
end
