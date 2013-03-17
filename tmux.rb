module Tmux
  def new_window(number, name)
    %[tmux new-window -t #{ session_name }:#{ number } -n #{ name } 2> /dev/null]
  end

  def run_command(number, command)
    %[tmux send-keys -t #{ session_name }:#{ number } "#{ command }" C-m]
  end

  def attach_session
    %[tmux -u2 attach-session -t #{ session_name }]
  end

  def select_layout(number, name)
    %[tmux select-layout -t #{ session_name }:#{ number } #{ name }]
  end

  def create_pane
    %[tmux split-window]
  end
end
