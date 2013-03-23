module Automux
  module Core
    module Tmux
      class Window < Base
        attr_reader :options, :session, :index
        dup_attr_reader :panes

        def initialize(session, data)
          @session = session
          @options = data
          @index = options['index']
          @panes = []
        end

        def name
          options['name']
        end

        def setup_panes
          options['panes'].each do |command|
            pane = Automux::Core::Tmux::Pane.new(self, command)
            @panes << pane
          end
        end

        def has_panes?
          !@panes.nil?
        end

        def layout
          options['layout']
        end

        def update_index
          @index ||= session.next_available_window_index
        end
      end
    end
  end
end
