module Automux
  module Core
    class Blueprint < Base
      attr_reader :name

      def initialize(name)
        @name = name
      end

      def read
        Automux::Library::YamlParser.load_file(File.join(Automux::Paths.data, "blueprints/#{ name }.yml"))
      end
    end
  end
end
