module Automux
  module Core
    module Support
      module HooksHelper
        def pre_hooks
          hooks.select(&:pre?)
        end

        def post_hooks
          hooks.select(&:post?)
        end

        private ###

        def setup_hooks
          data.hooks.each do |type, commands|
            [commands].flatten.each do |command|
              @hooks << Hook.new(self, type, command)
            end
          end
        end
      end
    end
  end
end
