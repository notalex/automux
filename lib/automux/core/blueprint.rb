module Automux
  module Core
    class Blueprint < Base
      attr_reader :name, :path

      def initialize(path)
        @name = File.basename(path, '.yml')
        @path = path
      end

      def read
        Automux::Library::YamlParser.load_file(File.join(Automux::Paths.data, "blueprints/#{ name }.yml"))
      end
    end
  end
end
