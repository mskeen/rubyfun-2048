class Tile
  attr_accessor :value

  def initialize(value)
    self.value = value
  end

  def empty?
    false
  end
end
