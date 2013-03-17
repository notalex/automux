require 'yaml'
require_relative 'mini_erb'
require_relative 'tmux'
require_relative 'tmux_window'
require_relative 'tmux_pane'

data = YAML.load_file('/home/alex/delete/sample.yml')

class Automux
  attr_reader :tmux

  def initialize(data)
    @tmux = Tmux.new(data)
  end

  def do
    path = File.join(File.dirname(__FILE__), 'erb/template')
    template = File.read(path)
    result = MiniErb.new(template).result(tmux.get_binding)
    exec(result)
  end
end

tmux = Automux.new(data)
tmux.do
