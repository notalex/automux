module Automux
  module Core
    class Option
      attr_reader :name, :value

      BOOLEAN_DICTIONARY = { 'true' => :on, 'false' => :off }

      def initialize(name, value)
        @name = name
        @value = translate_booleans(value)
      end

      private ###

      def translate_booleans(value)
        value.to_s.gsub(/(true|false)/, BOOLEAN_DICTIONARY)
      end
    end
  end
end
