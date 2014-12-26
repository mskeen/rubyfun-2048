require './lib/location'
require 'gosu'

# The main Board object
class Board
  attr_reader :width, :height

  DEFAULT_WIDTH = 4
  DEFAULT_HEIGHT = 4
  DEFAULT_NEW_TILE_COUNT = 2
  DEFAULT_NEW_TILE_VALUE = 2

  TILT_MOVEMENTS = {
    up:    { loopdir: :up,   delta_x: 0,  delta_y: -1 },
    down:  { loopdir: :down, delta_x: 0,  delta_y: 1 },
    left:  { loopdir: :up,   delta_x: -1, delta_y: 0 },
    right: { loopdir: :down, delta_x: 1,  delta_y: 0 }
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

  def each_location(reverse = false)
    if reverse
      (width.downto(1)).each do |col|
        (height.downto(1)).each do |row|
          yield location(col, row)
        end
      end
    else
      (1..width).each do |col|
        (1..height).each do |row|
          yield location(col, row)
        end
      end
    end
  end

  def start_game(add_tile_count = DEFAULT_NEW_TILE_COUNT)
    add_tile_count.times { add_random_tile }
  end

  def random_location
    location(rand(width) + 1, rand(height) + 1)
  end

  def add_random_tile(value = DEFAULT_NEW_TILE_VALUE)
    loop do
      add_location = random_location
      if add_location.empty?
        add_location.value = value
        return
      end
    end
  end

  def tilt(direction)
    tilt_meta = TILT_MOVEMENTS[direction]
    fail "InvalidDirection" if tilt_meta.nil?
    total_changes = 0
    loop do
      change_count = 0
      each_location(tilt_meta[:reverse]) do |loc|
        if move(loc, location(loc.col + tilt_meta[:delta_x], loc.row + tilt_meta[:delta_y]))
          change_count += 1
        end
      end
      total_changes += change_count
      break if change_count == 0
    end
    add_random_tile if total_changes > 0
  end

  def move(from_loc, to_loc)
    if from_loc && to_loc
      if !from_loc.empty? && (to_loc.empty? || to_loc.value == from_loc.value)
        to_loc.value += from_loc.value
        from_loc.value = 0
        return true
      end
    end
    false
  end

end
