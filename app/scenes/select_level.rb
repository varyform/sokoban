module Scene
  class << self
    # scene reached from gameplay when the player needs a break
    def tick_select_level(args)
      draw_bg(args, r: 30, g: 18, b: 39)


      # Menu.tick(args, :paused, options)

      # if secondary_down?(args.inputs)
      #   play_sfx(args, :select)
      #   options.find { |o| o[:key] == :resume }[:on_select].call(args)
      # end

      if secondary_down?(args.inputs)
        play_sfx(args, :select)
        # options.find { |o| o[:key] == :back }[:on_select].call(args)
        Scene.switch(args, :back)
      end

      render(args)

      # args.outputs.labels << label(:paused, x: args.grid.w / 2, y: args.grid.top - 200, align: ALIGN_CENTER, size: SIZE_LG, font: FONT_BOLD)
      args.outputs.sprites << { x: args.grid.w / 2 - 217, y: 220.from_top, w: 434, h: 82, path: 'sprites/logo.png' }
    end

    def render(args)
      l = Level.new(args, 4, preview: true)

      l.render
    end
  end
end
