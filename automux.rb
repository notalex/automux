require 'yaml'

data = YAML.load_file('/home/alex/delete/sample.yml')

class Tmux
  attr_reader :data, :session_name

  def initialize(data)
    @data = data
    @session_name = data['project_name']
  end

  def do
    system %[tmux start-server]
    system %[tmux -u2 new-session -d -s #{ session_name }]
    data['tabs'].each_with_index do |tab, i|
      new_window(i, tab.keys.first) if i > 0
      options = tab.values.first
      if options.is_a?(Hash)
        options['panes'].each_with_index do |pane, i|
          create_pane if i > 0
          send_command pane
        end
        select_layout i, options['layout']
      else
        run_command(i, options)
      end
    end
    attach_session
  end

private

  def new_window(number, name)
    system %[tmux new-window -t #{ session_name }:#{ number } -n #{ name }]
  end

  def run_command(number, command)
    system %[tmux send-keys -t #{ session_name }:#{ number } "#{ command }" C-m]
  end

  def attach_session
    system %[tmux -u2 attach-session -t #{ session_name }]
  end

  def select_layout(number, name)
    system %[tmux select-layout -t #{ session_name }:#{ number } #{ name }]
  end

  def create_pane
    system %[tmux split-window]
  end

  def send_command(command)
    system %[tmux send-keys #{ command } C-m]
  end
end

tmux = Tmux.new(data)
tmux.do
