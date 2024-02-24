class Crate < Tile
  def can_move?(direction)
    # return false unless super(direction)

    target = entity_at(direction)

    target.is_a?(Empty) || target.is_a?(Target)
  end

  def weight
    40
  end

  def frames
    12
  end

  def undo_move!(tick)
    last_move = @moves[tick]
    return unless last_move

    move!(opposite_direction(last_move))
  end

  def move!(direction)
    super

    # puts @moves

    if @undoing
      state.level.stats.pushes -= 1
    else
      state.level.stats.pushes += 1
    end

    play_sfx(args, "crate/moving", exclusive: true)

    @move_to = entity_at(direction).position
  end

  def to_sprite
    temp = super

    temp = temp.merge(a: state.tick_count % 30 < 15 ? 30 : 255) if state.level.finished?

    temp
  end

  def sprite
    if any_of_type_in_place?(Target)
      "sprites/gameplay/2.png"
    else
      "sprites/gameplay/1.png"
    end
  end
end
