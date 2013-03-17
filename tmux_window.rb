class TmuxWindow
  attr_reader :options, :name, :tmux

  def initialize(tmux, data)
    @tmux = tmux
    @name = data.keys.first
    @options = data.values.first
  end

  def panes
    return nil unless options.is_a?(Hash)

    @panes ||= options['panes'].map { |command| TmuxPane.new(self, command) }
  end

  def has_panes?
    !panes.nil?
  end

  def layout
    return nil unless options.is_a?(Hash)

    options['layout'] || 'main-vertical'
  end

  def index
    tmux.windows.find_index(self)
  end
end
