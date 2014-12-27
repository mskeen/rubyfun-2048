require './lib/location'

# The main Board object
class Board
  attr_reader :width, :height, :locations

  DEFAULT_WIDTH = 4
  DEFAULT_HEIGHT = 4
  DEFAULT_NEW_TILE_COUNT = 2
  DEFAULT_NEW_TILE_VALUE = 2
  TILT_MOVEMENTS = {
    up:    { reverse: false,   delta_col: 0,  delta_row: -1 },
    down:  { reverse: true, delta_col: 0,  delta_row: 1 },
    left:  { reverse: false,   delta_col: -1, delta_row: 0 },
    right: { reverse: true, delta_col: 1,  delta_row: 0 }
  }

  def initialize(width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
    @width = width
    @height = height
    clear_board
  end

  def clear_board
    @locations = []
    (1..width).each do |col|
      (1..height).each do |row|
        @locations << Location.new(col, row, Location::EMPTY_VALUE)
      end
    end
  end

  def location(col,row)
    return nil if col <= 0 || row <= 0 || col > width || row > height
    @locations[(col - 1) * width + row - 1]
  end

  def start_game(add_tile_count = DEFAULT_NEW_TILE_COUNT)
    add_tile_count.times { add_random_tile }
  end

  def add_random_tile(value = DEFAULT_NEW_TILE_VALUE)
    while !(loc = random_location).empty? do end
    loc.value = value
  end

  def player_move(direction)
    add_random_tile if tilt(direction) > 0 && empty_tile_count > 0
  end

  def tilt(direction)
    fail "InvalidDirection" if TILT_MOVEMENTS[direction].nil?
    locations.each { |loc| loc.reset_for_next_turn }
    move_counter = 0
    move_counter += 1 while bump_one_square(direction) != 0
    move_counter
  end

  private

  def empty_tile_count
    locations.count { |loc| loc.empty? }
  end

  def random_location
    location(rand(width) + 1, rand(height) + 1)
  end

  def neighbour(loc, delta_col, delta_row)
    location(loc.col + delta_col, loc.row + delta_row)
  end

  def bump_one_square(direction)
    tilt = TILT_MOVEMENTS[direction]
    (tilt[:reverse] ? locations.reverse : locations).inject(0) do |sum, loc|
      sum + move_tile(loc, neighbour(loc, tilt[:delta_col], tilt[:delta_row]))
    end
  end

  def move_tile(from_loc, to_loc)
    (from_loc && to_loc && to_loc.merge(from_loc)) ? 1 : 0
  end
end
