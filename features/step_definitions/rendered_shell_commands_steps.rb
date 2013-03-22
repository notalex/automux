Given(/^I provide the following blueprint$/) do |string|
  File.open('features/fixtures/blueprints/sample.yml', 'w') { |f| f.write(string) }
end

When(/^Automux processes this blueprint$/) do
  params = { blueprint_name: 'sample', recipe_name: 'default' }
  @results = Automux::Controller::Recipes.new(params).automate
end

Then(/^the rendered sequence of shell commands should be$/) do |string|

  results_array = @results.split("\n")
  output_array = string.split("\n")

  results_array.length.times do |i|
    assert_equal(results_array[i].strip, output_array[i].strip)
  end
end

