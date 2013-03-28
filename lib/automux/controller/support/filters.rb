module Automux
  module Controller
    module Support
      module Filters
        attr_reader :filters
        private :filters

        # Filters is included in the Base controller and all the following methods are intended for its subclasses.
        def inherited(base)
          base.instance_variable_set '@filters', {}
        end

        # before_filter does not define its logic right away.
        def before_filter(filter_name, options)
          [options[:only]].flatten.each do |action|
            filters_add(filter_name, action)
          end
        end

        # This is a custom hook intended to run after the subclass definition is read.
        # This helps in calling the before_filter at the top but defining its logic later.
        # See: automux/initializers/custom_hooks.rb for invocation.
        def after_inherited(base)
          # E.g. filters = { automate: [:load_recipe, :load_session], edit: [:load_recipe] }
          base.class_eval do
            #                    |automate, [:load_recipe, :load_session]|
            filters.each_pair do |name, filter_list|

              # def automate_with_filters
              #   load_recipe
              #   load_session
              #   automate_without_filters
              # end
              define_method "#{ name }_with_filters" do
                filter_list.each { |filter_name| send(filter_name) }
                send("#{ name }_without_filters")
              end

              # alias_method_chain automate, filters
              alias_method "#{ name }_without_filters", name
              alias_method name, "#{ name }_with_filters"
            end
          end
        end

        private ###

        def filters_add(filter_name, action)
          filters[action] ||= []
          filters[action] << filter_name
        end
      end
    end
  end
end
