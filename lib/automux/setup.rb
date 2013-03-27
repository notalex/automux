require 'fileutils'

module Automux
  module Setup
    extend self

    def user_assets_folders
      %w(blueprints recipes).each do |asset_name|
        path = File.join(Automux::Paths.user_assets, asset_name)
        FileUtils.mkdir_p(path)
      end
    end
  end
end
