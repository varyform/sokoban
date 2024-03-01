module Scene
  class << self
    # what's displayed when your game starts
    def tick_main_menu(args)
      draw_bg(args, r: 30, g: 18, b: 39)
      options = [
        {
          key: :start,
          on_select: ->(args) {
            args.state.setting.level = 0
            Scene.switch(args, :gameplay, reset: true)
          }
        },
        {
          key: :settings,
          on_select: ->(args) { Scene.switch(args, :settings, reset: true, return_to: :main_menu) }
        },
      ]

      if args.state.highscores.keys.any?
        args.state.setting.level = args.state.highscores.keys.map(&:to_i).max.succ
        options.unshift({
          key: :continue,
          on_select: ->(args) { Scene.switch(args, :gameplay, reset: false) }
        })

        options.insert(2, {
          key: :select_level,
          on_select: ->(args) { Scene.switch(args, :select_level, reset: false, return_to: :main_menu) }
        })
      end

      if args.gtk.platform?(:desktop)
        options << {
          key: :quit,
          on_select: ->(args) { args.gtk.request_quit }
        }
      end

      Menu.tick(args, :main_menu, options)

      Shared.render_logo(args)
    end
  end
end
