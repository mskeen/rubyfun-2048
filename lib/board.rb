require './lib/location'

# The main Board object
class Board
  attr_reader :width, :height

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
    @locations = Hash.new
    @width = width
    @height = height
    clear_board
  end

  def clear_board
    (1..width).each do |col|
      (1..height).each do |row|
        @locations[[col, row]] = Location.new(col, row, 0)
      end
    end
  end

  def location(col,row)
    @locations[[col, row]]
  end

  def locations
    array = []
    (1..width).each do |col|
      (1..height).each do |row|
        array << location(col, row)
      end
    end
    array
  end

  def start_game(add_tile_count = DEFAULT_NEW_TILE_COUNT)
    add_tile_count.times { add_random_tile }
  end

  def add_random_tile(value = DEFAULT_NEW_TILE_VALUE)
    loop do
      if (add_location = random_location).empty?
        add_location.value = value
        return
      end
    end
  end

  def tilt(direction)
    fail "InvalidDirection" if TILT_MOVEMENTS[direction].nil?
    counter = 0
    loop do
      break if bump_one_square(direction) == 0
      counter += 1
    end
    add_random_tile if counter > 0 && empty_tile_count > 0
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
    if from_loc && to_loc
      if !from_loc.empty? && (to_loc.empty? || to_loc.value == from_loc.value)
        to_loc.value += from_loc.value
        from_loc.value = 0
        return 1
      end
    end
    0
  end

end
