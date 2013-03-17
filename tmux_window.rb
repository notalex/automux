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

  def assigned_index
    options['index'] || @index
  end

  def index
    return @index if @index

    @index = options['index'] || next_available_index
  end

  def command
    return nil unless options.is_a?(String)

    options
  end

private

  def next_available_index
    i = 0
    while tmux.windows.find { |window| window.assigned_index == i }
      i += 1
    end
    i
  end
end
