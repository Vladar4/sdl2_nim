# ex401_mixer.nim
# ===============
# AUDIO / sdl_mixer
# -----------------


import
    random,
    sdl2/sdl, sdl2/sdl_image as img,
    sdl2/sdl_ttf as ttf,
    sdl2/sdl_mixer as mix


const
  Title = "SDL2 App"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or sdl.RendererPresentVsync
  white = sdl.Color(r: 0xFF, g: 0xFF, b: 0xFF)
  black = sdl.Color(r: 0x00, g: 0x00, b: 0x00)


type
  App = ref AppObj
  AppObj = object
    window*: sdl.Window # Window pointer
    renderer*: sdl.Renderer # Rendering state pointer


  Image = ref ImageObj
  ImageObj = object of RootObj
    texture: sdl.Texture # Image texture
    w, h: int # Image dimensions


  FpsManager = ref FpsManagerObj
  FpsManagerObj = object
    counter, fps: int
    timer: sdl.TimerID


#########
# IMAGE #
#########

proc newImage(): Image = Image(texture: nil, w: 0, h: 0)
proc free(obj: Image) = sdl.destroyTexture(obj.texture)
proc w(obj: Image): int {.inline.} = return obj.w
proc h(obj: Image): int {.inline.} = return obj.h

# blend
proc blend(obj: Image): sdl.BlendMode =
  var blend: sdl.BlendMode
  if obj.texture.getTextureBlendMode(addr(blend)) == 0:
    return blend
  else:
    return sdl.BlendModeBlend

proc `blend=`(obj: Image, mode: sdl.BlendMode) {.inline.} =
  discard obj.texture.setTextureBlendMode(mode)

# alpha
proc alpha(obj: Image): int =
  var alpha: uint8
  if obj.texture.getTextureAlphaMod(addr(alpha)) == 0:
    return alpha
  else:
    return 255

proc `alpha=`(obj: Image, alpha: int) =
  discard obj.texture.setTextureAlphaMod(alpha.uint8)


# Load image from file
# Return true on success or false, if image can't be loaded
proc load(obj: Image, renderer: sdl.Renderer, file: string): bool =
  result = true
  # Load image to texture
  obj.texture = renderer.loadTexture(file)
  if obj.texture == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load image %s: %s",
                    file, img.getError())
    return false
  # Get image dimensions
  var w, h: cint
  if obj.texture.queryTexture(nil, nil, addr(w), addr(h)) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't get texture attributes: %s",
                    sdl.getError())
    sdl.destroyTexture(obj.texture)
    return false
  obj.w = w
  obj.h = h


# Render texture to screen
proc render(obj: Image, renderer: sdl.Renderer, x, y: int): bool =
  var rect = sdl.Rect(x: x, y: y, w: obj.w, h: obj.h)
  if renderer.renderCopy(obj.texture, nil, addr(rect)) == 0:
    return true
  else:
    return false


# Render transformed texture to screen
proc renderEx(obj: Image, renderer: sdl.Renderer, x, y: int,
              w = 0, h = 0, angle = 0.0, centerX = -1, centerY = -1,
              flip = sdl.FlipNone): bool =
  var
    rect = sdl.Rect(x: x, y: y, w: obj.w, h: obj.h)
    centerObj = sdl.Point(x: centerX, y: centerY)
    center: ptr sdl.Point = nil
  if w != 0: rect.w = w
  if h != 0: rect.h = h
  if not (centerX == -1 and centerY == -1): center = addr(centerObj)
  if renderer.renderCopyEx(obj.texture, nil, addr(rect),
                           angle, center, flip) == 0:
    return true
  else:
    return false


##############
# FPSMANAGER #
##############

# FPS timer
# param is FpsManager casted to pointer
proc fpsTimer(interval: uint32, param: pointer): uint32 {.cdecl.} =
  let obj = cast[FpsManager](param)
  obj.fps = obj.counter
  obj.counter = 0
  return interval


proc newFpsManager(): FpsManager = FpsManager(counter: 0, fps: 0, timer: 0)


proc free(obj: FpsManager) =
  discard sdl.removeTimer(obj.timer)
  obj.timer = 0


proc fps(obj: FpsManager): int {.inline.} = return obj.fps


proc start(obj: FpsManager) =
  obj.timer = sdl.addTimer(1000, fpsTimer, cast[pointer](obj))


proc count(obj: FpsManager) {.inline.} = inc(obj.counter)


##########
# COMMON #
##########

# Initialization sequence
proc init(app: App): bool =
  # Init SDL
  if sdl.init(sdl.InitVideo or sdl.InitTimer or sdl.InitAudio) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Init SDL_Image
  if img.init(img.InitPng) == 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL_Image: %s",
                    img.getError())

  # Init SDL_TTF
  if ttf.init() != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL_TTF: %s",
                    ttf.getError())

  # Init SDL_MIXER
  if mix.openAudio(mix.DefaultFrequency,  # 22050
                   mix.DefaultFormat,     # AudioS16LSB
                   mix.DefaultChannels,   # 2
                   1024 # chunksize in bytes
                  ) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't open mixer with the given audio format: %s",
                    mix.getError())

  if mix.init(mix.InitMP3) == 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize mixer flags: %s",
                    mix.getError())

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
  randomize()
  return true


# Shutdown sequence
proc exit(app: App) =
  app.renderer.destroyRenderer()
  app.window.destroyWindow()
  while mix.init(0) != 0: mix.quit()
  let mixNumOpened = mix.querySpec(nil, nil, nil)
  for i in 0..<mixNumOpened: mix.closeAudio()
  ttf.quit()
  img.quit()
  sdl.logInfo(sdl.LogCategoryApplication, "SDL shutdown completed")
  sdl.quit()


# Render surface
proc render(renderer: sdl.Renderer,
            surface: sdl.Surface, x, y: int): bool =
  result = true
  var rect = sdl.Rect(x: x, y: y, w: surface.w, h: surface.h)
  # Convert to texture
  var texture = sdl.createTextureFromSurface(renderer, surface)
  if texture == nil:
    return false
  # Render texture
  if renderer.renderCopy(texture, nil, addr(rect)) != 0:
    result = false
  # Clean
  destroyTexture(texture)


# Event handling
# Return true on app shutdown request, otherwise return false
proc events(pressed: var seq[sdl.Keycode]): bool =
  result = false
  var e: sdl.Event
  if pressed != nil:
    pressed = @[]

  while sdl.pollEvent(addr(e)) != 0:

    # Quit requested
    if e.kind == sdl.Quit:
      return true

    # Key pressed
    elif e.kind == sdl.KeyDown:
      # Add pressed key to sequence
      if pressed != nil:
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

  # Load assets
  var
    font: ttf.Font
    text: array[22, string]
    music: mix.Music
    volume = mix.MaxVolume div 2
    sound: mix.Chunk
    soundChan = -1

  font = ttf.openFont("fnt/FSEX300.ttf", 16)

  if font == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load font: %s",
                    ttf.getError())
    done = true

  music = mix.loadMUS("snd/Vintage Education.mp3")
  if music == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load music file: %s",
                    mix.getError())

  sound = mix.loadWAV("snd/tack.wav")

  # Init FPS manager
  var
    fpsMgr = newFpsManager()
    delta = 0.0 # Time passed since last frame in seconds
    ticks: uint64 # Ticks counter
    freq = sdl.getPerformanceFrequency() # Get counter frequency
    showInfo = true

  fpsMgr.start()

  echo "----------------------------"
  echo "|        Controls:         |"
  echo "|--------------------------|"
  echo "| F11: show/hide fps info  |"
  echo "----------------------------"
  echo ""
  echo "Found audio drivers:"
  echo "--------------------"
  for i in 0..sdl.getNumAudioDrivers()-1:
    echo sdl.getAudioDriver(i)
  echo "--------------------"
  echo "Using ", sdl.getCurrentAudioDriver()
  echo "--------------------"

  ticks = getPerformanceCounter()

  text[0] = "Controls:"
  text[1] = "Enter - play music"
  text[2] = "Space - pause music"
  text[3] = "Backspace - stop music"
  text[4] = "Up - increase music volume"
  text[5] = "Down - decrease music volume"
  text[6] = "S - play sound"

  # Main loop
  while not done:

    # Clear screen with draw color
    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
    if app.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo,
                  "Can't clear screen: %s",
                  sdl.getError())

    # Render scene

    # Render text
    for i in 0..text.high:
      if (text[i] != nil) and (text[i] != ""):
        var t = font.renderUTF8_Shaded(text[i], white, black)
        if t != nil:
          discard app.renderer.render(t, 10, 30 + 20 * i)
          sdl.freeSurface(t)

    # Render Info
    if showInfo:
      var s = font.renderUTF8_Shaded($fpsMgr.fps & " FPS", white, black)
      if not app.renderer.render(s, 10, 10):
        sdl.logWarn(sdl.LogCategoryVideo,
                    "Can't render text: %s",
                    sdl.getError())
      sdl.freeSurface(s)

    # Update renderer
    app.renderer.renderPresent()

    # Event handling
    done = events(pressed)
    if K_F11 in pressed: showInfo = not showInfo
    # Play music
    if K_Return in pressed:
      discard mix.playMusic(music, 0)
      discard mix.volumeMusic(volume)
    # Pause music
    if K_Space in pressed:
      if mix.pausedMusic() == 0:
        mix.pauseMusic()
      else:
        mix.resumeMusic()
    # Stop music
    if K_Backspace in pressed:
      discard mix.haltMusic()
    # Increase volume
    if K_Up in pressed:
      volume += 8
      if volume > mix.MaxVolume:
        volume = mix.MaxVolume
      discard mix.volumeMusic(volume)
    # Decrease volume
    if K_Down in pressed:
      volume -= 8
      if volume < 0:
        volume = 0
      discard mix.volumeMusic(volume)
    # Play sound
    if K_S in pressed:
      soundChan = mix.playChannel(-1, sound, 0)

    # Count frame
    fpsMgr.count()

    # Get frame duration
    delta = (sdl.getPerformanceCounter() - ticks).float / freq.float
    ticks = sdl.getPerformanceCounter()

    # Update
    for i in 8..text.high:
      text[i] = ""
    text[8] = "Volume: " & $volume
    if mix.playingMusic() != 0:
      text[10] = "Playing music"
    if soundChan >= 0 and mix.playing(soundChan) > 0:
      text[11] = "Playing sound"

  # Free assets
  mix.freeChunk(sound)
  mix.freeMusic(music)
  free(fpsMgr)
  ttf.closeFont(font)

# Shutdown
exit(app)

