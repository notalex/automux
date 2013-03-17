class TmuxWindow
  attr_reader :options, :name

  def initialize(data)
    @name = data.keys.first
    @options = data.values.first
  end

  def panes
    return nil unless options.is_a?(Hash)

    @panes ||= options['panes'].map { |command| TmuxPane.new(command) }
  end

  def has_panes?
    !panes.nil?
  end

  def layout
    return nil unless options.is_a?(Hash)

    options['layout'] || 'main-vertical'
  end
end
