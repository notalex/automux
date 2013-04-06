When(/^I invoke Automux with the recipe "(.+)" and the blueprint "(.+)"$/) do |recipe_name, blueprint_name|
  system %[bin/automux #{ blueprint_name } #{ recipe_name }]
  @results = File.read('/tmp/results')
end
