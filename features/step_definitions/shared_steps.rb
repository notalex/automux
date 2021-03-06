Given(/^I have the following blueprint named "(.+)"$/) do |name, string|
  path = File.join(Automux::Paths.blueprints_container, "#{ name }.yml")
  File.open(path, 'w') { |f| f.write(string) }
end

When(/^Automux processes the blueprint "(.+)" with the following options$/) do |name, table|
  opts = table.hashes.map { |h| h.values }.flatten.join(' ')
  system %[bin/automux #{ name } #{ opts }]
  @results = File.read('/tmp/results')
end

Then(/^the rendered sequence of shell commands should be$/) do |string|
  expected_array, results_array = expected_and_results_array(string)

  expected_array.length.times do |i|
    assert_equal(expected_array[i], results_array[i])
  end
end

Then(/^the rendered sequence of shell commands should contain$/) do |string|
  expected_array, results_array = expected_and_results_array(string)

  expected_array.each do |command|
    assert_includes(results_array, command)
  end
end

def expected_and_results_array(string)
  results_array = @results.split("\n").map { |text| text.strip }
  expected_array = expected_array_for(string)
  [expected_array, results_array]
end

def expected_array_for(string)
  expected_string = string.gsub(/\$HOME/, ENV['HOME'])
  expected_array = expected_string.squeeze("\n").split("\n")
  expected_array.map { |text| text.strip }
end

When(/^I invoke Automux with the blueprint "(.*?)"$/) do |name|
  system %[bin/automux #{ name }]
  @results = File.read('/tmp/results')
end

When(/^I invoke Automux with the arguments "(.*?)"$/) do |arguments|
  system %[bin/automux #{ arguments }]
  @results = File.read('/tmp/results')
end

Given(/^I have the following recipe named "(.+)"$/) do |name, string|
  path = File.join(Automux::Paths.recipes_container, "#{ name }.sh.erb")
  File.open(path, 'w') { |f| f.write(string) }
end
