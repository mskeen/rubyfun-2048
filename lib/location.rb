class Location
  attr_reader :col, :row
  attr_accessor :value

  def initialize(col, row, value = 0)
    @col = col
    @row = row
    @value = value
  end

  def empty?
    value == 0
  end

end
