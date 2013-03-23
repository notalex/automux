module Automux
  module Core
    module Tmux
      class Pane < Base
        attr_reader :command, :window

        def initialize(window, command)
          @window = window
          @command = command
        end

        def index
          window.panes.find_index(self)
        end
      end
    end
  end
end
