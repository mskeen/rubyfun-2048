require 'gosu'
require './lib/board.rb'
require './lib/views/board_view.rb'

class GameWindow < Gosu::Window

  KEY_HANDLERS = {
    Gosu::KbUp     => lambda { |game| game.tilt_board(:up) },
    Gosu::KbDown   => lambda { |game| game.tilt_board(:down) },
    Gosu::KbLeft   => lambda { |game| game.tilt_board(:left) },
    Gosu::KbRight  => lambda { |game| game.tilt_board(:right) },
    Gosu::KbEscape => lambda { |game| game.close }
  }

  def initialize
    super(1280, 960, false)
    self.caption = '2048'
    board.start_game
  end

  def draw
    view.draw
  end

  def button_down(id)
    if handler = KEY_HANDLERS[id]
      handler.call(self)
    end
  end

  def view
    @view ||= BoardView.new(self, board)
  end

  def board
    @board ||= Board.new
  end

  def tilt_board(direction)
    board.player_move(direction)
  end

end

begin
  window = GameWindow.new
  window.show
end
