module Automux
  module Paths
    extend self

    def default_blueprint
      File.join(data, 'blueprints', 'default.yml')
    end

    def default_recipe
      File.join(data, 'recipes', 'default')
    end

    def data
      File.join(root, 'data/automux')
    end

    def root
      File.expand_path('../../../', __FILE__)
    end

    def views
      'lib/automux/views'
    end

    def user_assets
      File.join(ENV['HOME'], '.automux')
    end

    %w(blueprints recipes).each do |name|
      define_method(name) do
        Dir[File.join(user_assets, name, '*')]
      end
    end

    %w(blueprints recipes).each do |name|
      define_method("#{ name }_container") do
        File.join(user_assets, name)
      end
    end
  end
end
