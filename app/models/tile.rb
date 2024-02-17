class Tile
  attr_gtk

  attr_accessor :x, :y

  def initialize(args, x, y)
    self.args = args

    @x = x
    @y = y

    @moving = false
  end

  def tick
  end

  def sprite
    raise "Override"
  end

  def can_move?(direction)
    puts "Can move? #{self.class} at [#{x},#{y}] -> #{direction} #{entity_at(direction).class} // #{caller}"

    false
  end

  def move!(direction)
    raise "Override"
  end

  def entity_at(direction)
    target_coordinates = case direction
    when :up then { y: @y + 1, x: @x }
    when :down then { y: @y - 1, x: @x }
    when :left then { y: @y, x: @x - 1 }
    when :right then { y: @y, x: @x + 1 }
    end

    state.level.entities.find { |e| e.x == target_coordinates.x && e.y == target_coordinates.y }
  end

  def swap_with!(other)
    other_x = other.x
    other_y = other.y

    other.x = @x
    other.y = @y

    @x = other_x
    @y = other_y
  end
end
