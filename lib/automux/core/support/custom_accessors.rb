module Automux
  module Core
    module Support
      module CustomAccessors
        def dup_attr_reader(name)
          define_method name do
            instance_variable_get("@#{ name }").dup
          end
        end
      end
    end
  end
end
