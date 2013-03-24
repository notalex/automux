module Automux
  module Core
    module Tmux
      class Window < Base
        attr_reader :data, :session, :index
        dup_attr_reader :panes
        private :data, :session

        def initialize(session, data)
          @session = session
          @data = data
          @index = data['index']
          @panes = []
        end

        def name
          data['name']
        end

        def setup_panes
          data['panes'].each do |command|
            pane = Automux::Core::Tmux::Pane.new(self, command)
            @panes << pane
          end
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
      end
    end
  end
end
