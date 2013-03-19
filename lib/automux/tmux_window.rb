module Automux
  module Tmux
    class TmuxWindow
      attr_reader :options, :tmux

      def initialize(tmux, data)
        @tmux = tmux
        @options = data
      end

      def name
        options['name']
      end

      def panes
        return nil unless options['panes']

        @panes ||= options['panes'].map { |command| TmuxPane.new(self, command) }
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

      #######
      private

      def next_available_index
        assigned_indexes = tmux.windows.map(&:assigned_index).compact
        ((0..tmux.windows.length).to_a - assigned_indexes).first
      end
    end
  end
end
