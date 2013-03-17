require 'yaml'
require 'erb'
require_relative 'tmux'

data = YAML.load_file('/home/alex/delete/sample.yml')

class Automux
  include Tmux
  attr_reader :data, :session_name, :commands

  def initialize(data)
    @data = data
    @session_name = data['project_name']
  end

  def commands
    @commands ||= []
  end

  def do
    path = File.join(File.dirname(__FILE__), 'erb/template')
    template = File.read(path)
    custom_template = template.
          gsub(/^\s+%(.+)$/, '%\1').
          gsub(/^%=(.+)$/, '<%=\1 %> ')
    erb = ERB.new(custom_template, nil, '%<>')
    result = erb.result(binding).gsub(/\n\s*\n/, "\n")
    exec(result)
  end
end

tmux = Automux.new(data)
tmux.do
