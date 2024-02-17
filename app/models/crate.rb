class Crate < Tile
  def can_move?(direction)
    # return false unless super(direction)

    target = entity_at(direction)

    target.is_a?(Empty) || target.is_a?(Target)
  end

  def move!(direction)
    target = entity_at(direction)

    puts "Moving Crate to #{target.x} - #{target.y} #{target.class}"

    place_on_top_of!(target)
  end

  def sprite
    if any_of_type_in_place?(Target)
      "sprites/gameplay/2.png"
    else
      "sprites/gameplay/1.png"
    end
  end
end
