require './lib/location'

# The main Board object
class Board
  attr_reader :width, :height, :locations, :direction

  DEFAULT_WIDTH = 4
  DEFAULT_HEIGHT = 4
  DEFAULT_NEW_TILE_COUNT = 2
  DEFAULT_NEW_TILE_VALUE = 2

  def initialize(width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
    @width = width
    @height = height
    @direction = :none
    clear_board
  end

  def clear_board
    @locations = []
    (1..width).each do |col|
      (1..height).each do |row|
        @locations << Location.new(self, col, row, Location::EMPTY_VALUE)
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
    @direction = direction
  end

  def bump(add_random = true)
    finalize_merges
    return true if execute_movements
    setup_next_turn(add_random)
    false
  end

  def tilt(direction, add_random = true)
    fail "InvalidDirection" if Location::DIRECTIONS[direction].nil?
    @direction = direction
    nil while bump(add_random)
  end

  def to_s
    a = []
    (1..height).each do |row|
      a << locations.select { |loc| loc.row == row }.map(&:value).join
    end
    a.join("\n")
  end

  private

  def empty_tile_count
    locations.count { |loc| loc.empty? }
  end

  def random_location
    location(rand(width) + 1, rand(height) + 1)
  end

  def execute_movements
    return false if !(tilt = Location::DIRECTIONS[@direction])
    (tilt[:reverse] ? locations.reverse : locations).inject(false) do |moved, loc|
      loc.move(@direction) || loc.merge(@direction) || moved
    end
  end

  def finalize_merges
    locations.each { |loc| loc.merged! if loc.merging? }
  end

  def setup_next_turn(add_random = true)
    @direction = :none
    locations.each { |loc| loc.reset_for_next_turn }
    add_random_tile if add_random && empty_tile_count > 0
  end

end
