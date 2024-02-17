class Crate < Tile
  def static?
    false
  end

  def can_move?(direction)
    entity_at(direction).is_a?(Empty)
  end

  def move!(direction)
    swap_with!(entity_at(direction)) unless entity_at(direction).is_a?(Target)
  end

  def sprite
    "sprites/gameplay/1.png"
  end
end
