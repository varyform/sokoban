class Player < Tile
  def static?
    false
  end

  def cam_move?(direction)
    return false unless super(direction)

    # add logic
  end

  def sprite
    "sprites/gameplay/5.png"
  end
end
