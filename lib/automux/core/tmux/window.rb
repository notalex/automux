module Automux
  module Core
    module Tmux
      class Window < Base
        include Support::HooksHelper
        include Support::OptionsHelper

        attr_reader :data, :session, :index, :root
        dup_attr_reader :panes, :hooks, :options
        private :data, :session

        def initialize(session, data)
          @session = session
          @data = data
          @opt = data['opt']
          @index = data['index']
          @root = data['root']
          @data_hooks = data['hooks'] || []
          @hooks = []
          @data_options = data['options'] || []
          @options = []
          @panes = []
        end

        def set_option(option)
          %[tmux set-window-option -t #{ session.name }:#{ index } #{ option.name } '#{ option.value }']
        end

        def name
          data['name']
        end

        def setup
          setup_panes
          setup_hooks
          setup_options
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
      end
    end
  end
end
