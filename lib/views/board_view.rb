require 'gosu'

# A Gosu view of the board
class BoardView

  COLORS = {
    'border' => Gosu::Color.argb(0xff404040),
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

  STEPS_PER_BUMP = 4
  TILE_SIZE = 80
  BORDER = 10

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
    window.caption = "2048 #{@tick} #{board.direction}"
    @tick += 1
    new_frame if @tick > STEPS_PER_BUMP
  end

  def draw
    changes = false
    window.draw_quad(
      TILE_SIZE - BORDER, TILE_SIZE - BORDER, COLORS['border'],
      TILE_SIZE - BORDER, (board.height + 1) * TILE_SIZE + BORDER, COLORS['border'],
      (board.width + 1) * TILE_SIZE + BORDER, (board.height + 1) * TILE_SIZE + BORDER, COLORS['border'],
      (board.width + 1) * TILE_SIZE + BORDER, TILE_SIZE - BORDER, COLORS['border']
    )

    board.locations.each do |loc|
      if loc.empty?
        window.draw_quad(
          loc.col * TILE_SIZE, loc.row * TILE_SIZE, COLORS[0],
          loc.col * TILE_SIZE, (loc.row + 1) * TILE_SIZE, COLORS[0],
          (loc.col+1) * TILE_SIZE, (loc.row + 1) * TILE_SIZE, COLORS[0],
          (loc.col+1) * TILE_SIZE, loc.row * TILE_SIZE, COLORS[0]
        )
      end
    end

    board.locations.each do |loc|
      mover = board.direction != :none && (loc.can_move?(board.direction) || loc.can_merge?(board.direction))
      diffx = mover ? TILE_SIZE / STEPS_PER_BUMP * @tick * Location::DIRECTIONS[board.direction][:delta_col] : 0
      diffy = mover ? TILE_SIZE / STEPS_PER_BUMP * @tick * Location::DIRECTIONS[board.direction][:delta_row] : 0
      color = COLORS[loc.value]
      if !loc.empty?
        window.draw_quad(
          loc.col * TILE_SIZE, loc.row * TILE_SIZE, COLORS[0],
          loc.col * TILE_SIZE, (loc.row + 1) * TILE_SIZE, COLORS[0],
          (loc.col+1) * TILE_SIZE, (loc.row + 1) * TILE_SIZE, COLORS[0],
          (loc.col+1) * TILE_SIZE, loc.row * TILE_SIZE, COLORS[0]
        )
        window.draw_quad(
          diffx + loc.col * TILE_SIZE, diffy + loc.row * TILE_SIZE, color,
          diffx + loc.col * TILE_SIZE, diffy + (loc.row + 1) * TILE_SIZE, color,
          diffx + (loc.col+1) * TILE_SIZE, diffy + (loc.row + 1) * TILE_SIZE, color,
          diffx + (loc.col+1) * TILE_SIZE, diffy + loc.row * TILE_SIZE, color
        )
        font.draw(loc.value.to_s, diffx + loc.col * TILE_SIZE, diffy + loc.row * TILE_SIZE, 1, 1.0, 1.0, 0xaa444400) unless loc.empty?
      end
      changes = true if mover
    end
    new_frame if !changes
  end

  private

  def window
    @window
  end

  def board
    @board
  end

  def font
    @font ||= Gosu::Font.new(window, Gosu::default_font_name, 20)
  end

end
