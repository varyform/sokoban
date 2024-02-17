class Crate < Tile
  def can_move?(direction)
    # return false unless super(direction)

    target = entity_at(direction)

    target.is_a?(Empty) || target.is_a?(Target)
  end

  def weight
    40
  end

  def move!(direction)
    @moving = 18

    state.level.stats.pushes += 1

    target = entity_at(direction)

    # puts "Moving Crate to #{target.x} - #{target.y} #{target.class}"

    play_sfx(args, "crate/moving")

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
