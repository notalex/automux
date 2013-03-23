module Automux
  module Base
    module Tmux
      class Window
        attr_reader :options, :session, :index

        def initialize(session, data)
          @session = session
          @options = data
          @index = options['index']
        end

        def name
          options['name']
        end

        def panes
          return nil unless options['panes']

          @panes ||= options['panes'].map { |command| Automux::Base::Tmux::Pane.new(self, command) }
        end

        def has_panes?
          !panes.nil?
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
