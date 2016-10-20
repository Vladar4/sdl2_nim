#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2016 Sam Lantinga <slouken@libsdl.org>
#
#  This software is provided 'as-is', without any express or implied
#  warranty.  In no event will the authors be held liable for any damages
#  arising from the use of this software.
#
#  Permission is granted to anyone to use this software for any purpose,
#  including commercial applications, and to alter it and redistribute it
#  freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you must not
#     claim that you wrote the original software. If you use this software
#     in a product, an acknowledgment in the product documentation would be
#     appreciated but is not required.
#  2. Altered source versions must be plainly marked as such, and must not be
#     misrepresented as being the original software.
#  3. This notice may not be removed or altered from any source distribution.
#

##  video.nim
##  =========
##
##  Header file for SDL video procedures.

type
  DisplayMode* = object ##  \
    ##  The object that defines a display mode
    ##
    ##  See also:
    ##
    ##  ``getNumDisplayModes()``
    ##
    ##  ``getDisplayMode()``
    ##
    ##  ``getDesktopDisplayMode()``
    ##
    ##  ``getCurrentDisplayMode()``
    ##
    ##  ``getClosestDisplayMode()``
    ##
    ##  ``getWindowDisplayMode()``
    ##
    ##  ``getWindowDisplayMode()``
    format*: uint32         ## pixel format
    w*: cint                ## width, in screen coordinates
    h*: cint                ## height, in screen coordinates
    refresh_rate*: cint     ## refresh rate (or zero for unspecified)
    driverdata*: pointer    ## driver-specific data, initialize to 0

type
  Window* = pointer ##  \
    ##  The type used to identify a window
    ##
    ##  See also:
    ##
    ##  ``createWindow()``
    ##
    ##  ``createWindowFrom()``
    ##
    ##  ``destroyWindow()``
    ##
    ##  ``getWindowData()``
    ##
    ##  ``getWindowFlags()``
    ##
    ##  ``getWindowGrab()``
    ##
    ##  ``getWindowPosition()``
    ##
    ##  ``getWindowSize()``
    ##
    ##  ``getWindowTitle()``
    ##
    ##  ``hideWindow()``
    ##
    ##  ``maximizeWindow()``
    ##
    ##  ``minimizeWindow()``
    ##
    ##  ``raiseWindow()``
    ##
    ##  ``restoreWindow()``
    ##
    ##  ``setWindowData()``
    ##
    ##  ``setWindowFullscreen()``
    ##
    ##  ``setWindowGrab()``
    ##
    ##  ``setWindowIcon()``
    ##
    ##  ``setWindowPosition()``
    ##
    ##  ``setWindowSize()``
    ##
    ##  ``setWindowBordered()``
    ##
    ##  ``setWindowResizable()``
    ##
    ##  ``setWindowTitle()``
    ##
    ##  ``showWindow()``

#type
#  WindowFlags* {.size: sizeof(cint).} = enum ##  \
#    ##  The flags on a window
#    ##
#    ##  See also:
#    ##
#    ##  ``getWindowFlags()``
#    WINDOW_FULLSCREEN     = 0x00000001, ## fullscreen window
#    WINDOW_OPENGL         = 0x00000002, ## window usable with OpenGL context
#    WINDOW_SHOWN          = 0x00000004, ## window is visible
#    WINDOW_HIDDEN         = 0x00000008, ## window is not visible
#    WINDOW_BORDERLESS     = 0x00000010, ## no window decoration
#    WINDOW_RESIZABLE      = 0x00000020, ## window can be resized
#    WINDOW_MINIMIZED      = 0x00000040, ## window is minimized
#    WINDOW_MAXIMIZED      = 0x00000080, ## window is maximized
#    WINDOW_INPUT_GRABBED  = 0x00000100, ## window has grabbed input focus
#    WINDOW_INPUT_FOCUS    = 0x00000200, ## window has input focus
#    WINDOW_MOUSE_FOCUS    = 0x00000400, ## window has mouse focus
#    WINDOW_FOREIGN        = 0x00000800, ## window not created by SDL
#    WINDOW_FULLSCREEN_DESKTOP = (WINDOW_FULLSCREEN.int or 0x00001000),
#    WINDOW_ALLOW_HIGHDPI  = 0x00002000

# WindowFlags
const
  WINDOW_FULLSCREEN*    = 0x00000001  ##  fullscreen window
  WINDOW_OPENGL*        = 0x00000002  ##  window usable with OpenGL context
  WINDOW_SHOWN*         = 0x00000004  ##  window is visible
  WINDOW_HIDDEN*        = 0x00000008  ##  window is not visible
  WINDOW_BORDERLESS*    = 0x00000010  ##  no window decoration
  WINDOW_RESIZABLE*     = 0x00000020  ##  window can be resized
  WINDOW_MINIMIZED*     = 0x00000040  ##  window is minimized
  WINDOW_MAXIMIZED*     = 0x00000080  ##  window is maximized
  WINDOW_INPUT_GRABBED* = 0x00000100  ##  window has grabbed input focus
  WINDOW_INPUT_FOCUS*   = 0x00000200  ##  window has input focus
  WINDOW_MOUSE_FOCUS*   = 0x00000400  ##  window has mouse focus
  WINDOW_FULLSCREEN_DESKTOP* = (WINDOW_FULLSCREEN or 0x00001000)
  WINDOW_FOREIGN*       = 0x00000800  ##  window not created by SDL
  WINDOW_ALLOW_HIGHDPI* = 0x00002000  ##  window should be created  \
    ##  in high-DPI mode if supported
  WINDOW_MOUSE_CAPTURE* = 0x00004000  ##  window has mouse captured \
    ##  (unrelated to `INPUT_GRABBED`)
  WINDOW_ALWAYS_ON_TOP* = 0x00008000  ##  window should always be above others
  WINDOW_SKIP_TASKBAR*  = 0x00010000  ## window should not be added \
    ##  to the taskbar
  WINDOW_UTILITY*       = 0x00020000  ## window should be treated as \
    ##  a utility window
  WINDOW_TOOLTIP*       = 0x00040000  ##  window should be treated as \
    ##  a tooltip
  WINDOW_POPUP_MENU*    = 0x00080000  ##  window should be treated as \
    ##  a popup menu

const
  WINDOWPOS_UNDEFINED_MASK* = 0x1FFF0000

template windowPosUndefinedDisplay*(x: untyped): untyped = ##  \
  ##  Used to indicate that you don't care what the window position is.
  (WINDOWPOS_UNDEFINED_MASK or (x))

const
  WINDOWPOS_UNDEFINED* = windowPosUndefinedDisplay(0)

template windowPosIsUndefined*(x: untyped): untyped =
  (((x) and 0xFFFF0000) == WINDOWPOS_UNDEFINED_MASK)


const
  WINDOWPOS_CENTERED_MASK* = 0x2FFF0000

template windowPosCenteredDisplay*(x: untyped): untyped = ##  \
  ##  Used to indicate that the window position should be centered.
  (WINDOWPOS_CENTERED_MASK or (x))

const
  WINDOWPOS_CENTERED* = windowPosCenteredDisplay(0)

template windowPosIsCentered*(x: untyped): untyped =
  (((x) and 0xFFFF0000) == WINDOWPOS_CENTERED_MASK)


type
  WindowEventID* {.size: sizeof(cint).} = enum ##  \
    ##  Event subtype for window events
    WINDOWEVENT_NONE,         ## Never used
    WINDOWEVENT_SHOWN,        ## Window has been shown
    WINDOWEVENT_HIDDEN,       ## Window has been hidden
    WINDOWEVENT_EXPOSED,      ## Window has been exposed and should be redrawn
    WINDOWEVENT_MOVED,        ## Window has been moved to data1, data2
    WINDOWEVENT_RESIZED,      ## Window has been resized to data1*data2
    WINDOWEVENT_SIZE_CHANGED, ##  \
      ##  The window size has changed, either as a result of an API call or
      ##  through the system or user changing the window size.
    WINDOWEVENT_MINIMIZED,    ## Window has been minimized
    WINDOWEVENT_MAXIMIZED,    ## Window has been maximized
    WINDOWEVENT_RESTORED,     ##  \
      ##  Window has been restored to normal size and position
    WINDOWEVENT_ENTER,        ## Window has gained mouse focus
    WINDOWEVENT_LEAVE,        ## Window has lost mouse focus
    WINDOWEVENT_FOCUS_GAINED, ## Window has gained keyboard focus
    WINDOWEVENT_FOCUS_LOST,   ## Window has lost keyboard focus
    WINDOWEVENT_CLOSE,        ##  \
      ##  The window manager requests that the window be closed
    WINDOWEVENT_TAKE_FOCUS,   ##  Window is being offered a focus \
      ##  (should ``setWindowInputFocus()`` on itself or a subwindow, or ignore)
    WINDOWEVENT_HIT_TEST      ##  Window had a hit test that wasn't \
      ##  `SDL_HITTEST_NORMAL`.


type
  GLContext* = pointer ##  An opaque handle to an OpenGL context.

type
  GLattr* {.size: sizeof(cint).} = enum ##  \
    ##  OpenGL configuration attributes
    GL_RED_SIZE, GL_GREEN_SIZE, GL_BLUE_SIZE, GL_ALPHA_SIZE, GL_BUFFER_SIZE,
    GL_DOUBLEBUFFER, GL_DEPTH_SIZE, GL_STENCIL_SIZE, GL_ACCUM_RED_SIZE,
    GL_ACCUM_GREEN_SIZE, GL_ACCUM_BLUE_SIZE, GL_ACCUM_ALPHA_SIZE, GL_STEREO,
    GL_MULTISAMPLEBUFFERS, GL_MULTISAMPLESAMPLES, GL_ACCELERATED_VISUAL,
    GL_RETAINED_BACKING, GL_CONTEXT_MAJOR_VERSION, GL_CONTEXT_MINOR_VERSION,
    GL_CONTEXT_EGL, GL_CONTEXT_FLAGS, GL_CONTEXT_PROFILE_MASK,
    GL_SHARE_WITH_CURRENT_CONTEXT, GL_FRAMEBUFFER_SRGB_CAPABLE,
    GL_CONTEXT_RELEASE_BEHAVIOR

  GLprofile* {.size: sizeof(cint).} = enum
    GL_CONTEXT_PROFILE_CORE = 0x00000001,
    GL_CONTEXT_PROFILE_COMPATIBILITY = 0x00000002,
    GL_CONTEXT_PROFILE_ES = 0x00000004

  GLcontextFlag* {.size: sizeof(cint).} = enum
    GL_CONTEXT_DEBUG_FLAG = 0x00000001,
    GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x00000002,
    GL_CONTEXT_ROBUST_ACCESS_FLAG = 0x00000004,
    GL_CONTEXT_RESET_ISOLATION_FLAG = 0x00000008

  GLcontextReleaseFlag* {.size: sizeof(cint).} = enum
    GL_CONTEXT_RELEASE_BEHAVIOR_NONE = 0x0000,
    GL_CONTEXT_RELEASE_BEHAVIOUR_FLUSH = 0x0001

# Procedure prototypes

proc getNumVideoDrivers*(): cint {.
    cdecl, importc: "SDL_GetNumVideoDrivers", dynlib: SDL2_LIB.}
  ##  Get the number of video drivers compiled into SDL.
  ##
  ##  See also:
  ##
  ##  ``getVideoDriver()``

proc getVideoDriver*(index: cint): cstring {.
    cdecl, importc: "SDL_GetVideoDriver", dynlib: SDL2_LIB.}
  ##  Get the name of a built in video driver.
  ##
  ##  ``Note:`` The video drivers are presented in the order in which they are
  ##  normally checked during initialization.
  ##
  ##  See also:
  ##
  ##  ``getNumVideoDrivers()``

proc videoInit*(driver_name: cstring): cint {.
    cdecl, importc: "SDL_VideoInit", dynlib: SDL2_LIB.}
  ##  Initialize the video subsystem, optionally specifying a video driver.
  ##
  ##  ``driver_name`` Initialize a specific driver by name, or `nil` for the
  ##  default video driver.
  ##
  ##  ``Return`` `0` on success, `-1` on error.
  ##
  ##  This procedure initializes the video subsystem; setting up a connection
  ##  to the window manager, etc, and determines the available display modes
  ##  and pixel formats, but does not initialize a window or graphics mode.
  ##
  ##  See also:
  ##
  ##  ``videoQuit()``

proc videoQuit*() {.
    cdecl, importc: "SDL_VideoQuit", dynlib: SDL2_LIB.}
  ##  Shuts down the video subsystem.
  ##
  ##  This procedure closes all windows, and restores the original video mode.
  ##
  ##  See also:
  ##
  ##  ``videoInit()``

proc getCurrentVideoDriver*(): cstring {.
    cdecl, importc: "SDL_GetCurrentVideoDriver", dynlib: SDL2_LIB.}
  ##  Returns the name of the currently initialized video driver.
  ##
  ##  ``Return`` The name of the current video driver or `nil` if no driver
  ##  has been initialized.
  ##
  ##  See also:
  ##
  ##  ``getNumVideoDrivers()``
  ##
  ##  ``getVideoDriver()``

proc getNumVideoDisplays*(): cint {.
    cdecl, importc: "SDL_GetNumVideoDisplays", dynlib: SDL2_LIB.}
  ##  Returns the number of available video displays.
  ##
  ##  See also:
  ##
  ##  ``getDisplayBounds()``

proc getDisplayName*(displayIndex: cint): cstring {.
    cdecl, importc: "SDL_GetDisplayName", dynlib: SDL2_LIB.}
  ##  Get the name of a display in UTF-8 encoding.
  ##
  ##  ``Return`` The name of a display, or `nil` for an invalid display index.
  ##
  ##  See also:
  ##
  ##  ``getNumVideoDisplays()``

proc getDisplayBounds*(displayIndex: cint; rect: ptr Rect): cint {.
    cdecl, importc: "SDL_GetDisplayBounds", dynlib: SDL2_LIB.}
  ##  Get the desktop area represented by a display,
  ##  with the primary display located at `0,0`.
  ##
  ##  ``Return`` `0` on success, or `-1` if the index is out of range.
  ##
  ##  See also:
  ##
  ##  ``getNumVideoDisplays()``

proc getDisplayDPI*(displayIndex: cint;
  ddpi: ptr cfloat; hdpi: ptr cfloat; vdpi: ptr cfloat): cint {.
    cdecl, importc: "SDL_GetDisplayDPI", dynlib: SDL2_LIB.}
  ##  Get the dots/pixels-per-inch for a display.
  ##
  ##  ``Note`` Diagonal, horizontal and vertical DPI can all be optionally
  ##  returned if the parameter is non-nil.
  ##
  ##  ``Return`` `0` on success, or `-1` if no DPI information is available
  ##  or the index is out of range.
  ##
  ##  See also:
  ##
  ##  ``getNumVideoDisplays()``

proc getDisplayUsableBounds*(displayIndex: cint; rect: ptr Rect): cint {.
    cdecl, importc: "SDL_GetDisplayUsableBounds", dynlib: SDL2_LIB.}
  ##  Get the usable desktop area represented by a display, with the
  ##  primary display located at 0,0
  ##
  ##  This is the same area as ``sdl.getDisplayBounds()`` reports, but with
  ##  portions reserved by the system removed. For example, on Mac OS X, this
  ##  subtracts the area occupied by the menu bar and dock.
  ##
  ##  Setting a window to be fullscreen generally bypasses these unusable areas,
  ##  so these are good guidelines for the maximum space available to a
  ##  non-fullscreen window.
  ##
  ##  ``Return`` `0` on success, or `-1` if the index is out of range.
  ##
  ##  See also:
  ##
  ##  ``sdl.getDisplayBounds()``
  ##
  ##  ``sdl.getNumVideoDisplays()``

proc getNumDisplayModes*(displayIndex: cint): cint {.
    cdecl, importc: "SDL_GetNumDisplayModes", dynlib: SDL2_LIB.}
  ##  Returns the number of available display modes.
  ##
  ##  See also:
  ##
  ##  ``getDisplayMode()``

proc getDisplayMode*(
    displayIndex: cint; modeIndex: cint; mode: ptr DisplayMode): cint {.
      cdecl, importc: "SDL_GetDisplayMode", dynlib: SDL2_LIB.}
  ##  Fill in information about a specific display mode.
  ##
  ##  ``Note:`` The display modes are sorted in this priority:
  ##  * bits per pixel -> more colors to fewer colors
  ##  * width -> largest to smallest
  ##  * height -> largest to smallest
  ##  * refresh rate -> highest to lowest
  ##
  ##  See also:
  ##
  ##  ``getNumDisplayModes()``

proc getDesktopDisplayMode*(displayIndex: cint; mode: ptr DisplayMode): cint {.
    cdecl, importc: "SDL_GetDesktopDisplayMode", dynlib: SDL2_LIB.}
  ##  Fill in information about the desktop display mode.

proc getCurrentDisplayMode*(displayIndex: cint; mode: ptr DisplayMode): cint {.
    cdecl, importc: "SDL_GetCurrentDisplayMode", dynlib: SDL2_LIB.}
  ##  Fill in information about the current display mode.

proc getClosestDisplayMode*(displayIndex: cint;
    mode: ptr DisplayMode; closest: ptr DisplayMode): ptr DisplayMode {.
      cdecl, importc: "SDL_GetClosestDisplayMode", dynlib: SDL2_LIB.}
  ##  Get the closest match to the requested display mode.
  ##
  ##  ``displayIndex`` The index of display from which mode should be queried.
  ##
  ##  ``mode`` The desired display mode.
  ##
  ##  ``closest`` A pointer to a display mode to be filled in with the closest
  ##  match of the available display modes.
  ##
  ##  ``Return`` The passed in value ``closest``, or `nil` if no matching
  ##  video mode was available.
  ##
  ##  The available display modes are scanned, and ``closest`` is filled
  ##  in with the closest mode matching the requested mode and returned.
  ##  The mode ``format`` and ``refresh_rate`` default to the desktop mode
  ##  if they are `0`.
  ##
  ##  The modes are scanned with size being first priority, ``format`` being
  ##  second priority, and finally checking the ``refresh_rate``.  If all the
  ##  available modes are too small, then `nil` is returned.
  ##
  ##  See also:
  ##
  ##  ``getNumDisplayModes()``
  ##
  ##  ``getDisplayMode()``

proc getWindowDisplayIndex*(window: Window): cint {.
    cdecl, importc: "SDL_GetWindowDisplayIndex", dynlib: SDL2_LIB.}
  ##  Get the display index associated with a window.
  ##
  ##  ``Return`` the display index of the display containing the center of the
  ##  window, or `-1` on error.

proc setWindowDisplayMode*(window: Window; mode: ptr DisplayMode): cint {.
    cdecl, importc: "SDL_SetWindowDisplayMode", dynlib: SDL2_LIB.}
  ##  Set the display mode used when a fullscreen window is visible.
  ##
  ##  By default the window's dimensions and the desktop format and
  ##  refresh rate are used.
  ##
  ##  ``window`` The window for which the display mode should be set.
  ##
  ##  ``mode`` The mode to use, or `nil` for the default mode.
  ##
  ##  ``Return`` `0` on success, or `-1` if setting the display mode failed.
  ##
  ##  See also:
  ##
  ##  ``getWindowDisplayMode()``
  ##
  ##  ``setWindowFullscreen()``

proc getWindowDisplayMode*(window: Window; mode: ptr DisplayMode): cint {.
    cdecl, importc: "SDL_GetWindowDisplayMode", dynlib: SDL2_LIB.}
  ##  Fill in information about the display mode used when a fullscreen
  ##  window is visible.
  ##
  ##  See also:
  ##
  ##  ``setWindowDisplayMode()``
  ##
  ##  ``setWindowFullscreen()``

proc getWindowPixelFormat*(window: Window): uint32 {.
    cdecl, importc: "SDL_GetWindowPixelFormat", dynlib: SDL2_LIB.}
  ##  Get the pixel format associated with the window.

proc createWindow*(title: cstring;
    x: cint; y: cint; w: cint; h: cint; flags: uint32): Window {.
      cdecl, importc: "SDL_CreateWindow", dynlib: SDL2_LIB.}
  ##  Create a window with the specified position, dimensions, and flags.
  ##
  ##  ``title`` The title of the window, in UTF-8 encoding.
  ##
  ##  ``x`` The x position of the window,
  ##  `WINDOWPOS_CENTERED`, or `WINDOWPOS_UNDEFINED`.
  ##
  ##  ``y`` The y position of the window,
  ##  `WINDOWPOS_CENTERED`, or `WINDOWPOS_UNDEFINED`.
  ##
  ##  ``w`` The width of the window, in screen coordinates.
  ##
  ##  ``h`` The height of the window, in screen coordinates.
  ##
  ##  ``flags`` The flags for the window, a mask of any of the following:
  ##  `WINDOW_FULLSCREEN`,
  ##  `WINDOW_OPENGL`,
  ##  `WINDOW_HIDDEN`,
  ##  `WINDOW_BORDERLESS`,
  ##  `WINDOW_RESIZABLE`,
  ##  `WINDOW_MAXIMIZED`,
  ##  `WINDOW_MINIMIZED`,
  ##  `WINDOW_INPUT_GRABBED`,
  ##  `WINDOW_ALLOW_HIGHDPI`.
  ##
  ##  ``Return`` the id of the window created,
  ##  or ``nil`` if window creation failed.
  ##
  ##  If the window is created with the `WINDOW_ALLOW_HIGHDPI` flag, its size
  ##  in pixels may differ from its size in screen coordinates on platforms with
  ##  high-DPI support (e.g. iOS and Mac OS X). Use ``getWindowSize()`` to query
  ##  the client area's size in screen coordinates, and ``glGetDrawableSize()``
  ##  or ``getRendererOutputSize()`` to query the drawable size in pixels.
  ##
  ##  See also:
  ##
  ##  ``destroyWindow()``

proc createWindowFrom*(data: pointer): Window {.
    cdecl, importc: "SDL_CreateWindowFrom", dynlib: SDL2_LIB.}
  ##  Create an SDL window from an existing native window.
  ##
  ##  ``data`` A pointer to driver-dependent window creation data.
  ##
  ##  ``Return`` the id of the window created,
  ##  or ``nil`` if window creation failed.
  ##
  ##  See also:
  ##
  ##  ``destroyWindow()``

proc getWindowID*(window: Window): uint32 {.
    cdecl, importc: "SDL_GetWindowID", dynlib: SDL2_LIB.}
  ##  Get the numeric ID of a window, for logging purposes.

proc getWindowFromID*(id: uint32): Window {.
    cdecl, importc: "SDL_GetWindowFromID", dynlib: SDL2_LIB.}
  ##  Get a window from a stored ID, or `nil` if it doesn't exist.

proc getWindowFlags*(window: Window): uint32 {.
    cdecl, importc: "SDL_GetWindowFlags", dynlib: SDL2_LIB.}
  ##  Get the window flags.

proc setWindowTitle*(window: Window; title: cstring) {.
    cdecl, importc: "SDL_SetWindowTitle", dynlib: SDL2_LIB.}
  ##  Set the title of a window, in UTF-8 format.
  ##
  ##  See also:
  ##
  ##  ``getWindowTitle()``

proc getWindowTitle*(window: Window): cstring {.
    cdecl, importc: "SDL_GetWindowTitle", dynlib: SDL2_LIB.}
  ##  Get the title of a window, in UTF-8 format.
  ##
  ##  See also:
  ##
  ##  ``setWindowTitle()``

proc setWindowIcon*(window: Window; icon: Surface) {.
    cdecl, importc: "SDL_SetWindowIcon", dynlib: SDL2_LIB.}
  ##  Set the icon for a window.
  ##
  ##  ``window`` The window for which the icon should be set.
  ##
  ##  ``icon`` The icon for the window.

proc setWindowData*(
    window: Window; name: cstring; userdata: pointer): pointer {.
      cdecl, importc: "SDL_SetWindowData", dynlib: SDL2_LIB.}
  ##  Associate an arbitrary named pointer with a window.
  ##
  ##  ``window`` The window to associate with the pointer.
  ##
  ##  ``name`` The name of the pointer.
  ##
  ##  ``userdata`` The associated pointer.
  ##
  ##  ``Return`` The previous value associated with ``name``.
  ##
  ##  ``Note:`` The name is case-sensitive.
  ##
  ##  See also:
  ##
  ##  ``getWindowData()``

proc getWindowData*(window: Window; name: cstring): pointer {.
    cdecl, importc: "SDL_GetWindowData", dynlib: SDL2_LIB.}
  ##  Retrieve the data pointer associated with a window.
  ##
  ##  ``window`` The window to query.
  ##
  ##  ``name`` The name of the pointer.
  ##
  ##  ``Return`` The value associated with ``name``.
  ##
  ##  See also:
  ##
  ##  ``setWindowData()``

proc setWindowPosition*(window: Window; x: cint; y: cint) {.
    cdecl, importc: "SDL_SetWindowPosition", dynlib: SDL2_LIB.}
  ##  Set the position of a window.
  ##
  ##  ``window`` The window to reposition.
  ##
  ##  ``x`` The x coordinate of the window in screen coordinates,
  ##  WINDOWPOS_CENTERED, or WINDOWPOS_UNDEFINED.
  ##
  ##  ``y`` The y coordinate of the window in screen coordinates,
  ##  WINDOWPOS_CENTERED, or WINDOWPOS_UNDEFINED.
  ##
  ##  ``Note:`` The window coordinate origin is the upper left of the display.
  ##
  ##  See also:
  ##
  ##  ``getWindowPosition()``

proc getWindowPosition*(window: Window; x: ptr cint; y: ptr cint) {.
    cdecl, importc: "SDL_GetWindowPosition", dynlib: SDL2_LIB.}
  ##  Get the position of a window.
  ##
  ##  ``window`` The window to query.
  ##
  ##  ``x`` Pointer to variable for storing the x position,
  ##  in screen coordinates. May be `nil`.
  ##
  ##  ``y`` Pointer to variable for storing the y position,
  ##  in screen coordinates. May be `nil`.
  ##
  ##  See also:
  ##
  ##  ``setWindowPosition()``

proc setWindowSize*(window: Window; w: cint; h: cint) {.
    cdecl, importc: "SDL_SetWindowSize", dynlib: SDL2_LIB.}
  ##  Set the size of a window's client area.
  ##
  ##  ``window`` The window to resize.
  ##
  ##  ``w`` The width of the window, in screen coordinates. Must be `>0`.
  ##
  ##  ``h`` The height of the window, in screen coordinates. Must be `>0`.
  ##
  ##  ``Note:`` You can't change the size of a fullscreen window,
  ##  it automatically matches the size of the display mode.
  ##
  ##  The window size in screen coordinates may differ from the size in pixels,
  ##  if the window was created with `WINDOW_ALLOW_HIGHDPI` on a platform with
  ##  high-dpi support (e.g. iOS or OS X). Use ``getDrawableSize()`` or
  ##  ``getRendererOutputSize()`` to get the real client area size in pixels.
  ##
  ##  See also:
  ##
  ##  ``getWindowSize()``

proc getWindowSize*(window: Window; w: ptr cint; h: ptr cint) {.
    cdecl, importc: "SDL_GetWindowSize", dynlib: SDL2_LIB.}
  ##  Get the size of a window's client area.
  ##
  ##  ``window`` The window to query.
  ##
  ##  ``w`` Pointer to variable for storing the width, in screen coordinates.
  ##  May be `nil`.
  ##
  ##  ``h`` Pointer to variable for storing the height, in screen coordinates.
  ##  May be `nil`.
  ##
  ##  The window size in screen coordinates may differ from the size in pixels,
  ##  if the window was created with `WINDOW_ALLOW_HIGHDPI` on a platform with
  ##  high-dpi support (e.g. iOS or OS X). Use ``glGetDrawableSize()`` or
  ##  ``getRendererOutputSize()`` to get the real client area size in pixels.
  ##
  ##  See also:
  ##
  ##  ``setWindowSize()``

proc getWindowBordersSize*(window: Window;
  top: ptr cint; left: ptr cint; bottom: ptr cint; right: ptr cint): int {.
    cdecl, importc: "SDL_GetWindowBordersSize", dynlib: SDL2_LIB.}
  ##  Get the size of a window's borders (decorations) around the client area.
  ##
  ##  ``window`` The window to query.
  ##
  ##  ``top`` Pointer to variable for storing the size of the top border.
  ##    ``nil`` is permitted.
  ##
  ##  ``left`` Pointer to variable for storing the size of the left border.
  ##    ``nil`` is permitted.
  ##
  ##  ``bottom`` Pointer to variable for storing the size of the bottom border.
  ##    ``nil`` is permitted.
  ##
  ##  ``right`` Pointer to variable for storing the size of the right border.
  ##    ``nil`` is permitted.
  ##
  ##  ``Return`` `0` on success,
  ##  or `-1` if getting this information is not supported.
  ##
  ##  ``Note:`` If this function fails (returns `-1`), the size values will be
  ##  initialized to `0`, `0`, `0`, `0` (if a non-nil pointer is provided), as
  ##  if the window in question was borderless.

proc setWindowMinimumSize*(window: Window; min_w: cint; min_h: cint) {.
    cdecl, importc: "SDL_SetWindowMinimumSize", dynlib: SDL2_LIB.}
  ##  Set the minimum size of a window's client area.
  ##
  ##  ``window`` The window to set a new minimum size.
  ##
  ##  ``min_w`` The minimum width of the window, must be `>0`.
  ##
  ##  ``min_h`` The minimum height of the window, must be `>0`.
  ##
  ##  ``Note:`` You can't change the minimum size of a fullscreen window,
  ##  it automatically matches the size of the display mode.
  ##
  ##  See also:
  ##
  ##  ``getWindowMinimumSize()``
  ##
  ##  ``setWindowMaximumSize()``

proc getWindowMinimumSize*(window: Window; w: ptr cint; h: ptr cint) {.
    cdecl, importc: "SDL_GetWindowMinimumSize", dynlib: SDL2_LIB.}
  ##  Get the minimum size of a window's client area.
  ##
  ##  ``window`` The window to query.
  ##
  ##  ``w`` Pointer to variable for storing the minimum width, may be `nil`.
  ##
  ##  ``h`` Pointer to variable for storing the minimum height, may be `nil`.
  ##
  ##  See also:
  ##
  ##  ``getWindowMaximumSize()``
  ##
  ##  ``setWindowMinimumSize()``

proc setWindowMaximumSize*(window: Window; max_w: cint; max_h: cint) {.
    cdecl, importc: "SDL_SetWindowMaximumSize", dynlib: SDL2_LIB.}
  ##  Set the maximum size of a window's client area.
  ##
  ##  ``window`` The window to set a new maximum size.
  ##
  ##  ``max_w`` The maximum width of the window, must be `>0`.
  ##
  ##  ``max_h`` The maximum height of the window, must be `>0`.
  ##
  ##  ``Note:`` You can't change the maximum size of a fullscreen window,
  ##  it automatically matches the size of the display mode.
  ##
  ##  See also:
  ##
  ##  ``getWindowMaximumSize()``
  ##
  ##  ``setWindowMinimumSize()``

proc getWindowMaximumSize*(window: Window; w: ptr cint; h: ptr cint) {.
    cdecl, importc: "SDL_GetWindowMaximumSize", dynlib: SDL2_LIB.}
  ##  Get the maximum size of a window's client area.
  ##
  ##  ``window`` The window to query.
  ##
  ##  ``w`` Pointer to variable for storing the maximum width, may be `nil`.
  ##
  ##  ``h`` Pointer to variable for storing the maximum height, may be `nil`.
  ##
  ##  See also:
  ##
  ##  ``getWindowMinimumSize()``
  ##
  ##  ``setWindowMaximumSize()``

proc setWindowBordered*(window: Window; bordered: bool) {.
    cdecl, importc: "SDL_SetWindowBordered", dynlib: SDL2_LIB.}
  ##  Set the border state of a window.
  ##
  ##  This will add or remove the window's `WINDOW_BORDERLESS` flag and
  ##  add or remove the border from the actual window. This is a no-op if the
  ##  window's border already matches the requested state.
  ##
  ##  ``window`` The window of which to change the border state.
  ##
  ##  ``bordered`` `false` to remove border, `true` to add border.
  ##
  ##  ``Note:`` You can't change the border state of a fullscreen window.
  ##
  ##  See also:
  ##
  ##  ``getWindowFlags()``


proc setWindowResizable*(window: Window; resizable: bool) {.
    cdecl, importc: "SDL_SetWindowResizable", dynlib: SDL2_LIB.}
  ##  Set the user-resizable state of a window.
  ##
  ##  This will add or remove the window's `WINDOW_RESIZABLE` flag and
  ##  allow/disallow user resizing of the window. This is a no-op if the
  ##  window's resizable state already matches the requested state.
  ##
  ##  ``window`` The window of which to change the resizable state.
  ##
  ##  ``resizable`` `true` to allow resizing, `false` to disallow.
  ##
  ##  ``Note:`` You can't change the resizable state of a fullscreen window.
  ##
  ##  See also:
  ##
  ##  ``getWindowFlags()``

proc showWindow*(window: Window) {.
    cdecl, importc: "SDL_ShowWindow", dynlib: SDL2_LIB.}
  ##  Show a window.
  ##
  ##  See also:
  ##
  ##  ``hideWindow()``

proc hideWindow*(window: Window) {.
    cdecl, importc: "SDL_HideWindow", dynlib: SDL2_LIB.}
  ##  Hide a window.
  ##
  ##  See also:
  ##
  ##  ``showWindow()``

proc raiseWindow*(window: Window) {.
    cdecl, importc: "SDL_RaiseWindow", dynlib: SDL2_LIB.}
  ##  Raise a window above other windows and set the input focus.

proc maximizeWindow*(window: Window) {.
    cdecl, importc: "SDL_MaximizeWindow", dynlib: SDL2_LIB.}
  ##  Make a window as large as possible.
  ##
  ##  See also:
  ##
  ##  ``restoreWindow()``

proc minimizeWindow*(window: Window) {.
    cdecl, importc: "SDL_MinimizeWindow", dynlib: SDL2_LIB.}
  ##  Minimize a window to an iconic representation.
  ##
  ##  See also:
  ##
  ##  ``restoreWindow()``

proc restoreWindow*(window: Window) {.
    cdecl, importc: "SDL_RestoreWindow", dynlib: SDL2_LIB.}
  ##  Restore the size and position of a minimized or maximized window.
  ##
  ##  See also:
  ##
  ##  ``maximizeWindow()``
  ##
  ##  ``minimizeWindow()``

proc setWindowFullscreen*(window: Window; flags: uint32): cint {.
    cdecl, importc: "SDL_SetWindowFullscreen", dynlib: SDL2_LIB.}
  ##  Set a window's fullscreen state.
  ##
  ##  ``Return`` `0` on success, or `-1` if setting the display mode failed.
  ##
  ##  See also:
  ##
  ##  ``setWindowDisplayMode()``
  ##
  ##  ``getWindowDisplayMode()``

proc getWindowSurface*(window: Window): Surface {.
    cdecl, importc: "SDL_GetWindowSurface", dynlib: SDL2_LIB.}
  ##  Get the SDL surface associated with the window.
  ##
  ##  ``Return`` The window's framebuffer surface, or `nil` on error.
  ##
  ##  A new surface will be created with the optimal format for the window,
  ##  if necessary. This surface will be freed when the window is destroyed.
  ##
  ##  ``Note:`` You may not combine this with 3D or the rendering API
  ##  on this window.
  ##
  ##  See also:
  ##
  ##  ``updateWindowSurface()``
  ##
  ##  ``updateWindowSurfaceRects()``

proc updateWindowSurface*(window: Window): cint {.
    cdecl, importc: "SDL_UpdateWindowSurface", dynlib: SDL2_LIB.}
  ##  Copy the window surface to the screen.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``getWindowSurface()``
  ##
  ##  ``updateWindowSurfaceRects()``

proc updateWindowSurfaceRects*(
    window: Window; rects: ptr Rect; numrects: cint): cint {.
      cdecl, importc: "SDL_UpdateWindowSurfaceRects", dynlib: SDL2_LIB.}
  ##  Copy a number of rectangles on the window surface to the screen.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``getWindowSurface()``
  ##
  ##  ``updateWindowSurface()``

proc setWindowGrab*(window: Window; grabbed: bool) {.
    cdecl, importc: "SDL_SetWindowGrab", dynlib: SDL2_LIB.}
  ##  Set a window's input grab mode.
  ##
  ##  ``window`` The window for which the input grab mode should be set.
  ##  ``grabbed`` This is `true` to grab input, and `false` to release input.
  ##
  ##  If the caller enables a grab while another window is currently grabbed,
  ##  the other window loses its grab in favor of the caller's window.
  ##
  ##  See also:
  ##
  ##  ``getWindowGrab()``

proc getWindowGrab*(window: Window): bool {.
    cdecl, importc: "SDL_GetWindowGrab", dynlib: SDL2_LIB.}
  ##  Get a window's input grab mode.
  ##
  ##  ``Return`` `true` if input is grabbed, and `false` otherwise.
  ##
  ##  See also:
  ##
  ##  ``setWindowGrab()``

proc getGrabbedWindow*(): Window {.
    cdecl, importc: "SDL_GetGrabbedWindow", dynlib: SDL2_LIB.}
  ##  Get the window that currently has an input grab enabled.
  ##
  ##  ``Return`` the window if input is grabbed, and `nil` otherwise.
  ##
  ##  See also:
  ##
  ##  ``setWindowGrab()``

proc setWindowBrightness*(window: Window; brightness: cfloat): cint {.
    cdecl, importc: "SDL_SetWindowBrightness", dynlib: SDL2_LIB.}
  ##  Set the brightness (gamma correction) for a window.
  ##
  ##  ``Return`` `0` on success,
  ##  or `-1` if setting the brightness isn't supported.
  ##
  ##  See also:
  ##
  ##  ``getWindowBrightness()``
  ##
  ##  ``setWindowGammaRamp()``

proc getWindowBrightness*(window: Window): cfloat {.
    cdecl, importc: "SDL_GetWindowBrightness", dynlib: SDL2_LIB.}
  ##  Get the brightness (gamma correction) for a window.
  ##
  ##  ``Return`` The last brightness value passed to ``setWindowBrightness()``
  ##
  ##  See also:
  ##
  ##  ``setWindowBrightness()``

proc setWindowOpacity*(window: Window; opacity: cfloat): cint {.
    cdecl, importc: "SDL_SetWindowOpacity", dynlib: SDL2_LIB.}
  ##  Set the opacity for a window.
  ##
  ##  ``window`` The window which will be made transparent or opaque.
  ##
  ##  ``opacity`` Opacity (`0.0f` - transparent, `1.0f` - opaque).
  ##    This will be clamped internally between `0.0f` and `1.0f`.
  ##
  ##  ``Return`` `0` on success, or `-1` if setting the opacity isn't supported.
  ##
  ##  See also:
  ##
  ##  ``getWindowOpacity()``

proc getWindowOpacity*(window: Window; out_opacity: ptr cfloat): cint {.
    cdecl, importc: "SDL_GetWindowOpacity", dynlib: SDL2_LIB.}
  ##  Get the opacity of a window.
  ##
  ##  If transparency isn't supported on this platform, opacity will be reported
  ##  as `1.0f` without error.
  ##
  ##  ``window`` The window in question.
  ##  ``out_opacity`` Opacity (`0.0f` - transparent, `1.0f` - opaque).
  ##
  ##  ``Return`` `0` on success, or `-1` on error (invalid window, etc).
  ##
  ##  See also:
  ##
  ##  ``setWindowOpacity()``

proc setWindowModalFor*(modal_window: Window; parent_window: Window): cint {.
    cdecl, importc: "SDL_SetWindowModalFor", dynlib: SDL2_LIB.}
  ##  Sets the window as a modal for another window.
  ##  (TODO: reconsider this function and/or its name)
  ##
  ##  ``modal_window`` The window that should be modal.
  ##
  ##  ``parent_window`` The parent window.
  ##
  ##  ``Return`` `0` on success, or `-1` otherwise.

proc setWindowInputFocus*(window: Window): cint {.
    cdecl, importc: "SDL_SetWindowInputFocus", dynlib: SDL2_LIB.}
  ##  Explicitly sets input focus to the window.
  ##
  ##  You almost certainly want ``sdl.raiseWindow()`` instead of this function.
  ##  Use this with caution, as you might give focus to a window that's
  ##  completely obscured by other windows.
  ##
  ##  ``window`` The window that should get the input focus
  ##
  ##  ``Return`` `0` on success, or `-1` otherwise.
  ##
  ##  See also:
  ##
  ##  ``raiseWindow()``

proc setWindowGammaRamp*(window: Window;
    red: ptr uint16; green: ptr uint16; blue: ptr uint16): cint {.
      cdecl, importc: "SDL_SetWindowGammaRamp", dynlib: SDL2_LIB.}
  ##  Set the gamma ramp for a window.
  ##
  ##  ``window`` The window for which the gamma ramp should be set.
  ##
  ##  ``red`` The translation table for the red channel, or `nil`.
  ##
  ##  ``green`` The translation table for the green channel, or `nil`.
  ##
  ##  ``blue`` The translation table for the blue channel, or `nil`.
  ##
  ##  ``Return`` `0` on success, or `-1` if gamma ramps are unsupported.
  ##
  ##  Set the gamma translation table for the red, green, and blue channels
  ##  of the video hardware.  Each table is an array of 256 16-bit quantities,
  ##  representing a mapping between the input and output for that channel.
  ##  The input is the index into the array, and the output is the 16-bit
  ##  gamma value at that index, scaled to the output color precision.
  ##
  ##  See also:
  ##
  ##  ``getWindowGammaRamp()``

proc getWindowGammaRamp*(window: Window;
    red: ptr uint16; green: ptr uint16; blue: ptr uint16): cint {.
      cdecl, importc: "SDL_GetWindowGammaRamp", dynlib: SDL2_LIB.}
  ##  Get the gamma ramp for a window.
  ##
  ##  ``window`` The window from which the gamma ramp should be queried.
  ##
  ##  ``red`` A pointer to a 256 element array of 16-bit quantities to hold
  ##  the translation table for the red channel, or `nil`.
  ##
  ##  ``green`` A pointer to a 256 element array of 16-bit quantities to hold
  ##  the translation table for the green channel, or `nil`.
  ##
  ##  ``blue`` A pointer to a 256 element array of 16-bit quantities to hold
  ##  the translation table for the blue channel, or `nil`.
  ##
  ##  ``Return`` `0` on success, or `-1` if gamma ramps are unsupported.
  ##
  ##  See also:
  ##
  ##  ``setWindowGammaRamp()``

type
  HitTestResult* {.size: sizeof(cint).} = enum  ##  \
    ##  Possible return values from the ``HitTest`` callback.
    HITTEST_NORMAL,           ##  Region is normal. No special properties.
    HITTEST_DRAGGABLE,        ##  Region can drag entire window.
    HITTEST_RESIZE_TOPLEFT,
    HITTEST_RESIZE_TOP,
    HITTEST_RESIZE_TOPRIGHT,
    HITTEST_RESIZE_RIGHT,
    HITTEST_RESIZE_BOTTOMRIGHT,
    HITTEST_RESIZE_BOTTOM,
    HITTEST_RESIZE_BOTTOMLEFT,
    HITTEST_RESIZE_LEFT

type
  HitTest* = proc (
    win: Window; area: ptr Point; data: pointer): HitTestResult {.
      cdecl.} ##  \
      ##  Callback used for hit-testing.
      ##
      ##  See also:
      ##
      ##  ``setWindowHitTest()``

proc setWindowHitTest*(
  window: Window; callback: HitTest; callbackData: pointer): cint {.
    cdecl, importc: "SDL_SetWindowHitTest", dynlib: SDL2_LIB.}
  ##  Provide a callback that decides if a window region has special properties.
  ##
  ##  Normally windows are dragged and resized by decorations provided by the
  ##  system window manager (a title bar, borders, etc), but for some apps, it
  ##  makes sense to drag them from somewhere else inside the window itself; for
  ##  example, one might have a borderless window that wants to be draggable
  ##  from any part, or simulate its own title bar, etc.
  ##
  ##  This procedure lets the app provide a callback that designates pieces of
  ##  a given window as special. This callback is run during event processing
  ##  if we need to tell the OS to treat a region of the window specially; the
  ##  use of this callback is known as "hit testing".
  ##
  ##  Mouse input may not be delivered to your application if it is within
  ##  a special area; the OS will often apply that input to moving the window or
  ##  resizing the window and not deliver it to the application.
  ##
  ##  Specifying `nil` for a callback disables hit-testing. Hit-testing is
  ##  disabled by default.
  ##
  ##  Platforms that don't support this functionality will return `-1`
  ##  unconditionally, even if you're attempting to disable hit-testing.
  ##
  ##  Your callback may fire at any time, and its firing does not indicate any
  ##  specific behavior (for example, on Windows, this certainly might fire
  ##  when the OS is deciding whether to drag your window, but it fires for lots
  ##  of other reasons, too, some unrelated to anything you probably care about
  ##  _and when the mouse isn't actually at the location it is testing_).
  ##  Since this can fire at any time, you should try to keep your callback
  ##  efficient, devoid of allocations, etc.
  ##
  ##  ``window`` The window to set hit-testing on.
  ##
  ##  ``callback`` The callback to call when doing a hit-test.
  ##
  ##  ``callback_data`` An app-defined void pointer passed to the callback.
  ##
  ##  ``Return`` `0` on success, `-1` on error (including unsupported).

proc destroyWindow*(window: Window) {.
    cdecl, importc: "SDL_DestroyWindow", dynlib: SDL2_LIB.}
  ##  Destroy a window.

proc isScreenSaverEnabled*(): bool {.
    cdecl, importc: "SDL_IsScreenSaverEnabled", dynlib: SDL2_LIB.}
  ##  Returns whether the screensaver is currently enabled (default off).
  ##
  ##  See also:
  ##
  ##  ``enableScreenSaver()``
  ##
  ##  ``disableScreenSaver()``

proc enableScreenSaver*() {.
    cdecl, importc: "SDL_EnableScreenSaver", dynlib: SDL2_LIB.}
  ##  Allow the screen to be blanked by a screensaver.
  ##
  ##  See also:
  ##
  ##  ``isScreenSaverEnabled()``
  ##
  ##  ``disableScreenSaver()``

proc disableScreenSaver*() {.
    cdecl, importc: "SDL_DisableScreenSaver", dynlib: SDL2_LIB.}
  ##  Prevent the screen from being blanked by a screensaver.
  ##
  ##  See also:
  ##
  ##  ``isScreenSaverEnabled()``
  ##
  ##  ``enableScreenSaver()``

# OpenGL support procedures

proc glLoadLibrary*(path: cstring): cint {.
    cdecl, importc: "SDL_GL_LoadLibrary", dynlib: SDL2_LIB.}
  ##  Dynamically load an OpenGL library.
  ##
  ##  ``path`` The platform dependent OpenGL library name,
  ##  or `nil` to open the default OpenGL library.
  ##
  ##  ``Return`` `0` on success, or `-1` if the library couldn't be loaded.
  ##
  ##  This should be done after initializing the video driver, but before
  ##  creating any OpenGL windows.  If no OpenGL library is loaded, the default
  ##  library will be loaded upon creation of the first OpenGL window.
  ##
  ##  ``Note:`` If you do this, you need to retrieve
  ##  all of the GL procedures used in your program
  ##  from the dynamic library using ``glGetProcAddress()``.
  ##
  ##  See also:
  ##
  ##  ``glGetProcAddress()``
  ##
  ##  ``glUnloadLibrary()``

proc glGetProcAddress*(glproc: cstring): pointer {.
    cdecl, importc: "SDL_GL_GetProcAddress", dynlib: SDL2_LIB.}
  ##  Get the address of an OpenGL procedure.

proc glUnloadLibrary*() {.
    cdecl, importc: "SDL_GL_UnloadLibrary", dynlib: SDL2_LIB.}
  ##  Unload the OpenGL library previously loaded by ``glLoadLibrary()``.
  ##
  ##  See also:
  ##
  ##  ``glLoadLibrary()``

proc glExtensionSupported*(extension: cstring): bool {.
    cdecl, importc: "SDL_GL_ExtensionSupported", dynlib: SDL2_LIB.}
  ##  ``Return`` `true` if an OpenGL extension is supported
  ##  for the current context.

proc glResetAttributes*() {.
    cdecl, importc: "SDL_GL_ResetAttributes", dynlib: SDL2_LIB.}
  ##  Reset all previously set OpenGL context attributes
  ##  to their default values.

proc glSetAttribute*(attr: GLattr; value: cint): cint {.
    cdecl, importc: "SDL_GL_SetAttribute", dynlib: SDL2_LIB.}
  ##  Set an OpenGL window attribute before window creation.

proc glGetAttribute*(attr: GLattr; value: ptr cint): cint {.
    cdecl, importc: "SDL_GL_GetAttribute", dynlib: SDL2_LIB.}
  ##  Get the actual value for an attribute from the current context.

proc glCreateContext*(window: Window): GLContext {.
    cdecl, importc: "SDL_GL_CreateContext", dynlib: SDL2_LIB.}
  ##  Create an OpenGL context for use with an OpenGL window,
  ##  and make it current.
  ##
  ##  See also:
  ##
  ##  ``glDeleteContext()``

proc glMakeCurrent*(window: Window; context: GLContext): cint {.
    cdecl, importc: "SDL_GL_MakeCurrent", dynlib: SDL2_LIB.}
  ##  Set up an OpenGL context for rendering into an OpenGL window.
  ##
  ##  ``Note:`` The context must have been created with a compatible window.

proc glGetCurrentWindow*(): Window {.
    cdecl, importc: "SDL_GL_GetCurrentWindow", dynlib: SDL2_LIB.}
  ##  Get the currently active OpenGL window.

proc glGetCurrentContext*(): GLContext {.
    cdecl, importc: "SDL_GL_GetCurrentContext", dynlib: SDL2_LIB.}
  ##  Get the currently active OpenGL context.

proc glGetDrawableSize*(window: Window; w: ptr cint; h: ptr cint) {.
    cdecl, importc: "SDL_GL_GetDrawableSize", dynlib: SDL2_LIB.}
  ##  Get the size of a window's underlying drawable in pixels
  ##  (for use with glViewport).
  ##
  ##  ``window`` Window from which the drawable size should be queried.
  ##
  ##  ``w`` Pointer to variable for storing the width in pixels, may be `nil`.
  ##
  ##  ``h`` Pointer to variable for storing the height in pixels, may be `nil`.
  ##
  ##  This may differ from ``getWindowSize()`` if we're rendering to a high-DPI
  ##  drawable, i.e. the window was created with `WINDOW_ALLOW_HIGHDPI` on a
  ##  platform with high-DPI support (Apple calls this "Retina"), and not
  ##  disabled by the `HINT_VIDEO_HIGHDPI_DISABLED` hint.
  ##
  ##  See also:
  ##
  ##  ``getWindowSize()``
  ##
  ##  ``createWindow()``

proc glSetSwapInterval*(interval: cint): cint {.
    cdecl, importc: "SDL_GL_SetSwapInterval", dynlib: SDL2_LIB.}
  ##  Set the swap interval for the current OpenGL context.
  ##
  ##  ``interval`` `0` for immediate updates, `1` for updates synchronized
  ##  with the vertical retrace. If the system supports it, you may specify
  ##  `-1` to allow late swaps to happen immediately instead of waiting for
  ##  the next retrace.
  ##
  ##  ``Return`` `0` on success, or `-1` if setting the swap interval
  ##  is not supported.
  ##
  ##  See also:
  ##
  ##  ``glGetSwapInterval()``

proc glGetSwapInterval*(): cint {.
    cdecl, importc: "SDL_GL_GetSwapInterval", dynlib: SDL2_LIB.}
  ##  Get the swap interval for the current OpenGL context.
  ##
  ##  ``Return`` `0` if there is no vertical retrace synchronization,
  ##  `1` if the buffer swap is synchronized with the vertical retrace, and
  ##  `-1` if late swaps happen immediately instead of waiting for the next
  ##  retrace. If the system can't determine the swap interval, or there isn't
  ##  a valid current context, this will return `0` as a safe default.
  ##
  ##  See also:
  ##
  ##  ``glSetSwapInterval()``

proc glSwapWindow*(window: Window) {.
    cdecl, importc: "SDL_GL_SwapWindow", dynlib: SDL2_LIB.}
  ## Swap the OpenGL buffers for a window, if double-buffering is supported.

proc glDeleteContext*(context: GLContext) {.
    cdecl, importc: "SDL_GL_DeleteContext", dynlib: SDL2_LIB.}
  ##  Delete an OpenGL context.
  ##
  ##  See also:
  ##
  ##  ``glCreateContext()``
