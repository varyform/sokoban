class Wall < Tile
  def sprite
    "sprites/gameplay/7.png"
  end

  def to_sprite
    super.merge(static: true)
  end

  def weight
    20
  end
end
