module Automux
  module Core
    module Tmux
      class Session < Base
        include Support::HooksHelper
        include Support::OptionsHelper

        attr_reader :data, :name, :root, :data_windows, :flags
        dup_attr_reader :windows, :hooks, :options
        private :data, :data_windows

        def initialize(blueprint_data)
          @data = blueprint_data
          @name = data['name']
          @root = data['root'] || '.'
          @data_windows = data['windows'] || []
          @data_hooks = data['hooks'] || []
          @windows = []
          @flags = data['flags']
          @hooks = []
          @data_options = data['options'] || []
          @options = []
        end

        def start_server
          %[tmux start-server]
        end

        def new_session
          %[#{ tmux_with_flags } new-session -d -s #{ name }]
        end

        def set_option(option)
          %[tmux set-option #{ option.name } '#{ option.value }']
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
          %[#{ tmux_with_flags } attach-session -t #{ name }]
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

        def setup
          setup_options
          setup_windows
          setup_hooks
        end

        def window_indexes
          @windows.map(&:index).compact
        end

        def next_available_window_index
          n = number_of_windows
          (Array(0..n) - window_indexes).first
        end

        private ###

        def tmux_with_flags
          %[tmux #{ flags }].strip
        end

        def number_of_windows
          @windows.length
        end

        def add_window(window)
          @windows << window
        end

        # When multiple windows have been assigned the same index by the user, the additional window indexes will be removed.
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

        def setup_windows
          windows_data = remove_duplicate_indexes(data_windows)
          add_windows(windows_data)
          @windows.each(&:update_index)
          @windows.each(&:setup)
        end

        def get_window(identifier)
          return identifier if identifier.is_a?(Window)

          @windows.find { |window| [window.index, window.name].include?(identifier) }
        end
      end
    end
  end
end
