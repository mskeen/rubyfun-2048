# The main Board object
class Board
  attr_reader :width, :height

  DEFAULT_WIDTH = 4
  DEFAULT_HEIGHT = 4

  def initialize(width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
    @tiles = Hash.new(EmptyTile.new)
    @width = width
    @height = height
  end

  def place_at(column, row, tile)
    validate_location(column, row)
    @tiles[[column, row]] = tile
  end

  def tile_at(column, row)
    validate_location(column, row)
    @tiles[[column, row]]
  end

  def validate_location(column, row)
    fail "InvalidLocation" unless column > 0 && row > 0 && column <= width && row <= height
  end

end
