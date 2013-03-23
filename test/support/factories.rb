HashFactory.define :session do
  {
    project_name: :test,
    project_root: '~/',
  }
end

HashFactory.define :window do
  {
    name: "name",
    panes: ['ls']
  }
end
