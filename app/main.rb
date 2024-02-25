require "app/input"
require "app/sprite"
require "app/util"

require "app/constants"
require "app/menu"
require "app/scene"
require "app/game_setting"
require "app/sound"
require "app/text"

require "app/scenes/gameplay"
require "app/scenes/select_level"
require "app/scenes/main_menu"
require "app/scenes/paused"
require "app/scenes/settings"

require "data/levels"
require "app/shared/shared"

require "app/models/level"
require "app/models/tile"
require "app/models/empty"
require "app/models/player"
require "app/models/target"
require "app/models/crate"
require "app/models/wall"

require "app/particle_system"
require "app/effects/fireworks_effect"
require "app/fireworks"

# NOTE: add all requires above this

require "app/tick"
