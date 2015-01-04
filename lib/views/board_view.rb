require 'gosu'
require './lib/views/tile_view'
require './lib/views/view_helper'

# A Gosu view of the board
class BoardView

  BACKGROUND_COLOR = Gosu::Color.argb(0xff404040)

  TILE_SIZE = 100
  BORDER_SIZE = 5
  STEPS_PER_BUMP = 4

  def initialize(window, board)
    @window = window
    @board = board
    new_frame
  end

  def new_frame
    board.bump
    @tick = 0
  end

  def update
    @tick += 1
    new_frame if @tick > STEPS_PER_BUMP
  end

  def draw
    draw_background
    new_frame unless draw_tiles
    show_stats
  end

  def draw_background
    ViewHelper.draw_square(window, BACKGROUND_COLOR,
      TILE_SIZE - BORDER_SIZE, TILE_SIZE - BORDER_SIZE,
      (board.width + 1) * TILE_SIZE + BORDER_SIZE,
      (board.height + 1) * TILE_SIZE + BORDER_SIZE
    )
    board.locations.each { |loc| tile_view.draw_background(loc) }
  end

  def draw_tiles
    changes = false
    board.locations.select{ |loc| !loc.empty? }.each do |loc|
      moving = board.direction != :none &&
        (loc.can_move?(board.direction) || loc.can_merge?(board.direction))
      move_amount = moving ? TILE_SIZE / STEPS_PER_BUMP * @tick : 0
      diffx = move_amount * Location::DIRECTIONS[board.direction][:delta_col]
      diffy = move_amount * Location::DIRECTIONS[board.direction][:delta_row]
      tile_view.draw(loc, diffx, diffy)
      changes = true if moving
    end
    changes
  end

  private

  def window
    @window
  end

  def board
    @board
  end

  def tile_view
    @tile_view ||= TileView.new(window, TILE_SIZE, BORDER_SIZE)
  end

  def show_stats
    middlex = TILE_SIZE * (board.width / 2 + 1)
    font.draw_rel("Score: #{board.score.to_s}",
      middlex, 20, 1, 0.5, 0.5, 1.0, 1.0, 0xffffffff
    )
    font.draw_rel("Tile Count: #{board.move_count.to_s}",
      middlex, 50, 1, 0.5, 0.5, 1.0, 1.0, 0xffffffff
    )
  end

  def font
    @font ||= Gosu::Font.new(window, Gosu::default_font_name, 30)
  end

end
