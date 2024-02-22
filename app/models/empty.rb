class Empty < Tile
  weight 10
  sprite "gameplay/3.png"

  def can_move?(_direction)
    false
  end
end
