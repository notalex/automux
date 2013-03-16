require 'yaml'

data = YAML.load_file('/home/alex/delete/sample.yml')

class Tmux
  attr_reader :data, :session_name

  def initialize(data)
    @data = data
    @session_name = data['project_name']
  end

  def do
    p data['tabs']
    #%x[tmux start-server]
    system %[tmux -u2 new-session -d -s #{ session_name }]
    p %[tmux -u2 new-session -d -s #{ session_name }]
    data['tabs'].each_with_index do |(tab_name, command), i|
      new_window(i, tab_name)
      run_command(i, command)
    end
    attach_session
  end

private
  
  def new_window(number, name)
    %x[tmux new-window -t #{ session_name }:#{ number } #{ name }]
  end

  def run_command(number, command)
    %x[tmux send-keys -t #{ session_name }:#{ number } "#{ command }" C-m]
  end

  def attach_session
    %x[tmux -u2 attach-session -t #{ session_name }]
  end
end

tmux = Tmux.new(data)
tmux.do
