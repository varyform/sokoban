module Scene
  class << self
    # scene reached from gameplay when the player needs a break
    def tick_select_level(args)
      draw_bg(args, r: 30, g: 18, b: 39)

      if secondary_down?(args.inputs)
        play_sfx(args, :select)

        Scene.switch(args, :back)
      end

      render(args)
    end

    def render(args)
      # args.state.levels.map(&:render)
      sprite = {
        x: 10,
        y: 10,
        w: 2532 / 2,
        h: 1216 / 2,
        path: 'sprites/levels.png'
      }
      args.outputs.sprites << sprite
    end
  end
end
