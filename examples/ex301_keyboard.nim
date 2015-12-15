# ex301_keyboard.nim
# ==================
# INPUT / Keyboard
# ----------------


import
    math,
    sdl2/sdl, sdl2/sdl_image as img,
    sdl2/sdl_ttf as ttf


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
  if sdl.init(sdl.InitVideo or sdl.InitTimer) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Init SDL_Image
  if img.init(img.InitPng) == 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL_Image: %s",
                    img.getError())

  # Inint SDL_TTF
  if ttf.init() != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL_TTF: %s",
                    ttf.getError())

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
    image = newImage()
    imagePos: tuple[x, y: float64]
    imageSpd = 200.0
    text: array[22, string]

  font = ttf.openFont("fnt/FSEX300.ttf", 16)

  if font == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load font: %s",
                    ttf.getError())
    done = true

  if not image.load(app.renderer, "img/img1a.png"):
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't load image: %s",
                    img.getError())

  imagePos.x = ScreenW div 2
  imagePos.y = ScreenH div 2

  # Init FPS manager
  var
    fpsMgr = newFpsManager()
    delta = 0.0 # Time passed since last frame in seconds
    ticks: uint64 # Ticks counter
    freq = sdl.getPerformanceFrequency() # Get counter frequency
    showInfo = true

  fpsMgr.start()

  echo "---------------------------"
  echo "|        Controls:        |"
  echo "|-------------------------|"
  echo "| F11: show/hide fps info |"
  echo "| Arrows: move            |"
  echo "| Shift: speed up         |"
  echo "| Ctrl: slow down         |"
  echo "---------------------------"

  ticks = getPerformanceCounter()

  # Main loop
  while not done:

    # Clear screen with draw color
    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
    if app.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo,
                  "Can't clear screen: %s",
                  sdl.getError())

    # Render scene
    discard image.render(app.renderer,
                         imagePos.x.int - image.w div 2,
                         imagePos.y.int - image.h div 2)

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

    # Enent handling
    done = events(pressed)
    if K_F11 in pressed: showInfo = not showInfo

    # Count frame
    fpsMgr.count()

    # Get frame duration
    delta = (sdl.getPerformanceCounter() - ticks).float / freq.float
    ticks = sdl.getPerformanceCounter()

    # Update
    for i in 0..text.high:
      text[i] = ""

    # Get a snapshot of the current state of the keyboard.
    let kbd = sdl.getKeyboardState(nil)

    # Check active keys
    if kbd[ScancodeUp]    > 0: imagePos.y -= imageSpd * delta; text[0] = "Up"
    if kbd[ScancodeDown]  > 0: imagePos.y += imageSpd * delta; text[1] = "Down"
    if kbd[ScancodeLeft]  > 0: imagePos.x -= imageSpd * delta; text[2] = "Left"
    if kbd[ScancodeRight] > 0: imagePos.x += imageSpd * delta; text[3] = "Right"

    # Check just pressed keys
    if K_LShift in pressed: imageSpd += 100; text[5] = "Shift"
    if K_LCtrl  in pressed: imageSpd -= 100; text[6] = "Ctrl"

    if imageSpd < 100:  imageSpd = 100
    if imageSpd > 1000: imageSpd = 1000

    text[text.high] = "Speed: " & $imageSpd & " px/s"

    # Check screen borders
    if imagePos.y < 0: imagePos.y = 0
    if imagePos.x < 0: imagePos.x = 0
    if imagePos.y > ScreenH: imagePos.y = ScreenH
    if imagePos.x > ScreenW: imagePos.x = ScreenW

  # Free assets
  free(image)
  free(fpsMgr)
  ttf.closeFont(font)

# Shutdown
exit(app)

