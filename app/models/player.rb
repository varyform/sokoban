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
    super

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
    source_x = if @moving
      SIZE * Numeric.frame_index(start_at: 0, frame_count: 4, hold_for: 8, repeat: true)
    else
      0
    end

    rotation_increment = case @previous_angle.to_i - @angle.to_i
    when -90, 270 then 15
    when 90, -270 then -15
    else 30 # 180
    end

    angle = if @angle != @previous_angle
      frame = @action_frame.frame_index(start_at: 0, frame_count: 6, hold_for: 2, repeat: false)
      frame ? @previous_angle + rotation_increment * frame : @angle
    else
      @previous_angle
    end

    super.merge!(angle: angle, source_x: source_x)
  end
end
