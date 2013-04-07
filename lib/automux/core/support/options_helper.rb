module Automux
  module Core
    module Support
      module OptionsHelper # :nodoc:
        private ###

        def setup_options
          data.options.each do |name, value|
            @options << Automux::Core::Option.new(name, value)
          end
        end
      end
    end
  end
end
