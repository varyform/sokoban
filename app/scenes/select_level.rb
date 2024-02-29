module Scene
  class << self
    def tick_select_level(args)
      draw_bg(args, r: 30, g: 18, b: 39)

      if secondary_down?(args.inputs)
        play_sfx(args, :select)

        Scene.switch(args, :back)
      end

      if primary_down?(args.inputs)
        play_sfx(args, :select)

        Scene.switch(args, :gameplay, reset: true)
      end

      args.state.level ||= Level.new(args, 0)

      if left?(args) && args.state.level.index.positive? && !@switching
        @switching = 20
        args.state.level.index -= 1
        args.state.level.reset!
      elsif right?(args) && args.state.level.index <= args.state.highscores.keys.max.to_i && !@switching
        @switching = 20
        args.state.level.index += 1
        args.state.level.reset!
      end

      if @switching
        @switching -= 1
        @switching = nil if @switching.zero?
      end

      args.state.level.render
      args.outputs.labels << label("LEVEL #{args.state.level.title}", x: args.grid.w / 2, y: args.grid.h / 2, align: ALIGN_CENTER)

      Shared.render_logo(args)
    end
  end
end
