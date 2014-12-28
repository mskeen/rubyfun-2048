class ViewHelper

  def self.draw_square(window, color, left, top, right, bottom)
    window.draw_quad(
      left, top, color, left, bottom, color,
      right, bottom, color, right, top, color
    )
  end

end
