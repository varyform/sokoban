class Player < Tile
  def can_move?(direction)
    return false if @moving

    target = entity_at(direction)

    puts "#{target.class}"

    return target.can_move?(direction) if target.is_a?(Crate)

    super(direction) || target.is_a?(Empty) || target.is_a?(Target)
  end

  def move!(direction)
    @moving = 12

    play_step

    target = entity_at(direction)
    target.move!(direction) if target.is_a?(Crate)

    # move to new empty block
    target = entity_at(direction)
    place_on_top_of!(target)
  end

  def play_step
    step = random(1, 8)
    play_sfx(args, "steps/#{step}")
  end

  def sprite
    "sprites/gameplay/5.png"
  end
end
