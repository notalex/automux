module Automux
  module Core
    class Blueprint < Base
      attr_reader :name, :path, :source_blueprint

      def initialize(path)
        @name = File.basename(path, '.yml')
        @path = path
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
    end
  end
end
