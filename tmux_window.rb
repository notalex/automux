class TmuxWindow
  attr_reader :options, :tmux

  def initialize(tmux, data)
    @tmux = tmux
    @options = data
  end

  def name
    options['name']
  end

  def panes
    return nil unless options['panes']

    @panes ||= options['panes'].map { |command| TmuxPane.new(self, command) }
  end

  def has_panes?
    !panes.nil?
  end

  def layout
    return nil unless options.is_a?(Hash)

    options['layout']
  end

  def index
    tmux.windows.find_index(self)
  end

  def command
    return nil unless options.is_a?(String)

    options
  end
end
