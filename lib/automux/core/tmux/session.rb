module Automux
  module Core
    module Tmux
      class Session < Base
        attr_reader :data, :name, :root, :data_windows, :data_hooks
        dup_attr_reader :windows, :hooks
        private :data, :data_windows, :data_hooks

        def initialize(blueprint_data)
          @data = blueprint_data
          @name = data['name']
          @root = data['root'] || '.'
          @data_windows = data['windows'] || []
          @data_hooks = data['hooks'] || []
          @windows = []
          @hooks = []
        end

        def start_server
          %[tmux start-server]
        end

        def new_session
          %[tmux -u2 new-session -d -s #{ name }]
        end

        def new_window(window)
          %[tmux new-window -t #{ name }:#{ window.index } 2> /dev/null]
        end

        def rename_window(window, window_name = window.name)
          %[tmux rename-window -t #{ name }:#{ window.index } #{ window_name }]
        end

        def send_keys(identifier, command)
          window = get_window(identifier)
          %[tmux send-keys -t #{ name }:#{ window.index } "#{ command }" C-m]
        end

        def attach_session
          %[tmux -u2 attach-session -t #{ name }]
        end

        def select_layout(window)
          %[tmux select-layout -t #{ name }:#{ window.index } #{ window.layout }]
        end

        def create_pane
          %[tmux split-window]
        end

        def get_binding
          binding
        end

        def setup_windows_and_hooks
          setup_windows
          setup_hooks
        end

        def pre_hooks
          hooks.select(&:pre?)
        end

        def post_hooks
          hooks.select(&:post?)
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
            add_window(window) if window.opted_in?
          end
        end

        def setup_hooks
          data_hooks.each do |type, commands|
            [commands].flatten.each do |command|
              @hooks << Hook.new(self, type, command)
            end
          end
        end

        def setup_windows
          windows_data = remove_duplicate_indexes(data_windows)
          add_windows(windows_data)
          @windows.each(&:update_index)
          @windows.each(&:setup_panes)
        end

        def get_window(identifier)
          return identifier if identifier.is_a?(Window)

          @windows.find { |window| [window.index, window.name].include?(identifier) }
        end
      end
    end
  end
end
