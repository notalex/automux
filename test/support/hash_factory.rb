class HashFactory
  @@factories = {}

  class << self
    def define(name, &block)
      @@factories[name.to_s] = block
    end

    def build(name, attrs = {})
      defaults = stringify(@@factories[name.to_s].call)
      attributes = stringify(attrs)
      defaults.merge(attributes)
    end

    def stringify(data)
      Hash[data.map { |k, v| [k.to_s, v] }]
    end
  end
end
