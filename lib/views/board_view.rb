require 'gosu'

# A Gosu view of the board
class BoardView

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

  def initialize(window, board)
    @window = window
    @board = board
  end

  def draw
    (1..board.width).each do |col|
      (1..board.height).each do |row|
        tile = board.tile_at(col,row)
        color = COLORS[tile.value]
        window.draw_quad(col * 40, row * 40, color,
          col*40, (row + 1)*40, color,
          (col+1) * 40, (row + 1)*40, color,
          (col+1) * 40, row * 40, color)
        font.draw(tile.value.to_s, col*40, row*40, 1, 1.0, 1.0, 0xaa444400) unless tile.empty?
      end
    end
  end

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
