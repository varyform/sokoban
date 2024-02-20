class Tile
  SIZE = 36

  attr_gtk

  attr_accessor :x, :y, :moving

  def initialize(args, x, y)
    self.args = args

    @x = x
    @y = y

    @moving = false
    @move_direction = nil
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
    raise "Override"
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
    target_coordinates = case direction
    when :up then { y: @y + 1, x: @x }
    when :down then { y: @y - 1, x: @x }
    when :left then { y: @y, x: @x - 1 }
    when :right then { y: @y, x: @x + 1 }
    end

    state.level.entities.select { |e| e.x == target_coordinates.x && e.y == target_coordinates.y }
  end

  def any_of_type_in_place?(klass)
    state.level.entities.any? { |e| e.class == klass && e.x == x && e.y == y }
  end

  def place_on_top_of!(other)
    @move_direction = :right if other.x > @x
    @move_direction = :left if other.x < @x
    @move_direction = :down if other.y > @y
    @move_direction = :up if other.y < @y

    @x = other.x
    @y = other.y
  end
end
