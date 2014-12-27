require 'gosu'

# A Gosu view of the board
class BoardView

  UI = {
    'border' => { color: 0xff404040, back_color: Gosu::Color.argb(0xff404040), font_factor: 1.0 },
    0 =>        { color: 0xff404040, back_color: Gosu::Color.argb(0xff606060), font_factor: 1.0 },
    2 =>        { color: 0xff404040, back_color: Gosu::Color.argb(0xffeee4da), font_factor: 1.0 },
    4 =>        { color: 0xff404040, back_color: Gosu::Color.argb(0xffede0c8), font_factor: 1.0 },
    8 =>        { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff2b179), font_factor: 1.0 },
    16 =>       { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff59563), font_factor: 1.0 },
    32 =>       { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff67c5f), font_factor: 1.0 },
    64 =>       { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff65e3b), font_factor: 1.0 },
    128 =>      { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedcf72), font_factor: 0.8 },
    256 =>      { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedcc61), font_factor: 0.8 },
    512 =>      { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.8 },
    1024 =>     { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 },
    2048 =>     { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 },
    4096 =>     { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 },
    8192 =>     { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 }
  }

  STEPS_PER_BUMP = 4
  TILE_SIZE = 100
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
    ui = UI['border']
    window.draw_quad(
      TILE_SIZE, TILE_SIZE, ui[:back_color],
      TILE_SIZE, (board.height + 1) * TILE_SIZE, ui[:back_color],
      (board.width + 1) * TILE_SIZE, (board.height + 1) * TILE_SIZE, ui[:back_color],
      (board.width + 1) * TILE_SIZE, TILE_SIZE, ui[:back_color]
    )

    board.locations.each do |loc|
      if loc.empty?
        window.draw_quad(
          loc.col * TILE_SIZE + BORDER, loc.row * TILE_SIZE + BORDER, UI[0][:back_color],
          loc.col * TILE_SIZE + BORDER, (loc.row + 1) * TILE_SIZE - BORDER, UI[0][:back_color],
          (loc.col+1) * TILE_SIZE - BORDER, (loc.row + 1) * TILE_SIZE - BORDER, UI[0][:back_color],
          (loc.col+1) * TILE_SIZE - BORDER, loc.row * TILE_SIZE + BORDER, UI[0][:back_color]
        )
      end
    end

    board.locations.each do |loc|
      mover = board.direction != :none && (loc.can_move?(board.direction) || loc.can_merge?(board.direction))
      diffx = mover ? TILE_SIZE / STEPS_PER_BUMP * @tick * Location::DIRECTIONS[board.direction][:delta_col] : 0
      diffy = mover ? TILE_SIZE / STEPS_PER_BUMP * @tick * Location::DIRECTIONS[board.direction][:delta_row] : 0
      ui = UI[loc.value]
      if !loc.empty?
        window.draw_quad(
          loc.col * TILE_SIZE + BORDER, loc.row * TILE_SIZE + BORDER, UI[0][:back_color],
          loc.col * TILE_SIZE + BORDER, (loc.row + 1) * TILE_SIZE - BORDER, UI[0][:back_color],
          (loc.col+1) * TILE_SIZE - BORDER, (loc.row + 1) * TILE_SIZE - BORDER, UI[0][:back_color],
          (loc.col+1) * TILE_SIZE - BORDER, loc.row * TILE_SIZE + BORDER, UI[0][:back_color]
        )
        window.draw_quad(
          diffx + loc.col * TILE_SIZE + BORDER, diffy + loc.row * TILE_SIZE + BORDER, ui[:back_color],
          diffx + loc.col * TILE_SIZE + BORDER, diffy + (loc.row + 1) * TILE_SIZE - BORDER, ui[:back_color],
          diffx + (loc.col+1) * TILE_SIZE - BORDER, diffy + (loc.row + 1) * TILE_SIZE - BORDER, ui[:back_color],
          diffx + (loc.col+1) * TILE_SIZE - BORDER, diffy + loc.row * TILE_SIZE + BORDER, ui[:back_color]
        )
        font.draw_rel(
          loc.value.to_s,
          diffx + loc.col * TILE_SIZE + TILE_SIZE / 2,
          diffy + loc.row * TILE_SIZE + TILE_SIZE / 2,
          1, 0.5, 0.5, ui[:font_factor], ui[:font_factor], ui[:color]
        )
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
    @font ||= Gosu::Font.new(window, Gosu::default_font_name, 60)
  end

end
