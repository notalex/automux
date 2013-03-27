module Automux
  module Paths
    extend self

    def data
      File.join(root, 'data/automux')
    end

    def root
      File.expand_path('../../../', __FILE__)
    end

    def blueprints
      paths_for String(__method__)
    end

    private ###

    def user_data(type)
      File.join(ENV['HOME'], '.automux', type, '*')
    end

    def paths_for(type)
      Dir[user_data(type), File.join(data, type, '*')]
    end
  end
end
