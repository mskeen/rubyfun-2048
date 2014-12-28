class TileView

  def self.draw(window, location, color)
    ViewHelper.draw_square(window, color,
      location.col * BoardView::TILE_SIZE + BoardView::BORDER,
      location.row * BoardView::TILE_SIZE + BoardView::BORDER,
      (location.col+1) * BoardView::TILE_SIZE - BoardView::BORDER,
      (location.row + 1) * BoardView::TILE_SIZE - BoardView::BORDER
    )
  end
end
