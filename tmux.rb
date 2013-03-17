class Tmux
  attr_reader :data, :session_name, :commands

  def initialize(data)
    @data = data
    @session_name = data['project_name']
  end

  def new_window(window)
    %[tmux new-window -t #{ session_name }:#{ window.index } -n #{ window.name } 2> /dev/null]
  end

  def run_command(number, command)
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
    @windows ||= data['windows'].map { |data| TmuxWindow.new(self, data) }
  end
end
