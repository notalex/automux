Given(/^I have provided a blueprint with the following window information$/) do |table|
  windows_data = common_transformations(table.hashes)
  @data = {"project_name"=>"test", "project_root"=>"~/"}
  @data['windows'] = windows_data
end

When(/^the windows are setup$/) do
  @session = Automux::Core::Tmux::Session.new(@data)
  @session.setup_windows
end

Then(/^the window with the name "(.+)" should have the following$/) do |name, table|
  window = @session.windows.find { |window| window.name == name }
  params = common_transformations(table.hashes).first
  params.each do |field, value|
    window.send(field).must_equal value
  end
end

