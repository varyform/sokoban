class Level
  attr_gtk
  attr_reader :index, :entities

  def initialize(args, index)
    raise "Wrong level #{index}" if index < 0 or index > 49

    self.args = args
    @index    = index
    @map      = LEVELS[@index]

    @entities = setup
  end

  def tick
    render

    inputs
  end

  def inputs
    # only check inputs every so often seconds
    if state.tick_count % 10 == 9
      player = @entities.find { |e| e.is_a?(Player) }

      player.move!(:up) if up?(args) && player.can_move?(:up)
      player.move!(:down) if down?(args) && player.can_move?(:down)
      player.move!(:left) if left?(args) && player.can_move?(:left)
      player.move!(:right) if right?(args) && player.can_move?(:right)
    end
  end

  def render
    height = @map.size
    width  = @map[0].size

    sprites = @entities.map do |e|
      next unless e

      {
        x: e.x * 36 + (grid.w - (width * 36)) / 2,
        y: e.y * 36 + (grid.h - (height * 36)) / 2,
        w: 36,
        h: 36,
        path: e.sprite,
      }
    end.compact

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
      when 3 then Empty.new(args, x, y)
      when 4 then Target.new(args, x, y)
      when 5 then Player.new(args, x, y)
      when 7 then Wall.new(args, x, y)
      end
    end.compact.flat_map
  end
end
