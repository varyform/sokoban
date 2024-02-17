class Player < Tile
  def static?
    false
  end

  def can_move?(direction)
    target = entity_at(direction)

    puts "#{target.class}"

    return target.can_move?(direction) if target.is_a?(Crate)

    super(direction) || target.is_a?(Empty)
  end

  def move!(direction)
    target = entity_at(direction)

    if target.is_a?(Crate)
      puts "Moving Crate at #{target.x} - #{target.y}"
      target.move!(direction)
      target = entity_at(direction)
    end

    swap_with!(target)
  end

  def sprite
    "sprites/gameplay/5.png"
  end
end
