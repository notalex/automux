module Automux
  module Paths
    extend self

    def data
      if ENV['AUTOMUX_ENV'] == 'test'
        File.join(root, 'features/fixtures/')
      else
        File.join(root, 'data/automux')
      end
    end

    def root
      File.expand_path('../../../', __FILE__)
    end
  end
end
