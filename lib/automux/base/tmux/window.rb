module Automux
  module Base
    module Tmux
      class Window
        attr_reader :options, :session

        def initialize(session, data)
          @session = session
          @options = data
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
          return nil unless options.is_a?(Hash)

          options['layout']
        end

        def assigned_index
          options['index'] || @index
        end

        def index
          return @index if @index

          @index = options['index'] || next_available_index
        end

        private ###

        def next_available_index
          assigned_indexes = session.windows.map(&:assigned_index).compact
          ((0..session.windows.length).to_a - assigned_indexes).first
        end
      end
    end
  end
end
