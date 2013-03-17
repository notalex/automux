class Tmux
  attr_reader :data, :session_name, :commands

  def initialize(data)
    @data = data
    @session_name = data['project_name']
  end

  def new_window(number, name)
    %[tmux new-window -t #{ session_name }:#{ number } -n #{ name } 2> /dev/null]
  end

  def run_command(number, command)
    %[tmux send-keys -t #{ session_name }:#{ number } "#{ command }" C-m]
  end

  def attach_session
    %[tmux -u2 attach-session -t #{ session_name }]
  end

  def select_layout(number, type)
    %[tmux select-layout -t #{ session_name }:#{ number } #{ type }]
  end

  def create_pane
    %[tmux split-window]
  end

  def get_binding
    binding
  end

  def windows
    @windows ||= data['windows'].map { |data| TmuxWindow.new(data) }
  end
end
