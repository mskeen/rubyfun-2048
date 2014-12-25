require './lib/tile'
require './lib/empty_tile'
require 'gosu'

# The main Board object
class Board
  attr_reader :width, :height

  DEFAULT_WIDTH = 4
  DEFAULT_HEIGHT = 4

  TILT_MOVEMENTS = {
    up:    { loopdir: :up,   delta_x: 0,  delta_y: -1 },
    down:  { loopdir: :down, delta_x: 0,  delta_y: 1 },
    left:  { loopdir: :up,   delta_x: -1, delta_y: 0 },
    right: { loopdir: :down, delta_x: 1,  delta_y: 0 }
  }

  COLORS = {
    0 => Gosu::Color::GRAY,
    2 => Gosu::Color::WHITE,
    4 => Gosu::Color::RED,
    8 => Gosu::Color::BLUE,
    16 => Gosu::Color::GREEN,
    32 => Gosu::Color::GREEN,
    64 => Gosu::Color::GREEN,
    128 => Gosu::Color::GREEN,
    256 => Gosu::Color::GREEN,
    512 => Gosu::Color::GREEN,
    1024 => Gosu::Color::GREEN,
    2048 => Gosu::Color::GREEN
  }

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

  def valid_location?(column, row)
    [column, row].min > 0 && column <= width && row <= height
  end

  def validate_location(column, row)
    fail "InvalidLocation" unless valid_location?(column, row)
  end

  def draw(window)
    (1..width).each do |col|
      (1..height).each do |row|
        tile = tile_at(col,row)
        color = COLORS[tile.value]
        window.draw_quad(col * 40, row * 40, color,
          col*40, (row + 1)*40, color,
          (col+1) * 40, (row + 1)*40, color,
          (col+1) * 40, row * 40, color)
        window.font.draw(tile.value.to_s, col*40, row*40, 1, 1.0, 1.0, 0xaa444400) unless tile.empty?
      end
    end
  end

  def add_random_tile
    loop do
      col = rand(width) + 1
      row = rand(height) + 1
      if tile_at(col,row).empty?
        place_at(col,row,Tile.new(2))
        break
      end
    end
  end

  def tilt(direction)
    tilt_meta = TILT_MOVEMENTS[direction]
    fail "InvalidDirection" if tilt_meta.nil?
    if tilt_meta[:loop] == :up
      cols = (1..width)
      rows = (1..height)
    else
      cols = (width.downto(1))
      rows = (height.downto(1))
    end
    total_changes = 0
    loop do
      change_count = 0
      cols.each do |col|
        rows.each do |row|
          if swap(col, row, col + tilt_meta[:delta_x], row + tilt_meta[:delta_y])
            change_count += 1
          end
        end
      end
      total_changes += change_count
      break if change_count == 0
    end
    add_random_tile if total_changes > 0
  end

  def swap(col1, row1, col2, row2)
    if valid_location?(col1,row1) && valid_location?(col2,row2)
      tile1 = tile_at(col1, row1)
      tile2 = tile_at(col2, row2)
      if tile2.empty? && !tile1.empty?
        place_at(col1,row1,tile2)
        place_at(col2,row2,tile1)
        return true
      elsif tile2.value == tile1.value && !tile1.empty?
        place_at(col2,row2, Tile.new(tile1.value * 2))
        place_at(col1,row1, EmptyTile.new)
        return true
      end
    end
    false
  end

end
