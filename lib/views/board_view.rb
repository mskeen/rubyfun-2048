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
    board.each_location do |loc|
      color = COLORS[loc.value]
      window.draw_quad(loc.col * 40, loc.row * 40, color,
        loc.col*40, (loc.row + 1)*40, color,
        (loc.col+1) * 40, (loc.row + 1)*40, color,
        (loc.col+1) * 40, loc.row * 40, color)
      font.draw(loc.value.to_s, loc.col*40, loc.row*40, 1, 1.0, 1.0, 0xaa444400) unless loc.empty?
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
