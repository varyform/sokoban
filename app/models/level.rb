class Level
  attr_gtk
  attr_reader :entities, :stats, :completed_at

  def initialize(args, index)
    index = LEVELS.size - 1 if index > LEVELS.size - 1

    self.args = args
    @index    = index

    state.level ||= self

    reset_level!
  end

  def title
    @index.succ
  end

  def tick
    render

    process_inputs

    @entities.map(&:tick)

    if finished?
      @completion_timer -= 1

      if @completion_timer <= 0
        @index += 1 if @index < LEVELS.size - 1
        state.setting.level = @index

        GameSetting.save_settings(args)

        reset_level!
      end
    end
  end

  def finished?
    return true if @completed_at

    all_done = @entities.select { |e| e.is_a?(Crate) }.all? { |crate| crate.any_of_type_in_place?(Target) }

    if all_done
      play_sfx(args, "won")
      @completed_at = Time.now
    end

    all_done
  end

  def reset_level!
    @map                  = LEVELS[@index]
    @entities             = setup
    @stats                = default_stats
    @completed_at         = nil
    @completion_timer     = 180 # frames

    set_default_facing!
  end

  def any_moves?
    @entities.any?(&:moves?)
  end

  def process_inputs
    # only check inputs every so often seconds
    # if state.tick_count % 10 == 9
      player = @entities.find { |e| e.is_a?(Player) }

      player.move!(:up) if up?(args) && player.can_move?(:up)
      player.move!(:down) if down?(args) && player.can_move?(:down)
      player.move!(:left) if left?(args) && player.can_move?(:left)
      player.move!(:right) if right?(args) && player.can_move?(:right)

      reset_level! if inputs.keyboard.key_down.q or inputs.keyboard.key_held.q
      undo_last_move! if inputs.keyboard.key_down.z or inputs.keyboard.key_held.z
    # end
  end

  def render
    outputs.sprites << @entities.sort_by(&:weight).map(&:to_sprite)
  end

  def undo_last_move!
    @entities.map(&:undo_last_move!)
  end

  private

  def set_default_facing!
    player = @entities.find { |e| e.is_a?(Player) }

    no_wall_direction = [:left, :right, :up, :down].find { |side| !player.entity_at(side).is_a?(Wall) }

    if no_wall_direction == :up
      no_wall_direction = :down
    elsif no_wall_direction == :down
      no_wall_direction = :up
    end

    default_angle = player.direction_to_angle(no_wall_direction)

    player.instance_variable_set(:@angle, default_angle)
    player.instance_variable_set(:@previous_angle, default_angle)
  end

  def height
    @map.size
  end

  def width
    @map[0].size
  end

  def setup
    @map.reverse.map_2d do |y, x, cell|
      case cell
      when 1 then
        [
          Empty.new(args, x, y),
          Crate.new(args, x, y)
        ]
      when 2 then
        [
          Target.new(args, x, y),
          Crate.new(args, x, y)
        ]
      when 3 then Empty.new(args, x, y)
      when 4 then Target.new(args, x, y)
      when 5 then # still should be able to move back to starting position
        [
          Empty.new(args, x, y),
          Player.new(args, x, y)
        ]
      when 7 then Wall.new(args, x, y)
      end
    end.compact.flatten
  end

  def default_stats
    { moves: 0, pushes: 0, time: Time.now }
  end
end
