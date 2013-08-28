{.deadCodeElim: on.}


when not defined(LibName):
  when defined(windows):
    const
      LibName* = "SDL2.dll"
  elif defined(linux):
    const
      LibName* = "libSDL2.so"
  else:
    const
      LibName* = "libSDL2-2.0.0.dylib"


when not defined(LibImgName):
  when defined(windows):
    const
      LibImgName* = "SDL2_image.dll"
  elif defined(linux):
    const
      LibImgName* = "libSDL2_image.so"
  else:
    const
      LibImgName* = "libSDL2_image-2.0.0.dylib"


when not defined(LibMixName):
  when defined(windows):
    const
      LibMixName* = "SDL2_mixer.dll"
  elif defined(linux):
    const
      LibMixName* = "libSDL2_mixer.so"
  else:
    const
      LibMixName* = "libSDL2_mixer-2.0.0.dylib"


when not defined(LibNetName):
  when defined(windows):
    const
      LibNetName* = "SDL2_net.dll"
  elif defined(linux):
    const
      LibNetName* = "libSDL2_net.so"
  else:
    const
      LibNetName* = "libSDL2_net-2.0.0.dylib"

