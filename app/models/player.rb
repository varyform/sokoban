class Player < Tile
  def can_move?(direction)
    return false if @moving
    return false if state.level.finished?

    target = entity_at(direction)

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

  def can_undo?
    @moves.any?
  end

  def process_inputs
    move!(:up) if up?(args) && can_move?(:up)
    move!(:down) if down?(args) && can_move?(:down)
    move!(:left) if left?(args) && can_move?(:left)
    move!(:right) if right?(args) && can_move?(:right)

    undo_move! if @moves.any? && !@moving && !@undoing && (inputs.keyboard.key_up.z || inputs.keyboard.key_held.z ||
                  (inputs.controller_one.connected && (inputs.controller_one.key_down.y || inputs.controller_one.key_held.y)))
  end

  def undo_move!
    @undoing, last_move = *@moves.to_a.last

    return unless last_move

    move!(opposite_direction(last_move))

    state.level.entities.select { |e| e.is_a?(Crate) }.each { |e| e.undo_move!(@undoing) }
  end

  def move!(direction)
    @bored_since = nil
    @previous_angle = direction_to_angle(@move_direction)

    super

    @angle          = direction_to_angle(@move_direction)
    @previous_angle = @angle if @undoing

    @action_frame = state.tick_count

    if @undoing
      state.level.stats.moves -= 1
    else
      state.level.stats.moves += 1
    end

    play_step

    target = entity_at(direction)
    if target.is_a?(Crate)
      @pushing = true
      target.move!(direction)
    end

    # place_on_top_of!(target)
    @move_to = target.position
    @last_move_was_undo = false
  end

  def play_step
    play_sfx(args, "steps/#{random(1, 8)}", exclusive: true)
  end

  def sprite
    "sprites/gameplay/5.png"
  end

  def tick
    super

    @bored_since ||= state.tick_count
  end

  def to_sprite
    source_x = if @moving
      SOURCE_SIZE * @moving_frame.frame_index(count: 4, hold_for: 3, repeat: true)
    else
      0
    end

    rotation_increment = case @previous_angle.to_i - @angle.to_i
    when -90, 270 then 15
    when 90, -270 then -15
    else 30 # 180
    end

    rotation_increment = -rotation_increment if @undoing

    angle = if @angle == @previous_angle
      @previous_angle
    else
      frame = @action_frame.frame_index(start_at: 0, frame_count: 6, hold_for: 1, repeat: false)
      frame ? @previous_angle + (rotation_increment * frame) : @angle
    end

    source_x += SOURCE_SIZE * 4 if @pushing
    source_x = SOURCE_SIZE * (8 + @bored_since.frame_index(count: 4, hold_for: 16, repeat: true)) if @bored_since && state.tick_count > @bored_since + 1200

    super.merge(angle: angle, source_x: source_x, flip_vertically: @undoing || @last_move_was_undo)
  end
end
