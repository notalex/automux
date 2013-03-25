module Automux
  module Core
    module Tmux
      class Window < Base
        attr_reader :data, :session, :index, :root, :data_hooks
        dup_attr_reader :panes, :hooks
        private :data, :session, :data_hooks

        def initialize(session, data)
          @session = session
          @data = data
          @opt = data['opt']
          @index = data['index']
          @root = data['root']
          @data_hooks = data['hooks'] || []
          @hooks = []
          @panes = []
        end

        def name
          data['name']
        end

        def setup_panes_and_hooks
          setup_panes
          setup_hooks
        end

        def pre_hooks
          hooks.select(&:pre?)
        end

        def post_hooks
          hooks.select(&:post?)
        end

        def has_panes?
          !@panes.nil?
        end

        def layout
          data['layout']
        end

        def update_index
          @index ||= session.next_available_window_index
        end

        def opted_in?
          return true if @opt.nil?

          @opt
        end

        def change_root_command
          %[cd #{ root }]
        end

        def get_binding
          binding
        end

        private ###

        def setup_panes
          [data['panes']].flatten.each do |command|
            pane = Automux::Core::Tmux::Pane.new(self, command)
            @panes << pane
          end
        end

        def setup_hooks
          data_hooks.each do |type, commands|
            [commands].flatten.each do |command|
              @hooks << Hook.new(self, type, command)
            end
          end
        end
      end
    end
  end
end
