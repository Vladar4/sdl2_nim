# ex205_sdl_gfx_primitives.nim
# ============================
# VIDEO / Drawing geometric primitives provided by sdl_gfx_primitives
# -------------------------------------------------------------------


import
    random,
    sdl2/sdl, sdl2/sdl_image as img,
    sdl2/sdl_gfx_primitives as gfx, sdl2/sdl_gfx_primitives_font as font


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

  # Generate random colors palette
  var rnd: array[256, sdl.Color]
  for i in 0..255:
    rnd[i].r = random(255).uint8
    rnd[i].g = random(255).uint8
    rnd[i].b = random(255).uint8
    rnd[i].a = 255
    if rnd[i].r < 32 and rnd[i].g < 32 and rnd[i].b < 32:
      rnd[i].r = uint8(255 - rnd[i].r)
      rnd[i].g = uint8(255 - rnd[i].g)
      rnd[i].b = uint8(255 - rnd[i].b)

  # Load font
  gfx.gfxPrimitivesSetFont(addr(font.gfxPrimitivesFontData), 8, 8)

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
    discard app.renderer.pixelRGBA(
      x = 10, y = 10,
      rnd[0].r, rnd[0].g, rnd[0].b, rnd[0].a)

    # Horizontal line
    discard app.renderer.hlineRGBA(
      x1 = 10, x2 = 110, y = 20,
      rnd[1].r, rnd[1].g, rnd[1].b, rnd[1].a)

    # Vertical line
    discard app.renderer.vlineRGBA(
      x = 120, y1 = 10, y2 = 470,
      rnd[2].r, rnd[2].g, rnd[2].b, rnd[2].a)

    # Rectangle
    discard app.renderer.rectangleRGBA(
      x1 = 10, y1 = 30, x2 = 110, y2 = 60,
      rnd[3].r, rnd[3].g, rnd[3].b, rnd[3].a)

    # Rounded rectangle
    discard app.renderer.roundedRectangleRGBA(
      x1 = 10, y1 = 70,  x2 = 110, y2 = 100, rad = 10,
      rnd[4].r, rnd[4].g, rnd[4].b, rnd[4].a)

    # Box
    discard app.renderer.boxRGBA(
      x1 = 10, y1 = 110, x2 = 110, y2 = 140,
      rnd[5].r, rnd[5].g, rnd[5].b, rnd[5].a)

    # RoundedBox
    discard app.renderer.roundedBoxRGBA(
      x1 = 10, y1 = 150, x2 = 110, y2 = 180, rad = 10,
      rnd[6].r, rnd[6].g, rnd[6].b, rnd[6].a)

    # Line
    discard app.renderer.lineRGBA(
      x1 = 10, y1 = 190, x2 = 110, y2 = 210,
      rnd[7].r, rnd[7].g, rnd[7].b, rnd[7].a)

    # Anti-aliased line
    discard app.renderer.aalineRGBA(
      x1 = 10, y1 = 200, x2 = 110, y2 = 220,
      rnd[8].r, rnd[8].g, rnd[8].b, rnd[8].a)

    # Thick line
    discard app.renderer.thickLineRGBA(
      x1 = 10, y1 = 210, x2 = 110, y2 = 230, width = 5,
      rnd[9].r, rnd[9].g, rnd[9].b, rnd[9].a)

    # Circle
    discard app.renderer.circleRGBA(
      x = 60, y = 280, rad = 50,
      rnd[10].r, rnd[10].g, rnd[10].b, rnd[10].a)

    # Arc
    discard app.renderer.arcRGBA(
      x = 60, y = 300, rad = 50, start = 30, finish = 150,
      rnd[11].r, rnd[11].g, rnd[11].b, rnd[11].a)

    # Anti-aliased circle
    discard app.renderer.aacircleRGBA(
      x = 60, y = 420, rad = 50,
      rnd[12].r, rnd[12].g, rnd[12].b, rnd[12].a)

    # Filled circle
    discard app.renderer.filledCircleRGBA(
      x = 180, y = 60, rad = 50,
      rnd[13].r, rnd[13].g, rnd[13].b, rnd[13].a)

    # Ellipse
    discard app.renderer.ellipseRGBA(
      x = 180, y = 135, rx = 50, ry = 15,
      rnd[14].r, rnd[14].g, rnd[14].b, rnd[14].a)

    # Anti-aliased ellipse
    discard app.renderer.aaellipseRGBA(
      x = 180, y = 180, rx = 50, ry = 15,
      rnd[15].r, rnd[15].g, rnd[15].b, rnd[15].a)

    # Filled ellipse
    discard app.renderer.filledEllipseRGBA(
      x = 180, y = 225, rx = 50, ry = 15,
      rnd[16].r, rnd[16].g, rnd[16].b, rnd[16].a)

    # Pie
    discard app.renderer.pieRGBA(
      x = 180, y = 260, rad = 50, start = 30, finish = 150,
      rnd[17].r, rnd[17].g, rnd[17].b, rnd[17].a)

    # Filled pie
    discard app.renderer.filledPieRGBA(
      x = 180, y = 320, rad = 50, start = 30, finish = 150,
      rnd[18].r, rnd[18].g, rnd[18].b, rnd[18].a)

    # Trigon
    discard app.renderer.trigonRGBA(
      x1 = 130, y1 = 380, x2 = 230, y2 = 390, x3 = 130, y3 = 410,
      rnd[19].r, rnd[19].g, rnd[19].b, rnd[19].a)

    # Anti-aliased trigon
    discard app.renderer.aatrigonRGBA(
      x1 = 130, y1 = 420, x2 = 230, y2 = 400, x3 = 230, y3 = 430,
      rnd[20].r, rnd[20].g, rnd[20].b, rnd[20].a)

    # Filled trigon
    discard app.renderer.filledTrigonRGBA(
      x1 = 130, y1 = 430, x2 = 230, y2 = 440, x3 = 130, y3 = 460,
      rnd[21].r, rnd[21].g, rnd[21].b, rnd[21].a)

    # Polygon
    const polyN = 4
    var polyX, polyY: array[polyN, int16]
    polyX[0] = 260
    polyY[0] = 10
    polyX[1] = 350
    polyY[1] = 20
    polyX[2] = 340
    polyY[2] = 40
    polyX[3] = 250
    polyY[3] = 30
    discard app.renderer.polygonRGBA(
      vx = addr(polyX[0]), vy = addr(polyY[0]), n = polyN,
      rnd[22].r, rnd[22].g, rnd[22].b, rnd[22].a)

    # Anti-aliased polygon
    polyY[0] = 50
    polyY[1] = 60
    polyY[2] = 80
    polyY[3] = 70
    discard app.renderer.aapolygonRGBA(
      vx = addr(polyX[0]), vy = addr(polyY[0]), n = polyN,
      rnd[23].r, rnd[23].g, rnd[23].b, rnd[23].a)

    # Filled polygon
    polyY[0] = 90
    polyY[1] = 100
    polyY[2] = 120
    polyY[3] = 110
    discard app.renderer.filledPolygonRGBA(
      vx = addr(polyX[0]), vy = addr(polyY[0]), n = polyN,
      rnd[24].r, rnd[24].g, rnd[24].b, rnd[24].a)

    # Textured polygon
    polyY[0] = 130
    polyY[1] = 140
    polyY[2] = 160
    polyY[3] = 150
    var polyTexture = img.load("img/img2.png")
    discard app.renderer.texturedPolygon(
      vx = addr(polyX[0]), vy = addr(polyY[0]), n = polyN,
      polyTexture, 0, 0)

    # Bezier curve
    const bezN = 4
    var bezX, bezY: array[bezN, int16]
    bezX[0] = 260
    bezY[0] = 170
    bezX[1] = 350
    bezY[1] = 180
    bezX[2] = 260
    bezY[2] = 190
    bezX[3] = 350
    bezY[3] = 200
    discard app.renderer.bezierRGBA(
      vx = addr(bezX[0]), vy = addr(bezY[0]), n = bezN, s = 100,
      rnd[25].r, rnd[25].g, rnd[25].b, rnd[25].a)

    # Character
    discard app.renderer.characterRGBA(
      x = 370, y = 10, 'A',
      rnd[26].r, rnd[26].g, rnd[26].b, rnd[26].a)

    # String
    discard app.renderer.stringRGBA(
      x = 370, y = 30, "String",
      rnd[27].r, rnd[27].g, rnd[27].b, rnd[27].a)

    # Update renderer
    app.renderer.renderPresent()

    # Event handling
    done = events(pressed)

# Shutdown
exit(app)

