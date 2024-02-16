module Sprite
  # annoying to track but useful for reloading with +i+ in debug mode; would be
  # nice to define a different way
  SPRITES = {
    none:           'sprites/gameplay/0.png',
    crate:          'sprites/gameplay/1.png',
    crate_in_place: 'sprites/gameplay/2.png',
    empty:          'sprites/gameplay/3.png',
    placeholder:    'sprites/gameplay/4.png',
    player:         'sprites/gameplay/5.png',
    wall:           'sprites/gameplay/7.png'
  }

  class << self
    def reset_all(args)
      SPRITES.each { |_, v| args.gtk.reset_sprite(v) }
    end

    def for(key)
      SPRITES.fetch(key)
    end
  end
end
