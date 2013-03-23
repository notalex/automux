def common_transformations(params)
  params.each do |h|
    h['panes'] = h['panes'].split(',') if h['panes']
    h['index'] = h['index'].empty? ? nil : h['index'].to_i
  end
end
