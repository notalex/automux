module Automux
  module Paths
    extend self

    def data
      File.join(root, 'data/automux')
    end

    def root
      File.expand_path('../../../', __FILE__)
    end
  end
end
