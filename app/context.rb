class Context
  # @example
  #   Context.load # => {}
  #
  # @return [Hash]
  def self.load
    File.open("#{ROOT}/data.yml", "r") { |file| YAML.load(file) } || {}
  end

  # @example
  #   Context.dump({})
  #
  # @param [Hash] data
  def self.dump(data)
    File.open("#{ROOT}/data.yml", "w") { |file| YAML.dump(data, file) }
  end

  # @example
  #   Context.capture do |data|
  #     data["categories"] = []
  #     data["recipes"] = []
  #   end
  #
  # @yield [data]
  # @yieldparam data [Hash]
  def self.manage(&block)
    data = self.load()
    block.call(data)
    self.dump(data)
  end
end
