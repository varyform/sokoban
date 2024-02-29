module Scene
  class << self
    def tick_select_level(args)
      draw_bg(args, r: 30, g: 18, b: 39)

      if secondary_down?(args.inputs)
        play_sfx(args, :select)

        Scene.switch(args, :back)
      end

      render_select_level(args)
      Shared.render_logo(args)
    end

    def render_select_level(args)
      # sprite = {
      #   x: (args.grid.w - (2532 / 4)) / 2,
      #   y: ((args.grid.h - (1216 / 4)) / 2) - 50,
      #   w: 2532 / 4,
      #   h: 1216 / 4,
      #   path: 'sprites/levels.png'
      # }

      # args.outputs.sprites << sprite
    end
  end
end
