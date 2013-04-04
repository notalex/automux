module Automux
  module Core
    class Base
      extend Automux::Core::Support::CustomAccessors

      private ###

      def saved_record?
        FileTest.exists?(path)
      end
    end
  end
end
