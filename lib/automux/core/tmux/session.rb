module Automux
  module Core
    module Tmux
      class Session
        attr_reader :data, :session_name, :commands

        def initialize(data)
          @data = data
          @session_name = data['project_name']
          @windows = []
        end

        def start_server
          %[tmux start-server]
        end

        def new_session
          %[tmux -u2 new-session -d -s #{ session_name }]
        end

        def new_window(window)
          %[tmux new-window -t #{ session_name }:#{ window.index } 2> /dev/null]
        end

        def rename_window(window)
          %[tmux rename-window -t #{ session_name }:#{ window.index } #{ window.name }]
        end

        def send_keys(number, command)
          %[tmux send-keys -t #{ session_name }:#{ number } "#{ command }" C-m]
        end

        def attach_session
          %[tmux -u2 attach-session -t #{ session_name }]
        end

        def select_layout(window)
          %[tmux select-layout -t #{ session_name }:#{ window.index } #{ window.layout }]
        end

        def create_pane
          %[tmux split-window]
        end

        def get_binding
          binding
        end

        def windows
          @windows.dup
        end

        def setup_windows
          windows_data = remove_duplicate_indexes(data['windows'])
          add_windows(windows_data)
          @windows.each(&:update_index)
          @windows.each(&:setup_panes)
        end

        def window_indexes
          @windows.map(&:index).compact
        end

        def next_available_window_index
          n = number_of_windows
          (Array(0..n) - window_indexes).first
        end

        private ###

        def number_of_windows
          @windows.length
        end

        def add_window(window)
          @windows << window
        end

        def remove_duplicate_indexes(original_data)
          non_indexed_data = original_data.select { |h| h['index'].to_s.empty? }
          indexed_data = original_data - non_indexed_data

          uniq_indexed_data = indexed_data.uniq { |h| h['index'] }
          conflicting_data = indexed_data - uniq_indexed_data
          removed_index_data = conflicting_data.each { |h| h.delete('index') }

          non_indexed_data + uniq_indexed_data + removed_index_data
        end

        def add_windows(windows_data)
          windows_data.each do |window_data|
            window = Automux::Core::Tmux::Window.new(self, window_data)
            add_window(window)
          end
        end
      end
    end
  end
end
