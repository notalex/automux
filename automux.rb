require 'yaml'
require_relative 'mini_erb'
require_relative 'tmux'
require_relative 'tmux_window'
require_relative 'tmux_pane'

def relative_path(path)
  File.join(File.dirname(__FILE__), path)
end

class Automux
  attr_reader :tmux

  def initialize(data)
    @tmux = Tmux.new(data)
  end

  def do
    template = File.read(relative_path('erb/template'))
    result = MiniErb.new(template).result(tmux.get_binding)
    exec(result)
  end
end

data = YAML.load_file(relative_path('templates/sample.yml'))
tmux = Automux.new(data)
tmux.do
