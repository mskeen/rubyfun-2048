class TileView

  attr_reader :tile_size, :border_size, :window

  TILE_UI = {
    0 =>    { color: 0xff404040, back_color: Gosu::Color.argb(0xff606060), font_factor: 1.0 },
    2 =>    { color: 0xff404040, back_color: Gosu::Color.argb(0xffeee4da), font_factor: 1.0 },
    4 =>    { color: 0xff404040, back_color: Gosu::Color.argb(0xffede0c8), font_factor: 1.0 },
    8 =>    { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff2b179), font_factor: 1.0 },
    16 =>   { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff59563), font_factor: 1.0 },
    32 =>   { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff67c5f), font_factor: 1.0 },
    64 =>   { color: 0xffffffff, back_color: Gosu::Color.argb(0xfff65e3b), font_factor: 1.0 },
    128 =>  { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedcf72), font_factor: 0.8 },
    256 =>  { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedcc61), font_factor: 0.8 },
    512 =>  { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.8 },
    1024 => { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 },
    2048 => { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 },
    4096 => { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 },
    8192 => { color: 0xffffffff, back_color: Gosu::Color.argb(0xffedc850), font_factor: 0.65 }
  }

  def initialize(window, tile_size, border_size)
    @window = window
    @tile_size = tile_size
    @border_size = border_size
  end

  def draw(location, diffx = 0, diffy = 0)
    ViewHelper.draw_square(window, TILE_UI[location.value][:back_color],
      diffx + location.col * tile_size + border_size,
      diffy + location.row * tile_size + border_size,
      diffx + (location.col+1) * tile_size - border_size,
      diffy + (location.row + 1) * tile_size - border_size
    )
    draw_label(location, diffx, diffy)
  end

  def draw_label(location, diffx, diffy)
    ui = TILE_UI[location.value]
    font.draw_rel(
      location.value.to_s,
      diffx + location.col * tile_size + tile_size / 2,
      diffy + location.row * tile_size + tile_size / 2,
      1, 0.5, 0.5, ui[:font_factor], ui[:font_factor], ui[:color]
    )
  end

  def draw_background(location)
    ViewHelper.draw_square(window, TILE_UI[0][:back_color],
      location.col * tile_size + border_size,
      location.row * tile_size + border_size,
      (location.col + 1) * tile_size - border_size,
      (location.row + 1) * tile_size - border_size
    )
  end

  protected

  def font
    @font ||= Gosu::Font.new(window, Gosu::default_font_name, 60)
  end

end
