module Automux
  module Core
    module Support
      module OptionsHelper
        attr_reader :data_options
        private :data_options

        private ###

        def setup_options
          data_options.each do |name, value|
            @options << Automux::Core::Option.new(name, value)
          end
        end
      end
    end
  end
end
