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
      elsif right?(args) && args.state.level.index <= args.state.highscores.keys.map(&:to_i).max && !@switching
        @switching = 20
        args.state.level.index += 1
        args.state.level.reset!
      end

      if @switching
        @switching -= 1
        @switching = nil if @switching.zero?
      end

      args.state.level.render

      Shared.render_logo(args)

      show_notice(args, "LEVEL #{args.state.level.title}")
    end
  end
end
