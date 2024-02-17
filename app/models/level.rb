class Level
  attr_gtk
  attr_reader :entities

  def initialize(args, index)
    raise "Wrong level #{index}" if index < 0 or index > 49

    self.args = args
    @index    = index
    @map      = LEVELS[@index]

    @entities = setup
  end

  def title
    @index.succ
  end

  def tick
    render

    process_inputs

    @entities.map(&:tick)
  end

  def reset_level!
    @entities = setup
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
    # end
  end

  def render
    outputs.sprites << @entities.sort_by { |e| e.weight }.map(&:to_sprite)
  end

  private

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
end
