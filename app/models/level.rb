class Level
  attr_gtk
  attr_reader :entities, :stats, :completed_at, :index

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
    ::Fireworks.launch(@fireworks, args) if finished? && args.state.tick_count.mod_zero?(3)

    process_inputs

    update

    render

    ::Fireworks.tick(@fireworks, args) if finished?

    @entities.map(&:tick)
  end

  def update
    return unless finished?
    return unless (@completion_timer -= 1) <= 0

    @index += 1 if @index < LEVELS.size - 1
    state.setting.level = @index

    GameSetting.save_settings(args)

    reset_level!
  end

  def finished?
    return true if @completed_at

    all_done = @level_cache[:crates].map(&:position).sort == @level_cache[:targets]

    if all_done
      play_sfx(args, "won")
      @completed_at = Time.now

      if state.highscores[index.to_s]
        state.highscores[index.to_s]["moves"]  = [stats.moves, state.highscores[index.to_s]["moves"]].min
        state.highscores[index.to_s]["pushes"] = [stats.pushes, state.highscores[index.to_s]["pushes"]].min
        state.highscores[index.to_s]["time"] = [@completed_at - stats.time, state.highscores[index.to_s]["time"].to_f].min
      else
        state.highscores[index.to_s] = { "moves" => stats.moves, "pushes" => stats.pushes, "time" => ((completed_at || Time.now) - stats.time) }
      end

      gtk.write_file("highscores.json", highscores_to_json(state.highscores))
    end

    all_done
  end

  def reset_level!
    @level_cache = {}

    @map                  = LEVELS[@index]
    @entities             = setup
    @stats                = default_stats
    @completed_at         = nil
    @completion_timer     = 180 # frames

    @fireworks = state.fireworks = ::Fireworks.create

    @player = nil

    player.set_default_facing!
  end

  def player
    @player ||= @entities.find { |e| e.is_a?(Player) }
  end

  def process_inputs
    player.process_inputs

    if inputs.keyboard.key_down.q || inputs.keyboard.key_held.q ||
       (inputs.controller_one.connected && inputs.controller_one.key_down.l1)
      gtk.notify_extended! message: 'Level has been reset!', duration: 90, env: :prod
      reset_level!
    end
  end

  def render
    outputs.sprites << @entities.map(&:to_sprite)
    outputs.labels << label("YOU WON!", x: grid.w / 2, y: grid.h / 2 + 20, align: ALIGN_CENTER) if finished?

    render_highscore
  end

  private

  def render_highscore
    score = state.highscores[index.to_s]
    return unless score

    outputs.labels << label("HIGHSCORE", x: 40, y: 190.from_bottom, size: 0, color: { r: 80, g: 80, b: 80 })

    default_color = { r: 120, g: 120, b: 120 }

    outputs.labels << label("Moves:", x: 40, y: 160.from_bottom, size: 0, color: default_color)
    outputs.labels << label("Pushes:", x: 40, y: 130.from_bottom, size: 0, color: default_color)
    outputs.labels << label("Time:", x: 40, y: 100.from_bottom, size: 0, color: default_color)

    color = stats.moves > score["moves"] ? { r: 170, g: 30, b: 30 } : default_color
    outputs.labels << label(score['moves'], x: 140, y: 160.from_bottom, size: 0, color: color)

    color = stats.pushes > score["pushes"] ? { r: 170, g: 30, b: 30 } : default_color
    outputs.labels << label(score['pushes'], x: 140, y: 130.from_bottom, size: 0, color: color)

    color = ((@completed_at || Time.now) - stats.time) > score["time"].to_f ? { r: 170, g: 30, b: 30 } : default_color
    outputs.labels << label(formatted_duration(score['time'].to_f), x: 140, y: 100.from_bottom, size: 0, color: color)
  end

  def height
    @map.size
  end

  def width
    @map[0].size
  end

  def setup
    @map.map_2d do |y, x, cell|
      case cell
      when 1
        [
          Empty.new(args, x, y),
          Crate.new(args, x, y)
        ]
      when 2
        [
          Target.new(args, x, y),
          Crate.new(args, x, y)
        ]
      when 3 then Empty.new(args, x, y)
      when 4 then Target.new(args, x, y)
      when 5 # still should be able to move back to starting position
        [
          Empty.new(args, x, y),
          Player.new(args, x, y)
        ]
      when 7 then Wall.new(args, x, y)
      end
    end.compact.flatten.sort_by(&:weight).tap do |map|
      @level_cache[:crates]  = map.select { |e| e.is_a?(Crate) }
      @level_cache[:targets] = map.select { |e| e.is_a?(Target) }.map(&:position).sort
    end
  end

  def default_stats
    { moves: 0, pushes: 0, time: Time.now }
  end

  def highscores_to_json(hash)
    output = "{\n"
    pairs = []
    hash.each_pair do |k, v|
      pairs << %(  "#{k}": { "moves": #{v['moves']}, "pushes": #{v['pushes']}, "time": #{v['time']} })
    end
    output << pairs.join(",\n")
    output << "\n}"
  end
end
