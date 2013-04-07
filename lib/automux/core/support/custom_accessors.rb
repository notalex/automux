module Automux
  module Core
    module Support
      module CustomAccessors # :nodoc:
        def dup_attr_reader(*names)
          names.each do |name|
            define_method name do
              instance_variable_get("@#{ name }").dup
            end
          end
        end
      end
    end
  end
end
