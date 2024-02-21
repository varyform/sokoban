class Empty < Tile
  def sprite
    "sprites/gameplay/3.png"
  end

  def can_move?(_direction)
    false
  end

  def weight
    10
  end
end
