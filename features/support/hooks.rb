After do
  path = File.join(ENV['HOME'], '.automux', 'blueprints', 'test_sample.yml')
  FileUtils.rm(path) if FileTest.exists?(path)
end
