# ex204_drawing.nim
# =================
# VIDEO / Drawing geometric primitives
# ------------------------------------


import
  random,
  sdl2/sdl, sdl2/sdl_image as img


const
  Title = "SDL2 App"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = 0
  RendererFlags = sdl.RendererAccelerated or sdl.RendererPresentVsync


type
  App = ref AppObj
  AppObj = object
    window*: sdl.Window # Window pointer
    renderer*: sdl.Renderer # Rendering state pointer


  Image = ref ImageObj
  ImageObj = object of RootObj
    texture: sdl.Texture # Image texture
    w, h: int # Image dimensions


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


##########
# COMMON #
##########

# Initialization sequence
proc init(app: App): bool =
  # Init SDL
  if sdl.init(sdl.InitVideo) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Init SDL_Image
  if img.init(img.InitPng) == 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL_Image: %s",
                    img.getError())

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
  img.quit()
  sdl.logInfo(sdl.LogCategoryApplication, "SDL shutdown completed")
  sdl.quit()


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

  # Main loop
  while not done:
    # Clear screen with draw color
    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0x00, 0xFF)
    if app.renderer.renderClear() != 0:
      sdl.logWarn(sdl.LogCategoryVideo,
                  "Can't clear screen: %s",
                  sdl.getError())

    # Drawing

    # Point
    discard app.renderer.setRenderDrawColor(0xFF, 0x00, 0x00, 0xFF)
    discard app.renderer.renderDrawPoint(10, 10)

    # Line
    discard app.renderer.setRenderDrawColor(0x00, 0xFF, 0x00, 0xFF)
    discard app.renderer.renderDrawLine(10, 20, 110, 20)

    # Rect
    discard app.renderer.setRenderDrawColor(0x00, 0x00, 0xFF, 0xFF)
    var rect = sdl.Rect(x: 10, y: 30, w: 100, h: 50)
    discard app.renderer.renderDrawRect(addr(rect))

    # Fill rect
    discard app.renderer.setRenderDrawColor(0xFF, 0xFF, 0x00, 0xFF)
    rect.y = 90
    discard app.renderer.renderFillRect(addr(rect))

    # Random points
    discard app.renderer.setRenderDrawColor(0xFF, 0xFF, 0xFF, 0xFF)
    rect.x = 120
    rect.y = 10
    rect.w = 510
    rect.h = 460
    discard app.renderer.renderDrawRect(addr(rect))
    const numPoints = 100
    var points: array[numPoints, sdl.Point]
    for i in 0..numPoints-1:
      points[i].x = rect.x + 1 + random(rect.w - 2)
      points[i].y = rect.y + 1 + random(rect.h - 2)
    discard app.renderer.renderDrawPoints(addr(points[0]), numPoints)

    # Connected lines
    discard app.renderer.setRenderDrawColor(0xFF, 0x00, 0xFF, 0xFF)
    var figure: array[6, sdl.Point]
    figure[0] = Point(x: 60, y: 150)  # top
    figure[1] = Point(x: 92, y: 250)  # bottom-right
    figure[2] = Point(x: 10, y: 188)  # left
    figure[3] = Point(x: 110, y: 188) # right
    figure[4] = Point(x: 28, y: 250)  # bottom-left
    figure[5] = figure[0]
    discard app.renderer.renderDrawLines(addr(figure[0]), 6)

    # Update renderer
    app.renderer.renderPresent()

    # Event handling
    done = events(pressed)

# Shutdown
exit(app)

