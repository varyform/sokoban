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
    # super

    @moving = frames
    move = []

    state.level.stats.moves += 1

    play_step

    target = entity_at(direction)
    if target.is_a?(Crate)
      move << [target, opposite_direction(direction)]

      target.move!(direction)
    end

    move << [self, opposite_direction(direction)]

    # move to new empty block
    target = entity_at(direction)
    place_on_top_of!(target)

    @moves << move

    move.each do |x, direction|
      puts "#{x.class} moved from #{x.x}, #{x.y} -> #{opposite_direction(direction)}"
    end
  end

  def undo_last_move!
    return if @moving || @moves.none?

    state.level.stats.moves -= 1

    lm = @moves.pop

    lm.each do |e, direction|
      puts "#{e.class} returned to #{e.x}, #{e.y} <- #{direction}"

      state.level.stats.pushes -= 1 if e.is_a?(Crate)
      e.moving = e.frames
      target = self #entity_at(direction)
      puts "#{e.class} [#{e.x}, #{e.y}] will be placed on top of #{target.class} [#{target.x}, #{target.y}]"
      e.place_on_top_of!(target)
    end

    puts "*"
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
