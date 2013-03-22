module Automux
  module Controller
    module Filters
      attr_reader :filters

      def inherited(base)
        base.instance_variable_set '@filters', {}
      end

      def after_inherited(base)
        base.class_eval do
          filters.each_pair do |name, filter_list|

            define_method "#{ name }_with_filters" do
              filter_list.each { |filter_name| send(filter_name) }
              send("#{ name }_without_filters")
            end

            alias_method "#{ name }_without_filters", name
            alias_method name, "#{ name }_with_filters"
          end
        end
      end

      def before_filter(filter_name, actions)
        [actions].flatten.each do |action|
          filters_add(filter_name, action)
        end
      end

      def filters_add(filter_name, action)
        filters[action] ||= []
        filters[action] << filter_name
      end
    end
  end
end
