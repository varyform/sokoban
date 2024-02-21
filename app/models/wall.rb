class Wall < Tile
  def sprite
    "sprites/gameplay/7.png"
  end

  def to_sprite
    super.merge!(static: true, source_x: SIZE * calculate_tile_index)
  end

  def weight
    20
  end

  private

  def calculate_tile_index
    @rule ||= begin
      wall_rules.to_a.reverse.find do |rules, _i|
        rules.all? { |direction| entity_at(direction).is_a?(Wall) }
      end.last
    end
  end

  def wall_rules
    {
      [:up]                => 5,
      [:down]              => 10,
      [:left]              => 11,
      [:right]             => 2,
      [:right, :up]        => 1,
      [:right, :down]      => 2,
      [:left, :right]      => 3,
      [:left, :down]       => 4,
      [:up, :down]         => 5,
      [:left, :up]         => 6,
      [:left, :up, :down]  => 7,
      [:right, :up, :down] => 8,
      [:left, :right, :up] => 9,
    }
  end
end
