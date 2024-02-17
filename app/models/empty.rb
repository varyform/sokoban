class Empty < Tile
  def sprite
    "sprites/gameplay/3.png"
  end

  def can_move?(direction)
    return false
  end
end
