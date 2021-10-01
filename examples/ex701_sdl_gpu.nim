# ex701_sdl_gpu.nim
# =================
# SDL_GPU usage
# -----------------

import
  sdl2_nim/sdl,
  sdl2_nim/sdl_gpu

when isMainModule:
  setDebugLevel(DEBUG_LEVEL_MAX);
  let screen = init(800, 600, DEFAULT_INIT_FLAGS)

  if screen == nil:
    quit(1)

  let image = loadImage("img/img1.png")
  if image == nil:
    quit(1)

  var event: Event
  var done = false
  while not done:
    while pollEvent(event.addr) != 0:
      if event.kind == QUIT:
        done = true

    clear(screen)
    blit(image, nil, screen, screen.w.float / 2, screen.h.float / 2)
    flip(screen)

  sdl_gpu.quit()

