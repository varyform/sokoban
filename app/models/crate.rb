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
    if any_of_type_in_place?(Target)
      "sprites/gameplay/2.png"
    else
      "sprites/gameplay/1.png"
    end
  end
end
