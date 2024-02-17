class Player < Tile
  def tick
    @moving -= 1 if @moving

    @moving = false if @moving && @moving <= 0
  end

  def can_move?(direction)
    return false if @moving

    target = entity_at(direction)

    puts "#{target.class}"

    return target.can_move?(direction) if target.is_a?(Crate)

    super(direction) || target.is_a?(Empty) || target.is_a?(Target)
  end

  def move!(direction)
    @moving = 10

    target = entity_at(direction)

    if target.is_a?(Crate)
      puts "Moving Crate at #{target.x} - #{target.y}"
      target.move!(direction)
      target = entity_at(direction)
      # swap_with!(target)
      place_on_top_of!(target)
    elsif target.is_a?(Empty)
      place_on_top_of!(target)
      # if any_of_type_in_place?(Target)
      #   place_on_top_of!(target)
      # else
      #   swap_with!(target)
      # end
    elsif target.is_a?(Target)
      place_on_top_of!(target)
    end
  end

  def sprite
    "sprites/gameplay/5.png"
  end
end
