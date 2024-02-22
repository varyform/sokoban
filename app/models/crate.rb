class Crate < Tile
  frames 12
  weight 40

  sprite do
    if any_of_type_in_place?(Target)
      "gameplay/2.png"
    else
      "gameplay/1.png"
    end
  end

  def can_move?(direction)
    # return false unless super(direction)

    target = entity_at(direction)

    target.is_a?(Empty) || target.is_a?(Target)
  end

  def move!(direction)
    super

    state.level.stats.pushes += 1

    if state.setting.sfx
      audio.delete :crate
      audio[:crate] = { input: "sounds/crate/moving.wav" }
    end

    @move_to = entity_at(direction).position
  end

  def to_sprite
    temp = super

    temp = temp.merge(a: state.tick_count % 30 < 15 ? 30 : 255) if state.level.finished?

    temp
  end
end
