Given(/^I provide the following blueprint$/) do |string|
  File.open('data/automux/blueprints/ignored.yml', 'w') { |f| f.write(string) }
end

When(/^Automux processes this blueprint$/) do
  system %[bin/automux ignored]
  @results = File.read('/tmp/results')
end

When(/^Automux processes this blueprint with the following options$/) do |table|
  opts = table.hashes.map { |h| h.values }.flatten.join(' ')
  system %[bin/automux ignored #{ opts }]
  @results = File.read('/tmp/results')
end

Then(/^the rendered sequence of shell commands should be$/) do |string|

  results_array = @results.split("\n")
  expected_string = string.gsub(/\$HOME/, ENV['HOME'])
  expected_array = expected_string.split("\n").reject { |text| text.split.empty? }

  expected_array.length.times do |i|
    assert_equal(expected_array[i].strip, results_array[i].strip)
  end
end
