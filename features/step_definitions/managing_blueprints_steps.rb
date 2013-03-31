When(/^I invoke Automux to "(.+)" the blueprint "(.+)"$/) do |action, name|
  system %[bin/automux blueprint #{ action } #{ name }]
  @results = File.read('/tmp/results')
end

When(/^I call Automux to "(.+)" the blueprint "(.+)" as "(.+)"$/) do |action, target_name, destination_name|
  system %[bin/automux blueprint #{ action } #{ target_name } #{ destination_name }]
  @results = File.read('/tmp/results')
end
