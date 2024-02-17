class Crate < Tile
  def static?
    false
  end

  def can_move?(direction)
    target = entity_at(direction)

    target.is_a?(Empty) || target.is_a?(Target)
  end

  def move!(direction)
    target = entity_at(direction)

    if target.is_a?(Target)
      place_on_top_of!(target)
    else
      swap_with!(target)
    end
  end

  def sprite
    "sprites/gameplay/1.png"
  end
end
