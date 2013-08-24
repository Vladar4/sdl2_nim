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

