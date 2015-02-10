{.deadCodeElim: on.}

template decl(libname: expr, debug_name, release_name: string) {.immediate.} =
  when defined debug:
    const `libname`* {.inject.} = debug_name
  else:
    const `libname`* {.inject.} = release_name

when defined windows:

  decl(SDL2_LIB, "SDL2.dll", "SDL2.dll")
  decl(SDL2_GFX_LIB, "SDL2_gfx.dll", "SDL2_gfx.dll")
  decl(SDL2_IMG_LIB, "SDL2_image.dll", "SDL2_image.dll")
  decl(SDL2_MIX_LIB, "SDL2_mixer.dll", "SDL2_mixer.dll")
  decl(SDL2_TTF_LIB, "SDL2_ttf.dll", "SDL2_ttf.dll")
  decl(SDL2_NET_LIB, "SDL2_net.dll","SDL2_net.dll")

elif defined macosx:

  decl(SDL2_LIB, "libSDL2-2.0.3.dylib", "libSDL2-2.0.3.dylib")
  decl(SDL2_GFX_LIB, "libSDL2_gfx.dylib", "libSDL2_gfx.dylib")
  decl(SDL2_IMG_LIB, "libSDL2_image-2.0.3.dylib", "libSDL2_image-2.0.3.dylib")
  decl(SDL2_MIX_LIB, "libSDL2_mixer-2.0.3.dylib", "libSDL2_mixer-2.0.3.dylib")
  decl(SDL2_NET_LIB, "libSDL2_net-2.0.3.dylib", "libSDL2_net-2.0.3.dylib")
  decl(SDL2_TTF_LIB, "libSDL2_ttf-2.0.3.dylib", "libSDL2_ttf-2.0.3.dylib")

else:

  decl(SDL2_LIB, "libSDL2-2.0.so", "libSDL2-2.0.so")
  decl(SDL2_GFX_LIB, "libSDL2_gfx.so", "libSDL2_gfx.so")
  decl(SDL2_IMG_LIB, "libSDL2_image-2.0.so", "libSDL2_image-2.0.so")
  decl(SDL2_MIX_LIB, "libSDL2_mixer-2.0.so", "libSDL2_mixer-2.0.so")
  decl(SDL2_NET_LIB, "libSDL2_net-2.0.so", "libSDL2_net-2.0.so")
  decl(SDL2_TTF_LIB, "libSDL2_ttf-2.0.so", "libSDL2_ttf-2.0.so")
