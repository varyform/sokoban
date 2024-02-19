module Scene
  class << self
    # scene reached from gameplay when the player needs a break
    def tick_paused(args)
      draw_bg(args, r: 30, g: 18, b: 39)

      options = [
        {
          key: :resume,
          on_select: -> (args) { Scene.switch(args, :gameplay) }
        },
        {
          key: :settings,
          on_select: -> (args) { Scene.switch(args, :settings, reset: true, return_to: :paused) }
        },
        {
          key: :return_to_main_menu,
          on_select: -> (args) { Scene.switch(args, :main_menu) }
        },
      ]

      if args.gtk.platform?(:desktop)
        options << {
          key: :quit,
          on_select: -> (args) { args.gtk.request_quit }
        }
      end

      Menu.tick(args, :paused, options)

      if secondary_down?(args.inputs)
        play_sfx(args, :select)
        options.find { |o| o[:key] == :resume }[:on_select].call(args)
      end

      # args.outputs.labels << label(:paused, x: args.grid.w / 2, y: args.grid.top - 200, align: ALIGN_CENTER, size: SIZE_LG, font: FONT_BOLD)
      args.outputs.sprites << { x: args.grid.w / 2 - 217, y: 220.from_top, w: 434, h: 82, path: 'sprites/logo.png' }
    end
  end
end
