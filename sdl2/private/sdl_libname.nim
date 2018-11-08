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
  decl(SDL2_GPU_LIB, "SDL2_gpu.dll")
  decl(SMPEG2_LIB,   "smpeg2.dll")

elif defined macosx:

  decl(SDL2_LIB, "libSDL2.dylib")
  decl(SDL2_GFX_LIB, "libSDL2_gfx.dylib")
  decl(SDL2_IMG_LIB, "libSDL2_image.dylib")
  decl(SDL2_MIX_LIB, "libSDL2_mixer.dylib")
  decl(SDL2_NET_LIB, "libSDL2_net.dylib")
  decl(SDL2_TTF_LIB, "libSDL2_ttf.dylib")
  decl(SDL2_GPU_LIB, "libSDL2_gpu.dylib")
  decl(SMPEG2_LIB,   "libsmpeg2.dylib")

else:

  decl(SDL2_LIB, "libSDL2(|-2.0).so(|.0.9.0|.0)")
  decl(SDL2_GFX_LIB, "libSDL2_gfx(|-1.0).so(|.0.0.2|.0)")
  decl(SDL2_IMG_LIB, "libSDL2_image(|-2.0).so(|.0.2.2|.0)")
  decl(SDL2_MIX_LIB, "libSDL2_mixer(|-2.0).so(|.0.2.2|.0)")
  decl(SDL2_NET_LIB, "libSDL2_net(|-2.0).so(|.0.0.1|.0)")
  decl(SDL2_TTF_LIB, "libSDL2_ttf(|-2.0).so(|.0.14.0|.0)")
  decl(SDL2_GPU_LIB, "libSDL2_gpu(|-2.0).so(|.0.11.0|.0)")
  decl(SMPEG2_LIB,   "libsmpeg2(|-2.0).so(|.0.0.0|.0)")
