require 'fileutils'

module Automux
  module Setup
    extend self

    def user_assets_folders
      %w(blueprints recipes).each do |asset_name|
        FileUtils.mkdir_p(Automux::Paths.public_send("#{ asset_name }_container"))
      end
    end

    def clone_default_files
      FileUtils.cp(Automux::Paths.default_blueprint, Automux::Paths.blueprints_container)
      FileUtils.cp(Automux::Paths.default_recipe, Automux::Paths.recipes_container)
    end
  end
end
