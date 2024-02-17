module Scene
  class << self
    # This is your main entrypoint into the actual fun part of your game!
    def tick_gameplay(args)
      labels = []
      sprites = []

      args.state.level ||= ::Level.new(args, 0)

      # args.state.current_level ||= 0

      # lvl = LEVELS[args.state.current_level]

      # only check inputs every so often seconds
      # if args.state.tick_count % 10 == 9
      #   args.state.current_level -= 1 if up?(args) && args.state.current_level > 0
      #   args.state.current_level += 1 if down?(args) && args.state.current_level < LEVELS.size - 1
      # end

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

      labels << label("Sokoban", x: 40, y: args.grid.top - 40, size: SIZE_LG, font: FONT_BOLD)
      labels << label("Level #{args.state.level.title}", x: args.grid.w - 40, y: args.grid.top - 40, size: SIZE_LG, font: FONT_BOLD, align: ALIGN_RIGHT)
      args.outputs.labels << labels
      # args.outputs.sprites << level.sprites
    end

    def pause(args)
      play_sfx(args, :select)
      return Scene.switch(args, :paused, reset: true)
    end

    def tick_pause_button(args, sprites)
      pause_button = {
        x: 72.from_right,
        y: 72.from_top,
        w: 52,
        h: 52,
        path: Sprite.for(:pause),
      }
      pause_rect = pause_button.dup
      pause_padding = 12
      pause_rect.x -= pause_padding
      pause_rect.y -= pause_padding
      pause_rect.w += pause_padding * 2
      pause_rect.h += pause_padding * 2
      if args.inputs.mouse.down && args.inputs.mouse.inside_rect?(pause_rect)
        return pause(args)
      end
      sprites << pause_button
    end
  end
end
