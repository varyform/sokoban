class Tile
  SIZE = 36
  SOURCE_SIZE = 36

  def size
    @@size
  end

  attr_gtk

  attr_accessor :x, :y, :moving

  def initialize(args, x, y)
    self.args = args

    @x = x
    @y = y

    @moving         = false
    @move_direction = nil
    @moves          = {}
  end

  def tick
    @moving -= 1 if @moving

    return unless @moving && @moving <= 0

    @x, @y = *@move_to
    @moves[state.tick_count] = @move_direction unless @undoing

    @moving  = false
    @pushing = false

    if @undoing && !@moving
      @moves.delete(@undoing)
      @last_move_was_undo = true
      state.level.stats.time = Time.now if @moves.empty?

      @undoing = false
    end

    @move_to = nil
  end

  def weight
    0
  end

  def frames
    SIZE # move instantly
  end

  def sprite
    raise "Override"
  end

  def can_move?(_direction)
    # puts "Can move? #{self.class} at [#{x},#{y}] -> #{direction} #{entity_at(direction).class} // #{caller}"

    return false if @moving

    false
  end

  def move!(direction)
    @moving         = frames
    @moving_frame   = state.tick_count
    @move_direction = direction
  end

  def to_sprite
    offset = if @moving
      case @move_direction
      when :left then { x: @moving, y: 0 }
      when :right then { x: -@moving, y: 0 }
      when :up then { x: 0, y: -@moving }
      when :down then { x: 0, y: @moving }
      end
    else
      { x: 0, y: 0 }
    end

    {
      x: ((@move_to&.first || x) * SIZE) + (SIZE / frames * offset.x) + ((grid.w - (state.level.width * SIZE)) / 2),
      y: ((@move_to&.second || y) * SIZE) + (SIZE / frames * offset.y) + ((grid.h - (state.level.height * SIZE)) / 2),
      w: SIZE,
      h: SIZE,
      source_w: SOURCE_SIZE,
      source_h: SOURCE_SIZE,
      source_x: 0,
      source_y: 0,
      path: sprite
    }
  end

  def entity_at(direction)
    entities_at(direction).max_by(&:weight)
  end

  def entities_at(direction)
    target_coordinates = direction_to_position(direction)

    state.level.entities.select { |e| e.position == target_coordinates }
  end

  def any_of_type_in_place?(klass)
    state.level.entities.any? { |e| e.instance_of?(klass) && e.position == position }
  end

  def place_on_top_of!(other)
    @move_to = [other.x, other.y]
  end

  def direction_to_angle(direction)
    { right: 90, left: 270, down: 0, up: 180 }[direction]
  end

  def opposite_direction(direction)
    { left: :right, down: :up, up: :down, right: :left }[direction]
  end

  def direction_to_position(direction)
    {
      up:    [x, y + 1],
      down:  [x, y - 1],
      left:  [x - 1, y],
      right: [x + 1, y]
    }[direction]
  end

  def position
    [x, y]
  end
end
