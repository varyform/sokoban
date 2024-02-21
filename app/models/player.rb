class Player < Tile
  def can_move?(direction)
    return false if @moving
    return false if state.level.finished?

    target = entity_at(direction)

    # puts "#{target.class}"

    return target.can_move?(direction) if target.is_a?(Crate)

    super(direction) || target.is_a?(Empty) || target.is_a?(Target)
  end

  def set_default_facing!
    no_wall_direction = [:left, :right, :up, :down].find { |side| !entity_at(side).is_a?(Wall) }

    default_angle = direction_to_angle(no_wall_direction)

    @move_direction = no_wall_direction
    @angle          = default_angle
    @previous_angle = default_angle
  end

  def weight
    50
  end

  def frames
    12
  end

  def move!(direction)
    @previous_angle = direction_to_angle(@move_direction)

    super

    @angle        = direction_to_angle(@move_direction)
    @action_frame = state.tick_count

    state.level.stats.moves += 1

    play_step

    target = entity_at(direction)
    target.move!(direction) if target.is_a?(Crate)

    # place_on_top_of!(target)
    @move_to = target.position
  end

  def play_step
    play_sfx(args, "steps/#{random(1, 8)}", exclusive: true)
  end

  def sprite
    "sprites/gameplay/5.png"
  end

  def to_sprite
    source_x = if @moving
      SIZE * Numeric.frame_index(start_at: 0, frame_count: 4, hold_for: 3, repeat: true)
    else
      0
    end

    rotation_increment = case @previous_angle.to_i - @angle.to_i
    when -90, 270 then 15
    when 90, -270 then -15
    else 30 # 180
    end

    angle = if @angle == @previous_angle
      @previous_angle
    else
      frame = @action_frame.frame_index(start_at: 0, frame_count: 6, hold_for: 2, repeat: false)
      frame ? @previous_angle + (rotation_increment * frame) : @angle
    end

    super.merge!(angle: angle, source_x: source_x)
  end
end
