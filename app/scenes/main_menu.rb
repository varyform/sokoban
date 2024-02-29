module Scene
  class << self
    # what's displayed when your game starts
    def tick_main_menu(args)
      draw_bg(args, r: 30, g: 18, b: 39)
      options = [
        {
          key: :start,
          on_select: -> (args) {
            args.state.setting.level = 0
            Scene.switch(args, :gameplay, reset: true)
          }
        },
        {
          key: :settings,
          on_select: -> (args) { Scene.switch(args, :settings, reset: true, return_to: :main_menu) }
        },
      ]

      if args.state.highscores.keys.any?
        args.state.setting.level = args.state.highscores.keys.max.to_i + 1
        options.unshift({
          key: :continue,
          on_select: -> (args) { Scene.switch(args, :gameplay, reset: false) }
        })
      end

      if args.gtk.platform?(:desktop)
        options << {
          key: :quit,
          on_select: -> (args) { args.gtk.request_quit }
        }
      end

      Menu.tick(args, :main_menu, options)

      labels = []
      # labels << label(
      #   "v#{version}",
      #   x: args.grid.right - 24, y: 48,
      #   size: SIZE_XS, align: ALIGN_RIGHT, color: DARK_PURPLE)
      # labels << label(
      #   title.upcase, x: args.grid.w / 2, y: args.grid.top - 100,
      #   size: SIZE_LG, align: ALIGN_CENTER, font: FONT_BOLD)
      labels << label(
        "#{text(:made_by)} #{dev_title}",
        x: args.grid.w / 2, y: 48,
        size: SIZE_XS, align: ALIGN_CENTER, color: { r: 200, g: 200, b: 200 })
      # labels << label(
      #   args.inputs.controller_one.connected ? :controls_gamepad : :controls_keyboard,
      #   x: args.grid.right - 24, y: 48,
      #   size: SIZE_XS, align: ALIGN_RIGHT)

      labels << label(
        "v#{version}",
        x: args.grid.w / 2 + 220, y: 200.from_top,
        size: SIZE_XS, align: ALIGN_LEFT, color: { r: 130, g: 250, b: 250 })

      args.outputs.labels << labels
      args.outputs.sprites << { x: args.grid.w / 2 - 217, y: 220.from_top, w: 434, h: 82, path: 'sprites/logo.png' }
    end
  end
end
