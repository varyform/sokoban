class Player < Tile
  def can_move?(direction)
    return false if @moving

    target = entity_at(direction)

    # puts "#{target.class}"

    return target.can_move?(direction) if target.is_a?(Crate)

    super(direction) || target.is_a?(Empty) || target.is_a?(Target)
  end

  def weight
    50
  end

  def frames
    12
  end

  def move!(direction)
    @moving = frames

    state.level.stats.moves += 1

    play_step

    target = entity_at(direction)
    target.move!(direction) if target.is_a?(Crate)

    # move to new empty block
    target = entity_at(direction)
    place_on_top_of!(target)
  end

  def play_step
    # make sure sound is deleted so it can play for every step
    if state.setting.sfx
      step = random(1, 8)
      audio.delete :step
      audio[:step] = { input: "sounds/steps/#{step}.wav" }
    end
    # play_sfx(args, "steps/#{step}")
  end

  def sprite
    "sprites/gameplay/5.png"
  end

  def to_sprite
    angle = case @move_direction
    when :right then 90
    when :left then 270
    when :down then 180
    when :up then 0
    end

    source_x = if @moving
      SIZE * Numeric.frame_index(start_at: 0, frame_count: 4, hold_for: 12, repeat: true)
    else
      0
    end

    super.merge!(angle: angle, source_x: source_x)
  end
end
