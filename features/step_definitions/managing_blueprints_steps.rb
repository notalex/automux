Given(/^the user assets has the following blueprint saved as "(.+)"$/) do |name, string|
  path = File.join(Automux::Paths.blueprints_container, "#{ name }.yml")
  File.open(path, 'w') { |f| f.write(string) }
end

When(/^I invoke Automux to "(.+)" the blueprint "(.+)"$/) do |action, name|
  system %[bin/automux blueprint #{ action } #{ name }]
  @results = File.read('/tmp/results')
end

