# ex601_smpeg.nim
# ===============
# SMPEG usage
# ---------------


import
    sdl2_nim/sdl,
    sdl2_nim/smpeg


const
  Title = "SDL2 App"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or
                  sdl.RendererPresentVsync or
                  sdl.RendererTargetTexture


type
  App = ref AppObj
  AppObj = object
    window*: sdl.Window # Window pointer
    renderer*: sdl.Renderer # Rendering state pointer

  Movie = ref object
    smpeg*: smpeg.Smpeg
    frame*: smpeg.Frame
    texture*: sdl.Texture
    mutex*: sdl.Mutex
    rect*: sdl.Rect
    updated*: bool

#########
# MOVIE #
#########

proc update(data: pointer, frame: Frame) {.cdecl.} =
  var movie = cast[Movie](data)
  movie.frame = frame
  movie.updated = true


proc free(movie: Movie) =
  movie.smpeg.stop()
  movie.smpeg.delete()
  sdl.destroyTexture(movie.texture)
  sdl.destroyMutex(movie.mutex)


proc newMovie*(filename: string, renderer: sdl.Renderer): Movie =
  new result, free
  var info: smpeg.Info

  # Load MPG movie
  result.smpeg = smpeg.new(filename, addr(info), true)
  let error = result.smpeg.error()
  if error != nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "SMPEG error: %s",
                    error)
    result.smpeg.delete()
    return nil

  result.mutex = sdl.createMutex()
  result.texture = renderer.createTexture(
    sdl.PixelFormat_YV12, sdl.TextureAccessStreaming, info.width, info.height)
  result.rect = sdl.Rect(x: 0, y: 0, w: info.width, h: info.height)

  # Set callback
  result.smpeg.setDisplay(update, cast[pointer](result), result.mutex)


proc lock(movie: Movie) {.inline.} =
  discard sdl.mutexP(movie.mutex)


proc unlock(movie: Movie) {.inline.} =
  discard sdl.mutexV(movie.mutex)


##########
# COMMON #
##########

# Initialization sequence
proc init(app: App): bool =
  # Init SDL
  if sdl.init(sdl.InitVideo or sdl.InitTimer) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Create window
  app.window = sdl.createWindow(
    Title,
    sdl.WindowPosUndefined,
    sdl.WindowPosUndefined,
    ScreenW,
    ScreenH,
    WindowFlags)
  if app.window == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't create window: %s",
                    sdl.getError())
    return false

  # Create renderer
  app.renderer = sdl.createRenderer(app.window, -1, RendererFlags)
  if app.renderer == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't create renderer: %s",
                    sdl.getError())
    return false

  # Set draw color
  if app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF) != 0:
    sdl.logWarn(sdl.LogCategoryVideo,
                "Can't set draw color: %s",
                sdl.getError())
    return false

  sdl.logInfo(sdl.LogCategoryApplication, "SDL initialized successfully")
  return true


# Shutdown sequence
proc exit(app: App) =
  app.renderer.destroyRenderer()
  app.window.destroyWindow()
  sdl.logInfo(sdl.LogCategoryApplication, "SDL shutdown completed")
  sdl.quit()


# Event handling
# Return true on app shutdown request, otherwise return false
proc events(pressed: var seq[sdl.Keycode]): bool =
  result = false
  var e: sdl.Event
  if pressed.len > 0:
    pressed = @[]

  while sdl.pollEvent(addr(e)) != 0:

    # Quit requested
    if e.kind == sdl.Quit:
      return true

    # Key pressed
    elif e.kind == sdl.KeyDown:
      # Add pressed key to sequence
      pressed.add(e.key.keysym.sym)

      # Exit on Escape key press
      if e.key.keysym.sym == sdl.K_Escape:
        return true


########
# MAIN #
########

var
  app = App(window: nil, renderer: nil)
  done = false # Main loop exit condition
  pressed: seq[sdl.Keycode] = @[] # Pressed keys

if init(app):
  var
    dstRect: sdl.Rect
    movie: Movie

  # Load assets
  movie = newMovie("mpg/test.mpg", app.renderer)
  if movie == nil: # error on loading movie
    done = true
  dstRect = movie.rect
  app.window.setWindowSize(dstRect.w, dstRect.h)
  movie.smpeg.play()

  # Main loop
  while not done:

    # Clear screen with draw color
    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
    if app.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo,
                  "Can't clear screen: %s",
                  sdl.getError())

    # Render movie
    if movie.updated:
      movie.lock()
      discard sdl.updateTexture(
        movie.texture, nil, movie.frame.image, movie.frame.imageWidth.cint)
      movie.updated = false
      movie.unlock()

    # Update renderer
    discard app.renderer.renderCopy(
      movie.texture, addr(movie.rect), addr(dstRect))
    app.renderer.renderPresent()

    # Event handling
    done = events(pressed)

  # Free assets
  if movie != nil:
    free(movie)

# Shutdown
exit(app)

