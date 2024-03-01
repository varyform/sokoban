class Empty < Tile
  def sprite
    "sprites/gameplay/ground_06.png"
  end

  def can_move?(_direction)
    false
  end

  def weight
    10
  end
end
