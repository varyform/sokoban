module Shared
  class << self
    def render_logo(args, top: 180)
      args.outputs.labels << label(
        "v#{version}",
        x: (args.grid.w / 2) + 220, y: (top - 20).from_top,
        size: SIZE_XS, align: ALIGN_LEFT, color: { r: 130, g: 250, b: 250 }
      )

      args.outputs.labels << label(
        "#{text(:made_by)} #{dev_title}",
        x: args.grid.w / 2, y: 48,
        size: SIZE_XS, align: ALIGN_CENTER, color: { r: 200, g: 200, b: 200 }
      )

      args.outputs.sprites << { x: (args.grid.w / 2) - 217, y: top.from_top, w: 434, h: 82, path: 'sprites/logo.png' }
    end
  end
end
