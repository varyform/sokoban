class Crate < Tile
  def static?
    false
  end

  def cam_move?
    return unless super

    # add logic
  end

  def sprite
    "sprites/gameplay/1.png"
  end
end
