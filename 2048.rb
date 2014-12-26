require 'gosu'
require './lib/board.rb'
require './lib/views/board_view.rb'

class GameWindow < Gosu::Window

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
    board.start_game
  end

  def draw
    view.draw
  end

  def update
  end

  def button_down(id)
    if handler = KEY_HANDLERS[id]
      puts id
      handler.call(self)
    end
  end

  def view
    @view ||= BoardView.new(self, board)
  end

  def board
    @board
  end

end

begin
  window = GameWindow.new
  window.show
end
