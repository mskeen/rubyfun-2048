require 'gosu'
require './lib/board.rb'

class GameWindow < Gosu::Window

  attr_reader :board, :font

  KEY_HANDLERS = {
    Gosu::KbUp     => lambda { |game| game.board.tilt(:up) },
    Gosu::KbDown   => lambda { |game| game.board.tilt(:down) },
    Gosu::KbLeft   => lambda { |game| game.board.tilt(:left) },
    Gosu::KbRight  => lambda { |game| game.board.tilt(:right) },
    Gosu::KbEscape => lambda { |game| game.close }
  }

  def initialize
    super(1280, 960, false)
    self.caption = '2048'
    @board = Board.new
    @board.add_random_tile
    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)
  end

  def draw
    @board.draw(self)
  end

  def update

  end

  def button_down(id)
    if handler = KEY_HANDLERS[id]
      puts id
      handler.call(self)
    end
  end

end

begin
  window = GameWindow.new
  window.show
end
