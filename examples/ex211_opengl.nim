# ex211_opengl.nim
# ================
# VIDEO / Using OpenGL
# --------------------

#
# Don't forget to install opengl library!
# (nimble install opengl)
#

import sdl2_nim/sdl, sdl2_nim/sdl_image as img, opengl, opengl/glu


const
  Title = "SDL2 App"
  ScreenW = 640 # Window width
  ScreenH = 480 # Window height
  WindowFlags = sdl.WindowOpenGL or sdl.WindowShown


type
  App = ref AppObj
  AppObj = object
    window*: sdl.Window # Window pointer
    glcontext*: sdl.GLContext # OpenGL context



var gRenderQuad = true;

##########
# COMMON #
##########

# Initialization sequence
proc init(app: App): bool =
  result = true

  # Init SDL
  if sdl.init(sdl.InitVideo) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Set OpenGL attributes
  discard sdl.glSetAttribute(sdl.GLContextMajorVersion, 2)
  discard sdl.glSetAttribute(sdl.GLContextMajorVersion, 1)

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

  #
  # Init OpenGL
  #

  # Create context
  app.glcontext = glCreateContext(app.window)
  if app.glcontext == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't create OpenGL context: %s",
                    sdl.getError())
    return false
  loadExtensions()

  # Use Vsync
  if sdl.glSetSwapInterval(1) < 0:
    echo "Warning: Unable to set Vsync: %s", sdl.getError()

  var error: GLEnum = GL_NoError

  # Set camera projection matrix
  glMatrixMode(GL_Projection)
  glLoadIdentity()
  error = glGetError()
  if error != GL_NoError:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize OpenGL: %s",
                    gluErrorString(error))
    return

  # Set Modelview matrix
  glMatrixMode(GL_Modelview)
  glLoadIdentity()
  error = glGetError()
  if error != GL_NoError:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize OpenGL: %s",
                    gluErrorString(error))
    return

  # Set clear color
  glClearColor(0.0, 0.0, 0.0, 1)
  error = glGetError()
  if error != GL_NoError:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize OpenGL: %s",
                    gluErrorString(error))
    return


# Shutdown sequence
proc exit(app: App) =
  sdl.glDeleteContext(app.glcontext)
  app.window.destroyWindow()
  img.quit()
  sdl.logInfo(sdl.LogCategoryApplication, "SDL shutdown completed")
  sdl.quit()


# Event handling
# Return true on app shutdown request, otherwise return false
proc events(): bool =
  result = false
  var e: sdl.Event

  while sdl.pollEvent(addr(e)) != 0:

    # Quit requested
    if e.kind == sdl.Quit:
      return true

    # Key pressed
    elif e.kind == sdl.KeyDown:
      # Exit on Escape key press
      if e.key.keysym.sym == sdl.K_Escape:
        return true
      # Toggle quad rendering
      if e.key.keysym.sym == sdl.K_q:
        gRenderQuad = not gRenderQuad


########
# MAIN #
########

var
  app = App(window: nil, glcontext: nil)
  done = false # Main loop exit condition

if init(app):

  echo "---------------------------"
  echo "|        Controls:        |"
  echo "|-------------------------|"
  echo "| Q: show/hide quad       |"
  echo "---------------------------"

  # Main loop
  while not done:

    # Event handling
    done = events()

    # Clear color buffer
    glClear(GL_ColorBufferBit)

    # Render
    if gRenderQuad:
      glBegin(GL_Quads)
      glVertex2f(-0.5, -0.5)
      glVertex2f(0.5, -0.5)
      glVertex2f(0.5, 0.5)
      glVertex2f(-0.5, 0.5)
      glEnd()

    sdl.glSwapWindow(app.window)

# Shutdown
exit(app)

