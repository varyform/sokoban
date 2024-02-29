# Why put our text in a Hash? It makes it easier to proofread when near each
# other, makes the game easier to localize, and it's easier to manage than
# scouring the codebase.
#
# Don't access via this constant! Use the `#text` method instead.
TEXT = {
  back: "Back",
  controls_title: "Controls",
  controls_keyboard: "WASD/Arrows to move | Space/Enter to confirm | Esc/P to pause",
  controls_gamepad: "Stick/D-Pad to move | A to confirm | Start to pause",
  fullscreen: "Fullscreen",
  made_by: "A game by",
  music: "Ambient factory noice (AKA music)",
  off: "OFF",
  on: "ON",
  paused: "Paused",
  quit: "Quit",
  resume: "Resume",
  return_to_main_menu: "Return to Main Menu",
  settings: "Settings",
  sfx: "Sound Effects",
  continue: "Continue",
  select_level: "Select Level",
  start: "Start"
}

# Gets the text for the passed in `key`. Raises if it does not exist. We don't
# want missing text!
def text(key)
  TEXT.fetch(key)
end

SIZE_XS = 0
SIZE_SM = 4
SIZE_MD = 6
SIZE_LG = 10

FONT_REGULAR = "fonts/diffusion-light"
FONT_ITALIC = "fonts/diffusion-light"
FONT_BOLD = "fonts/diffusion-light"
FONT_BOLD_ITALIC = "fonts/diffusion-light"

# Friendly method with sensible defaults for creating DRGTK label data
# structures.
def label(value_or_key, x:, y:, align: ALIGN_LEFT, size: SIZE_MD, color: WHITE, font: FONT_REGULAR)
  text = if value_or_key.is_a?(Symbol)
           text(value_or_key)
         else
           value_or_key
         end

  {
    text: text,
    x: x,
    y: y,
    alignment_enum: align,
    size_enum: size,
    font: font,
  }.merge(color)
end
