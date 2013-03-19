require 'yaml'
require_relative 'automux/mini_erb'
require_relative 'automux/tmux'
require_relative 'automux/tmux_window'
require_relative 'automux/tmux_pane'

class AutomuxLoader
  include Automux::Tmux
  include Automux::MiniErb

  attr_reader :tmux

  def initialize(data)
    @tmux = Tmux.new(data)
  end

  def do
    recipe = File.read(File.join(Gem.datadir('automux'), 'recipes/default'))
    result = MiniErb.new(recipe).result(tmux.get_binding)
    exec(result)
  end
end

data = YAML.load_file(File.join(config_path, 'templates/sample.yml'))
automux = AutomuxLoader.new(data)
automux.do
