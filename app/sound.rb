# play a sound effect. the file in sounds/ must match the key name. ex:
# play_sfx(args, :select)
def play_sfx(args, key, exclusive: false)
  if args.state.setting.sfx
    args.audio.delete key if exclusive
    args.audio[key] = { input: "sounds/#{key}.wav" }
  end
end

# play the specified music track, the key must correspond to the
# `sounds/#{key}.ogg` file naming scheme.
def play_music(args, key)
  args.audio[:music] = { input: "sounds/#{key}", looping: true, }
  set_music_vol(args)
end

# sets the music vol based on whether or not music is enabled or disabled
def set_music_vol(args)
  vol = args.state.setting.music ? 0.2 : 0.0
  args.audio[:music]&.gain = vol
end

# pause the currently playing music track
def pause_music(args)
  args.audio[:music].paused = true
end

# pause the current music track
def resume_music(args)
  args.audio[:music].paused = false
end
