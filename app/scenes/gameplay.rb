module Scene
  class << self
    # This is your main entrypoint into the actual fun part of your game!
    def tick_gameplay(args)
      labels = []
      sprites = []

      args.state.setting.level ||= args.state.highscores.keys.map(&:to_i).max.succ
      args.state.level ||= Level.new(args, args.state.setting.level)

      args.state.level.tick

      # focus tracking
      if !args.state.has_focus && args.inputs.keyboard.has_focus
        args.state.has_focus = true
      elsif args.state.has_focus && !args.inputs.keyboard.has_focus
        args.state.has_focus = false
      end

      # auto-pause & input-based pause
      if !args.state.has_focus || pause_down?(args)
        return pause(args)
      end

      tick_pause_button(args, sprites) if mobile?

      draw_bg(args, BLACK)
      args.outputs.solids << { x: args.grid.left, y: args.grid.bottom, w: args.grid.w, h: 40, r: 200, g: 200, b: 200 }
      args.outputs.solids << { x: 91, y: args.grid.bottom, w: 3, h: 40 }.merge(BLACK)
      args.outputs.solids << { x: 308, y: args.grid.bottom, w: 3, h: 40 }.merge(BLACK)

      # labels << label(title, x: 40, y: args.grid.top - 40, size: SIZE_LG, font: FONT_BOLD)
      # labels << label("Level #{args.state.level.title}", x: args.grid.w - 40, y: args.grid.top - 40, size: SIZE_LG, font: FONT_BOLD, align: ALIGN_RIGHT)

      stats = "%<level>02d   MOVES: %<moves>04d   PUSHES: %<pushes>04d" % { level: args.state.level.title, moves: args.state.level.stats.moves, pushes: args.state.level.stats.pushes }
      time  = formatted_duration((args.state.level.completed_at || Time.now) - args.state.level.stats.time)

      labels << label(stats, x: 40, y: args.grid.bottom + 35, size: SIZE_MD, color: BLACK)
      labels << label("TIME: #{time}", x: args.grid.right - 40, y: args.grid.bottom + 35, size: SIZE_MD, color: BLACK, align: ALIGN_RIGHT)

      if args.state.level.player.can_undo?
        labels << label("#{key_or_button(args, "Q", "L1/LB")} - restart level",
                        x: args.grid.right - 40, y: 50.from_top,
                        size: SIZE_XS, align: ALIGN_RIGHT, color: { r: 60, g: 60, b: 60 })

        labels << label("#{key_or_button(args, "Z", "Y/▲")} - undo last move",
                        x: args.grid.right - 40, y: 80.from_top,
                        size: SIZE_XS, align: ALIGN_RIGHT, color: { r: 60, g: 60, b: 60 })
      end

      args.outputs.labels << labels
      args.outputs.sprites << { x: 40.from_left, y: 81.from_top, w: 217, h: 41, path: 'sprites/logo.png' }
    end

    def pause(args)
      play_sfx(args, :select)

      Scene.switch(args, :paused, reset: true)
    end

    def tick_pause_button(args, sprites)
      pause_button = {
        x: 72.from_right,
        y: 72.from_top,
        w: 52,
        h: 52,
        path: Sprite.for(:pause)
      }

      pause_rect = pause_button.dup
      pause_padding = 12
      pause_rect.x -= pause_padding
      pause_rect.y -= pause_padding
      pause_rect.w += pause_padding * 2
      pause_rect.h += pause_padding * 2

      return pause(args) if args.inputs.mouse.down && args.inputs.mouse.inside_rect?(pause_rect)

      sprites << pause_button
    end
  end
end
