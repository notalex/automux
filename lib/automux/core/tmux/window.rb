module Automux
  module Core
    module Tmux
      class Window < Base
        include Support::HooksHelper
        include Support::OptionsHelper
        extend Forwardable

        attr_reader :data, :session, :index
        dup_attr_reader :panes, :hooks, :options
        def_delegators :data, :name, :root, :layout

        def initialize(session, window_data)
          @session = session
          @hooks = []
          @options = []
          @panes = []
          @data = Data.new(window_data)
          @index = @data.index
        end

        class Data
          attr_reader :opt, :index, :name, :root, :layout, :hooks, :options, :panes

          def initialize(attributes)
            @opt = attributes['opt']
            @index = attributes['index']
            @name = attributes['name']
            @root = attributes['root']
            @layout = attributes['layout']
            @hooks = attributes['hooks'] || []
            @options = attributes['options'] || []
            @panes = attributes['panes']
          end
        end

        def set_option(option)
          %[tmux set-window-option -t #{ session.name }:#{ index } #{ option.name } '#{ option.value }']
        end

        def setup
          setup_options
          setup_panes
          setup_hooks
        end

        def has_panes?
          !@panes.nil?
        end

        def update_index
          @index ||= session.next_available_window_index
        end

        def opted_in?
          return true if data.opt.nil?

          data.opt
        end

        def change_root_command
          %[cd #{ root }]
        end

        def get_binding
          binding
        end

        private ###

        def setup_panes
          [data.panes].flatten.each do |command|
            pane = Automux::Core::Tmux::Pane.new(self, command)
            @panes << pane
          end
        end
      end
    end
  end
end
