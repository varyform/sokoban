class Level
  attr_gtk
  attr_reader :index

  def initialize(args, index)
    raise "Wrong level #{index}" if index < 0 or index > 49

    self.args = args
    @index    = index
    @map      = LEVELS[@index]

    @entities = setup
  end

  def tick
    render
  end

  def render
    height = @map.size
    width  = @map[0].size

    sprites = @entities.map do |e|
      {
        x: e.x * 36 + (grid.w - (width * 36)) / 2,
        y: e.y * 36 + (grid.h - (height * 36)) / 2,
        w: 36,
        h: 36,
        path: e.sprite,
      }
    end

    outputs.sprites << sprites
  end

  private

  def setup
    @map.reverse.map_2d do |y, x, cell|
      case cell
      when 1 then Crate.new(args, x, y)
      when 2 then
        [
          Target.new(args, x, y),
          Crate.new(args, x, y)
        ]
      when 3 then Tile.new(args, x, y)
      when 4 then Target.new(args, x, y)
      when 5 then Player.new(args, x, y)
      when 7 then Wall.new(args, x, y)
      end
    end.compact.flat_map
  end
end
