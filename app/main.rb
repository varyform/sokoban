require "app/input.rb"
require "app/sprite.rb"
require "app/util.rb"

require "app/constants.rb"
require "app/menu.rb"
require "app/scene.rb"
require "app/game_setting.rb"
require "app/sound.rb"
require "app/text.rb"

require "app/scenes/gameplay.rb"
require "app/scenes/main_menu.rb"
require "app/scenes/paused.rb"
require "app/scenes/settings.rb"

require "data/levels.rb"

require "app/models/level.rb"
require "app/models/tile.rb"
require "app/models/empty.rb"
require "app/models/player.rb"
require "app/models/target.rb"
require "app/models/crate.rb"
require "app/models/wall.rb"

# NOTE: add all requires above this

require "app/tick.rb"
