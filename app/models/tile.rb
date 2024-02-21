class Tile
  SIZE = 36

  attr_gtk

  attr_accessor :x, :y, :moving

  def initialize(args, x, y)
    self.args = args

    @x = x
    @y = y

    @moving         = false
    @move_direction = nil
    @moves          = []
  end

  def tick
    @moving -= 1 if @moving

    @moving = false if @moving && @moving <= 0
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

  def can_move?(direction)
    # puts "Can move? #{self.class} at [#{x},#{y}] -> #{direction} #{entity_at(direction).class} // #{caller}"

    return false if @moving

    false
  end

  def move!(direction)
    @moves << [[@x, @y], target_coordinates(direction).values]
  end

  def undo_last_move!
    last_move = @moves.pop

    return unless last_move

    @x, @y = last_move.first
  end

  def moves?
    @moves.any?
  end

  def to_sprite
    offset = if @moving
      case @move_direction
      when :left then { x: @moving, y: 0 }
      when :right then { x: -@moving, y: 0 }
      when :down then { x: 0, y: -@moving }
      when :up then { x: 0, y: @moving }
      end
    else
      { x: 0, y: 0 }
    end

    {
      x: x * SIZE + SIZE / frames * offset.x + (grid.w - (state.level.width * SIZE)) / 2,
      y: y * SIZE + SIZE / frames * offset.y + (grid.h - (state.level.height * SIZE)) / 2,
      w: SIZE,
      h: SIZE,
      source_w: SIZE,
      source_h: SIZE,
      source_x: 0,
      source_y: 0,
      path: sprite
    }
  end

  def entity_at(direction)
    entities_at(direction).sort_by { |e| -e.weight }.first
  end

  def entities_at(direction)
    coords = target_coordinates(direction)

    state.level.entities.select { |e| e.x == coords.x && e.y == coords.y }
  end

  def target_coordinates(direction)
    case direction
    when :up then { y: @y + 1, x: @x }
    when :down then { y: @y - 1, x: @x }
    when :left then { y: @y, x: @x - 1 }
    when :right then { y: @y, x: @x + 1 }
    end
  end

  def any_of_type_in_place?(klass)
    state.level.entities.any? { |e| e.class == klass && e.x == x && e.y == y }
  end

  def place_on_top_of!(other)
    @previous_angle = direction_to_angle(@move_direction)

    @move_direction = :right if other.x > @x
    @move_direction = :left if other.x < @x
    @move_direction = :down if other.y > @y
    @move_direction = :up if other.y < @y

    @angle = direction_to_angle(@move_direction)

    @action_frame = state.tick_count

    @x = other.x
    @y = other.y
  end

  def direction_to_angle(direction)
    case direction
    when :right then 90
    when :left then 270
    when :down then 180
    when :up then 0
    else 0 # avoid crash
    end
  end
end
