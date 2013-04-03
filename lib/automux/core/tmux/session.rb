module Automux
  module Core
    module Tmux
      class Session < Base
        include Support::HooksHelper
        include Support::OptionsHelper
        extend Forwardable

        attr_reader :data, :base_index
        dup_attr_reader :windows, :hooks, :options
        def_delegators :data, :name, :root, :flags

        def initialize(blueprint_data)
          @windows = []
          @hooks = []
          @options = []
          @base_index = 0
          @data = Data.new(blueprint_data)
        end

        class Data
          attr_reader :windows, :hooks, :options, :flags, :name, :root

          def initialize(attributes)
            @windows = attributes['windows'] || []
            @hooks = attributes['hooks'] || []
            @options = attributes['options'] || []
            @name = attributes['name']
            @root = attributes['root'] || '.'
            @flags = attributes['flags']
          end
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

        def select_window(identifier)
          window = get_window(identifier)
          %[tmux select-window -t #{ name }:#{ window.index }]
        end

        # Links window from source session to current session. Window name or index must be provided.
        #
        # E.g.: link_window(primary, finch, 3)
        # This links a window named *finch* from an existing session named *primary* as 3rd window in current session.
        def link_window(source_session_name, source_window_identifier, index = nil)
          %[tmux link-window -s #{ source_session_name }:#{ source_window_identifier } -t #{ name }:#{ index }]
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
          setup_base_index
          setup_windows
          setup_hooks
        end

        def window_indexes
          @windows.map(&:index).compact
        end

        def next_available_window_index
          n = base_index + number_of_windows
          (Array(base_index..n) - window_indexes).first
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
          windows_data = remove_duplicate_indexes(data.windows)
          add_windows(windows_data)
          @windows.each(&:update_index)
          @windows.each(&:setup)
        end

        def setup_base_index
          if option = options.find { |option| option.name == 'base-index' }
            @base_index = option.value.to_i
          end
        end

        def get_window(identifier)
          return identifier if identifier.is_a?(Window)

          @windows.find { |window| [window.index, window.name].include?(identifier) }
        end
      end
    end
  end
end
