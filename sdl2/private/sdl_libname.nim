{.deadCodeElim: on.}

template decl(libname, filename: untyped) =
  when not declared `libname`:
      const `libname`* {.inject.} = filename

when defined windows:

  decl(SDL2_LIB, "SDL2.dll")
  decl(SDL2_GFX_LIB, "SDL2_gfx.dll")
  decl(SDL2_IMG_LIB, "SDL2_image.dll")
  decl(SDL2_MIX_LIB, "SDL2_mixer.dll")
  decl(SDL2_TTF_LIB, "SDL2_ttf.dll")
  decl(SDL2_NET_LIB, "SDL2_net.dll")

elif defined macosx:

  decl(SDL2_LIB, "libSDL2.dylib")
  decl(SDL2_GFX_LIB, "libSDL2_gfx.dylib")
  decl(SDL2_IMG_LIB, "libSDL2_image.dylib")
  decl(SDL2_MIX_LIB, "libSDL2_mixer.dylib")
  decl(SDL2_NET_LIB, "libSDL2_net.dylib")
  decl(SDL2_TTF_LIB, "libSDL2_ttf.dylib")

else:

  decl(SDL2_LIB, "libSDL2-2.0.so(|.0.5.0|.0)")
  decl(SDL2_GFX_LIB, "libSDL2_gfx(|-1.0).so(|.0.0.1|.0)")
  decl(SDL2_IMG_LIB, "libSDL2_image(|-2.0).so(|.0.0.1|.0)")
  decl(SDL2_MIX_LIB, "libSDL2_mixer(|-2.0).so(|.0.0.1|.0)")
  decl(SDL2_NET_LIB, "libSDL2_net(|-2.0).so(|.0.0.1|.0)")
  decl(SDL2_TTF_LIB, "libSDL2_ttf(|-2.0).so(|.0.10.3|.0)")
