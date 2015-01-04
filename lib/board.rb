require './lib/location'

# The main Board object
class Board
  attr_reader :width, :height, :locations, :direction
  attr_accessor :score, :move_count

  DEFAULT_WIDTH = 4
  DEFAULT_HEIGHT = 4
  DEFAULT_NEW_TILE_COUNT = 2
  NEW_TILE_DISTRIBUTION = [2,2,2,2,2,2,2,2,2,4]

  def initialize(width = DEFAULT_WIDTH, height = DEFAULT_HEIGHT)
    @width = width
    @height = height
    @direction = :none
    clear_board
  end

  def clear_board
    @score = @move_count = 0
    @locations = []
    (1..width).each do |col|
      (1..height).each do |row|
        @locations << Location.new(self, col, row, Location::EMPTY_VALUE)
      end
    end
  end

  def locations_for_direction(direction)
    direction && Location::DIRECTIONS[direction][:reverse] ? locations.reverse : locations
  end

  def location(col,row)
    return nil if col <= 0 || row <= 0 || col > width || row > height
    @locations[(col - 1) * width + row - 1]
  end

  def start_game(add_tile_count = DEFAULT_NEW_TILE_COUNT)
    add_tile_count.times { add_random_tile }
  end

  def add_random_tile
    while !(loc = random_location).empty? do end
    loc.value = NEW_TILE_DISTRIBUTION[rand(NEW_TILE_DISTRIBUTION.size)]
    @move_count += 1
  end

  def player_move(direction)
    @direction = direction if self.direction == :none
  end

  def bump(add_random = true)
    return false if direction == :none
    finalize_merges
    if execute_movements
      @turn_changes = true
      return true
    end
    setup_next_turn(add_random)
    false
  end

  def tilt(direction, add_random = true)
    fail "InvalidDirection" if Location::DIRECTIONS[direction].nil?
    @direction = direction
    nil while bump(add_random)
  end

  private

  def empty_tile_count
    locations.count { |loc| loc.empty? }
  end

  def random_location
    location(rand(width) + 1, rand(height) + 1)
  end

  def execute_movements
    locations_for_direction(@direction).inject(false) do |moved, loc|
      loc.move(@direction) || loc.merge(@direction) || moved
    end
  end

  def finalize_merges
    locations.each { |loc| loc.merged! if loc.merging? }
  end

  def setup_next_turn(add_random = true)
    @direction = :none
    locations.each { |loc| loc.reset_for_next_turn }
    add_random_tile if add_random && @turn_changes && empty_tile_count > 0
    @turn_changes = false
  end

end
