class Tile
  attr_gtk

  attr_reader :x, :y

  def initialize(args, x, y)
    self.args = args

    @x = x
    @y = y
  end

  def tick
  end

  def sprite
    "sprites/gameplay/3.png"
  end

  def static?
    true
  end

  def can_move?(direction)
    return false if static?
  end
end
