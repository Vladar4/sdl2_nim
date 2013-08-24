#
# Simple DirectMedia Layer
# Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
#

#
#  Header file for SDL video functions.
#


type
  TDisplayMode*{.bycopy.} = object
    ## The structure that defines a display mode
    ##
    ## See also: getNumDisplayModes(),
    ## getDisplayMode(),
    ## getDesktopDisplayMode(), 
    ## getCurrentDisplayMode(), 
    ## getClosestDisplayMode(), 
    ## setWindowDisplayMode(), 
    ## getWindowDisplayMode()
    format*: Uint32 ## pixel format
    w*: int ## width
    h*: int ## height
    refresh_rate*: int ## refresh rate (or zero for unspecified)
    driverdata*: pointer ## driver-specific data, initialize to 0


type
  PWindow* = pointer
  ## The type used to identify a window
  ##
  ## See also: createWindow(), 
  ## createWindowFrom(), 
  ## destroyWindow(), 
  ## getWindowData(), 
  ## getWindowFlags(), 
  ## getWindowGrab(), 
  ## getWindowPosition(), 
  ## getWindowSize(), 
  ## getWindowTitle(), 
  ## hideWindow(), 
  ## maximizeWindow(), 
  ## minimizeWindow(), 
  ## raiseWindow(), 
  ## restoreWindow(), 
  ## setWindowData(), 
  ## setWindowFullscreen(), 
  ## setWindowGrab(), 
  ## setWindowIcon(), 
  ## setWindowPosition(), 
  ## setWindowSize(), 
  ## setWindowBordered(), 
  ## setWindowTitle(), 
  ## showWindow()


const
  # The flags on a window
  WINDOW_FULLSCREEN* = 0x00000001 ## fullscreen window
  WINDOW_OPENGL* = 0x00000002 ## window usable with OpenGL context
  WINDOW_SHOWN* = 0x00000004 ## window is visible
  WINDOW_HIDDEN* = 0x00000008 ## window is not visible
  WINDOW_BORDERLESS* = 0x00000010 ## no window decoration
  WINDOW_RESIZABLE* = 0x00000020 ## window can be resized
  WINDOW_MINIMIZED* = 0x00000040 ## window is minimized
  WINDOW_MAXIMIZED* = 0x00000080 ## window is maximized
  WINDOW_INPUT_GRABBED* = 0x00000100 ## window has grabbed input focus
  WINDOW_INPUT_FOCUS* = 0x00000200 ## window has input focus
  WINDOW_MOUSE_FOCUS* = 0x00000400 ## window has mouse focus
  WINDOW_FOREIGN* = 0x00000800 ## window not created by SDL
  WINDOW_FULLSCREEN_DESKTOP* = 0x00001001


  WINDOWPOS_UNDEFINED_MASK* = 0x1FFF0000 ## Used to indicate that you don't care what the window position is.


template WINDOWPOS_UNDEFINED_DISPLAY*(X): expr =
  WINDOWPOS_UNDEFINED_MASK or (X)

const
  WINDOWPOS_UNDEFINED* = WINDOWPOS_UNDEFINED_DISPLAY(0)

template WINDOWPOS_ISUNDEFINED*(X): bool =
  (((X) and 0xFFFF0000) == WINDOWPOS_UNDEFINED_MASK)


const
  WINDOWPOS_CENTERED_MASK* = 0x2FFF0000 ##  Used to indicate that the window position should be centered.

template WINDOWPOS_CENTERED_DISPLAY*(X): expr =
  (WINDOWPOS_CENTERED_MASK or (X))

const
  WINDOWPOS_CENTERED* = WINDOWPOS_CENTERED_DISPLAY(0)

template WINDOWPOS_ISCENTERED*(X): bool =
  (((X) and 0xFFFF0000) == SDL_WINDOWPOS_CENTERED_MASK)

type
  TWindowEventID* = enum ## Event subtype for window events
    WINDOWEVENT_NONE,           ## Never used
    WINDOWEVENT_SHOWN,          ## Window has been shown
    WINDOWEVENT_HIDDEN,         ## Window has been hidden
    WINDOWEVENT_EXPOSED,        ## Window has been exposed and should be redrawn
    WINDOWEVENT_MOVED,          ## Window has been moved to data1, data2
    WINDOWEVENT_RESIZED,        ## Window has been resized to data1xdata2
    WINDOWEVENT_SIZE_CHANGED,   ## The window size has changed, either as a result of an API call or through the system or user changing the window size.
    WINDOWEVENT_MINIMIZED,      ## Window has been minimized
    WINDOWEVENT_MAXIMIZED,      ## Window has been maximized
    WINDOWEVENT_RESTORED,       ## Window has been restored to normal size and position
    WINDOWEVENT_ENTER,          ## Window has gained mouse focus
    WINDOWEVENT_LEAVE,          ## Window has lost mouse focus
    WINDOWEVENT_FOCUS_GAINED,   ## Window has gained keyboard focus
    WINDOWEVENT_FOCUS_LOST,     ## Window has lost keyboard focus
    WINDOWEVENT_CLOSE           ## The window manager requests that the window be closed


type
  PGLContext* = pointer ## An opaque handle to an OpenGL context.

type
  TGLattr* = enum ## OpenGL configuration attributes
    GL_RED_SIZE,
    GL_GREEN_SIZE,
    GL_BLUE_SIZE,
    GL_ALPHA_SIZE,
    GL_BUFFER_SIZE,
    GL_DOUBLEBUFFER,
    GL_DEPTH_SIZE,
    GL_STENCIL_SIZE,
    GL_ACCUM_RED_SIZE,
    GL_ACCUM_GREEN_SIZE,
    GL_ACCUM_BLUE_SIZE,
    GL_ACCUM_ALPHA_SIZE,
    GL_STEREO,
    GL_MULTISAMPLEBUFFERS,
    GL_MULTISAMPLESAMPLES,
    GL_ACCELERATED_VISUAL,
    GL_RETAINED_BACKING,
    GL_CONTEXT_MAJOR_VERSION,
    GL_CONTEXT_MINOR_VERSION,
    GL_CONTEXT_EGL,
    GL_CONTEXT_FLAGS,
    GL_CONTEXT_PROFILE_MASK,
    GL_SHARE_WITH_CURRENT_CONTEXT

  TGLprofile* = enum
    GL_CONTEXT_PROFILE_CORE           = 0x0001,
    GL_CONTEXT_PROFILE_COMPATIBILITY  = 0x0002,
    GL_CONTEXT_PROFILE_ES             = 0x0004

  TGLcontextFlag* = enum
    GL_CONTEXT_DEBUG_FLAG              = 0x0001,
    GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002,
    GL_CONTEXT_ROBUST_ACCESS_FLAG      = 0x0004,
    GL_CONTEXT_RESET_ISOLATION_FLAG    = 0x0008


# Function prototypes


proc getNumVideoDrivers*(): int {.cdecl, importc: "SDL_GetNumVideoDrivers", dynlib: LibName.}
  ## Get the number of video drivers compiled into SDL
  ##
  ## See also: getVideoDriver()


proc getVideoDriver*(index: int): cstring {.cdecl, importc: "SDL_GetVideoDriver", dynlib: LibName.}
  ## Get the name of a built in video driver.
  ##
  ## The video drivers are presented in the order in which they are
  ## normally checked during initialization.
  ##
  ## See also: getNumVideoDrivers()


proc videoInit*(driver_name: cstring): int {.cdecl, importc: "SDL_VideoInit", dynlib: LibName.}
  ## Initialize the video subsystem, optionally specifying a video driver.
  ##
  ## ``driver_name`` Initialize a specific driver by name, or nil for the
  ## default video driver.
  ##
  ## Return 0 on success, -1 on error
  ##
  ##  This function initializes the video subsystem; setting up a connection
  ##  to the window manager, etc, and determines the available display modes
  ##  and pixel formats, but does not initialize a window or graphics mode.
  ##
  ##  See also: videoQuit()


proc videoQuit*() {.cdecl, importc: "SDL_VideoQuit", dynlib: LibName.}
  ## Shuts down the video subsystem.
  ##
  ## This function closes all windows, and restores the original video mode.
  ##
  ## See also: videoInit()


proc getCurrentVideoDriver*(): cstring {.cdecl, importc: "SDL_GetCurrentVideoDriver", dynlib: LibName.}
  ## Returns the name of the currently initialized video driver.
  ##
  ## Return the name of the current video driver or nil if no driver
  ## has been initialized
  ##
  ## See also: getNumVideoDrivers(), 
  ## getVideoDriver()


proc getNumVideoDisplays*(): int {.cdecl, importc: "SDL_GetNumVideoDisplays", dynlib: LibName.}
  ## Returns the number of available video displays.
  ##
  ## See also: getDisplayBounds()


proc getDisplayName*(displayIndex: int): cstring {.cdecl, importc: "SDL_GetDisplayName", dynlib: LibName.}
  ## Get the name of a display in UTF-8 encoding
  ##
  ## Return the name of a display, or nil for an invalid display index.
  ##
  ## See also: getNumVideoDisplays()


proc getDisplayBounds*(displayIndex: int, rect: PRect): int {.cdecl, importc: "SDL_GetDisplayBounds", dynlib: LibName.}
  ## Get the desktop area represented by a display, with the primary
  ## display located at 0,0
  ##
  ## Return 0 on success, or -1 if the index is out of range.
  ##
  ## See also: getNumVideoDisplays()


proc getNumDisplayModes*(displayIndex: int): int {.cdecl, importc: "SDL_GetNumDisplayModes", dynlib: LibName.}
  ## Returns the number of available display modes.
  ##
  ## See also: getDisplayMode()


proc getDisplayMode*(displayIndex, modeIndex: int, mode: ptr TDisplayMode): int {.cdecl, importc: "SDL_GetDisplayMode", dynlib: LibName.}
  ## Fill in information about a specific display mode.
  ##
  ## The display modes are sorted in this priority:
  ## * bits per pixel -> more colors to fewer colors
  ## * width -> largest to smallest
  ## * height -> largest to smallest
  ## * refresh rate -> highest to lowest
  ##
  ## See also: getNumDisplayModes()


proc getDesktopDisplayMode*(displayIndex: int, mode: ptr TDisplayMode): int {.cdecl, importc: "SDL_GetDesktopDisplayMode", dynlib: LibName.}
  ## Fill in information about the desktop display mode.


proc getCurrentDisplayMode*(displayIndex: int, mode: ptr TDisplayMode): int {.cdecl, importc: "SDL_GetCurrentDisplayMode", dynlib: LibName.}
  ## Fill in information about the current display mode.


proc getClosestDisplayMode*(displayIndex: int, mode, closest: ptr TDisplayMode): ptr TDisplayMode {.cdecl, importc: "SDL_GetClosestDisplayMode", dynlib: LibName.}
  ## Get the closest match to the requested display mode.
  ##
  ## ``displayIndex`` The index of display from which mode should be queried.
  ##
  ## ``mode`` The desired display mode
  ##
  ## ``closest`` A pointer to a display mode to be filled in with the closest
  ## match of the available display modes.
  ##
  ## Return the passed in value ``closest``, or nil if no matching video mode
  ## was available.
  ##
  ## The available display modes are scanned, and ``closest`` is filled in with the
  ## closest mode matching the requested mode and returned.  The mode format and
  ## refresh_rate default to the desktop mode if they are 0.  The modes are
  ## scanned with size being first priority, format being second priority, and
  ## finally checking the refresh_rate.  If all the available modes are too
  ## small, then nil is returned.
  ##
  ## See also: getNumDisplayModes(), 
  ## getDisplayMode()


proc getWindowDisplayIndex*(window: PWindow): int {.cdecl, importc: "SDL_GetWindowDisplayIndex", dynlib: LibName.}
  ## Get the display index associated with a window.
  ##
  ## Return the display index of the display containing the center of the
  ## window, or -1 on error.


proc setWindowDisplayMode*(window: PWindow, mode: TDisplayMode): int {.cdecl, importc: "SDL_SetWindowDisplayMode", dynlib: LibName.}
  ## Set the display mode used when a fullscreen window is visible.
  ##
  ## By default the window's dimensions and the desktop format and refresh rate
  ## are used.
  ##
  ## ``window`` The window for which the display mode should be set.
  ##
  ## ``mode`` The mode to use, or nil for the default mode.
  ##
  ## Return 0 on success, or -1 if setting the display mode failed.
  ##
  ## See also: getWindowDisplayMode(), 
  ## setWindowFullscreen()


proc getWindowDisplayMode*(window: PWindow, mode: ptr TDisplayMode): int {.cdecl, importc: "SDL_GetWindowDisplayMode", dynlib: LibName.}
  ## Fill in information about the display mode used when a fullscreen
  ## window is visible.
  ##
  ## See also: setWindowDisplayMode(), 
  ## setWindowFullscreen()


proc getWindowPixelFormat*(window: PWindow): Uint32 {.cdecl, importc: "SDL_GetWindowPixelFormat", dynlib: LibName.}
  ## Get the pixel format associated with the window.


proc createWindow*(title: cstring, x, y, w, h: int, flags: Uint32 = 0): PWindow {.cdecl, importc: "SDL_CreateWindow", dynlib: LibName.}
  ## Create a window with the specified position, dimensions, and flags.
  ##
  ## ``title`` The title of the window, in UTF-8 encoding.
  ##
  ## ``x`` The x position of the window, ``WINDOWPOS_CENTERED``,
  ## or ``WINDOWPOS_UNDEFINED``.
  ##
  ## ``y`` The y position of the window, ``WINDOWPOS_CENTERED``,
  ## or ``WINDOWPOS_UNDEFINED``.
  ##
  ## ``w`` The width of the window.
  ##
  ## ``h`` The height of the window.
  ##
  ## ``flags`` The flags for the window, a mask of any of the following:
  ##
  ## ``WINDOW_FULLSCREEN``, ``WINDOW_OPENGL``,
  ## ``WINDOW_SHOWN``, ``WINDOW_BORDERLESS``,
  ## ``WINDOW_RESIZABLE``, ``WINDOW_MAXIMIZED``,
  ## ``WINDOW_MINIMIZED``, ``WINDOW_INPUT_GRABBED``.
  ##
  ## Return the id of the window created, or zero if window creation failed.
  ##
  ## See also: destroyWindow()
 

proc createWindowFrom*(data: pointer): PWindow {.cdecl, importc: "SDL_CreateWindowFrom", dynlib: LibName.}
  ## Create an SDL window from an existing native window.
  ##
  ## ``data`` A pointer to driver-dependent window creation data
  ##
  ## Return the id of the window created, or zero if window creation failed.
  ##
  ## See also: destroyWindow()


proc getWindowID*(window: PWindow): Uint32 {.cdecl, importc: "SDL_GetWindowID", dynlib: LibName.}
  ## Get the numeric ID of a window, for logging purposes.


proc getWindowFromID*(id: Uint32): PWindow {.cdecl, importc: "SDL_GetWindowFromID", dynlib: LibName.}
  ## Get a window from a stored ID, or nil if it doesn't exist.


proc getWindowFlags*(window: PWindow): Uint32 {.cdecl, importc: "SDL_GetWindowFlags", dynlib: LibName.}
  ## Get the window flags.


proc setWindowTitle*(window: PWindow, title: cstring) {.cdecl, importc: "SDL_SetWindowTitle", dynlib: LibName.}
  ## Set the title of a window, in UTF-8 format.
  ##
  ## See also: getWindowTitle()


proc getWindowTitle*(window: PWindow): cstring {.cdecl, importc: "SDL_GetWindowTitle", dynlib: LibName.}
  ## Get the title of a window, in UTF-8 format.
  ##
  ## See also: setWindowTitle()


proc setWindowIcon*(window: PWindow, icon: PSurface) {.cdecl, importc: "SDL_SetWindowIcon", dynlib: LibName.}
  ## Set the icon for a window.
  ##
  ## ``window`` The window for which the icon should be set.
  ##
  ## ``icon`` The icon for the window.



proc setWindowData*(window: PWindow, name: cstring, userdata: pointer): pointer {.cdecl, importc: "SDL_SetWindowData", dynlib: LibName.}
  ## Associate an arbitrary named pointer with a window.
  ##
  ## ``window`` The window to associate with the pointer.
  ##
  ## ``name`` The name of the pointer.
  ##
  ## ``userdata`` The associated pointer.
  ##
  ## Return the previous value associated with ``name``
  ##
  ## The name is case-sensitive.
  ##
  ## See also: getWindowData()


proc getWindowData*(window: PWindow, name: cstring): pointer {.cdecl, importc: "SDL_GetWindowData", dynlib: LibName.}
  ## Retrieve the data pointer associated with a window.
  ##
  ## ``window`` The window to query.
  ##
  ## ``name`` The name of the pointer.
  ##
  ##  Return the value associated with ``name``
  ##
  ##  See also: setWindowData()


proc setWindowPosition*(window: PWindow, x, y: int) {.cdecl, importc: "SDL_SetWindowPosition", dynlib: LibName.}
  ## Set the position of a window.
  ##
  ## ``window`` The window to reposition.
  ##
  ## ``x`` The x coordinate of the window, ``WINDOWPOS_CENTERED``, or
  ## ``WINDOWPOS_UNDEFINED``.
  ##
  ## ``y`` The y coordinate of the window, ``WINDOWPOS_CENTERED``, or
  ## ``WINDOWPOS_UNDEFINED``.
  ##
  ## The window coordinate origin is the upper left of the display.
  ##
  ## See also: getWindowPosition()


proc getWindowPosition*(window: PWindow, x, y: ptr int) {.cdecl, importc: "SDL_GetWindowPosition", dynlib: LibName.}
  ## Get the position of a window.
  ##
  ## ``window`` The window to query.
  ##
  ## ``x`` Pointer to variable for storing the x position, may be nil
  ##
  ## ``y`` Pointer to variable for storing the y position, may be nil
  ##
  ## See also: setWindowPosition()


proc setWindowSize*(window: PWindow, w, h: int) {.cdecl, importc: "SDL_SetWindowSize", dynlib: LibName.}
  ##
  ## Set the size of a window's client area.
  ##
  ## ``window`` The window to resize.
  ##
  ## ``w`` The width of the window, must be >0
  ##
  ## ``h`` The height of the window, must be >0
  ##
  ## You can't change the size of a fullscreen window, it automatically
  ## matches the size of the display mode.
  ##
  ## See also: getWindowSize()


proc getWindowSize*(window: PWindow, w, h: ptr int) {.cdecl, importc: "SDL_GetWindowSize", dynlib: LibName.}
  ## Get the size of a window's client area.
  ##
  ## ``window`` The window to query.
  ##
  ## ``w`` Pointer to variable for storing the width, may be nil
  ##
  ## ``h`` Pointer to variable for storing the height, may be nil
  ##
  ## See also: setWindowSize()



proc setWindowMinimumSize*(window: PWindow, min_w, min_h: int) {.cdecl, importc: "SDL_SetWindowMinimumSize", dynlib: LibName.}
  ## Set the minimum size of a window's client area.
  ##
  ## ``window`` The window to set a new minimum size.
  ##
  ## ``min_w`` The minimum width of the window, must be >0
  ##
  ## ``min_h`` The minimum height of the window, must be >0
  ##
  ## You can't change the minimum size of a fullscreen window, it
  ## automatically matches the size of the display mode.
  ##
  ## See also: getWindowMinimumSize(), 
  ## setWindowMaximumSize()


proc getWindowMinimumSize*(window: PWindow, w, h: ptr int) {.cdecl, importc: "SDL_GetWindowMinimumSize", dynlib: LibName.}
  ## Get the minimum size of a window's client area.
  ##
  ## ``window`` The window to query.
  ##
  ## ``w`` Pointer to variable for storing the minimum width, may be nil
  ##
  ## ``h`` Pointer to variable for storing the minimum height, may be nil
  ##
  ## See also: getWindowMaximumSize(), 
  ## setWindowMinimumSize()


proc setWindowMaximumSize*(window: PWindow, max_w, max_h: int) {.cdecl, importc: "SDL_SetWindowMaximumSize", dynlib: LibName.}
  ## Set the maximum size of a window's client area.
  ##
  ## ``window`` The window to set a new maximum size.
  ##
  ## ``max_w`` The maximum width of the window, must be >0
  ##
  ## ``max_h`` The maximum height of the window, must be >0
  ##
  ## You can't change the maximum size of a fullscreen window, it
  ## automatically matches the size of the display mode.
  ##
  ## See also: getWindowMaximumSize(), 
  ## setWindowMinimumSize()


proc getWindowMaximumSize*(window: PWindow, w, h: ptr int) {.cdecl, importc: "SDL_GetWindowMaximumSize", dynlib: LibName.}
  ## Get the maximum size of a window's client area.
  ##
  ## ``window`` The window to query.
  ##
  ## ``w`` Pointer to variable for storing the maximum width, may be nil
  ##
  ## ``h`` Pointer to variable for storing the maximum height, may be nil
  ##
  ## See also: getWindowMinimumSize(), 
  ## setWindowMaximumSize()



proc setWindowBordered*(window: PWindow, bordered: bool) {.cdecl, importc: "SDL_SetWindowBordered", dynlib: LibName.}
  ## Set the border state of a window.
  ##
  ## This will add or remove the window's ``WINDOW_BORDERLESS`` flag and
  ## add or remove the border from the actual window. This is a no-op if the
  ## window's border already matches the requested state.
  ##
  ## ``window`` The window of which to change the border state.
  ##
  ## ``bordered`` FALSE to remove border, TRUE to add border.
  ##
  ## You can't change the border state of a fullscreen window.
  ##
  ## See also: getWindowFlags()


proc showWindow*(window: PWindow) {.cdecl, importc: "SDL_ShowWindow", dynlib: LibName.}
  ## Show a window.
  ##
  ## See also: hideWindow()


proc hideWindow*(window: PWindow) {.cdecl, importc: "SDL_HideWindow", dynlib: LibName.}
  ## Hide a window.
  ##
  ## See also: showWindow()


proc raiseWindow*(window: PWindow) {.cdecl, importc: "SDL_RaiseWindow", dynlib: LibName.}
  ## Raise a window above other windows and set the input focus.


proc maximizeWindow*(window: PWindow) {.cdecl, importc: "SDL_MaximizeWindow", dynlib: LibName.}
  ## Make a window as large as possible.
  ##
  ## See also: restoreWindow()


proc minimizeWindow*(window: PWindow) {.cdecl, importc: "SDL_MinimizeWindow", dynlib: LibName.}
  ## Minimize a window to an iconic representation.
  ##
  ## See also: restoreWindow()


proc restoreWindow*(window: PWindow) {.cdecl, importc: "SDL_RestoreWindow", dynlib: LibName.}
  ## Restore the size and position of a minimized or maximized window.
  ##
  ## See also: maximizeWindow(), 
  ## minimizeWindow()




proc setWindowFullscreen*(window: PWindow, flags: Uint32): int {.cdecl, importc: "SDL_SetWindowFullscreen", dynlib: LibName.}
  ## Set a window's fullscreen state.
  ##
  ## Return 0 on success, or -1 if setting the display mode failed.
  ##
  ## See also: setWindowDisplayMode(), 
  ## getWindowDisplayMode()


proc getWindowSurface*(window: PWindow): PSurface {.cdecl, importc: "SDL_GetWindowSurface", dynlib: LibName.}
  ## Get the SDL surface associated with the window.
  ##
  ## Return the window's framebuffer surface, or nil on error.
  ##
  ## A new surface will be created with the optimal format for the window,
  ## if necessary. This surface will be freed when the window is destroyed.
  ##
  ## You may not combine this with 3D or the rendering API on this window.
  ##
  ## See also: updateWindowSurface(),
  ## updateWindowSurfaceRects()


proc updateWindowSurface*(window: PWindow): int {.cdecl, importc: "SDL_UpdateWindowSurface", dynlib: LibName.}
  ## Copy the window surface to the screen.
  ##
  ## Return 0 on success, or -1 on error.
  ##
  ## See also: getWindowSurface(), 
  ## updateWindowSurfaceRects()


#!CHECK rects
proc updateWindowSurfaceRects*(window: PWindow, rects: PRect, numrects: int): int {.cdecl, importc: "SDL_UpdateWindowSurfaceRects", dynlib: LibName.}
  ## Copy a number of rectangles on the window surface to the screen.
  ##
  ## Return 0 on success, or -1 on error.
  ##
  ## See also: getWindowSurface(), 
  ## updateWindowSurfaceRect()


proc setWindowGrab*(window: PWindow, grabbed: bool) {.cdecl, importc: "SDL_SetWindowGrab", dynlib: LibName.}
  ## Set a window's input grab mode.
  ##
  ## ``window`` The window for which the input grab mode should be set.
  ##
  ## ``grabbed`` This is TRUE to grab input, and FALSE to release input.
  ##
  ## See also: getWindowGrab()


proc getWindowGrab*(window: PWindow): bool {.cdecl, importc: "SDL_GetWindowGrab", dynlib: LibName.}
  ## Get a window's input grab mode.
  ##
  ## Return TRUE if input is grabbed, and FALSE otherwise.
  ##
  ## See also: setWindowGrab()


proc setWindowBrightness*(window: PWindow, brightness: float): int {.cdecl, importc: "SDL_SetWindowBrightness", dynlib: LibName.}
  ## Set the brightness (gamma correction) for a window.
  ##
  ## Return 0 on success, or -1 if setting the brightness isn't supported.
  ##
  ## See also: getWindowBrightness(), 
  ## setWindowGammaRamp()


proc getWindowBrightness*(window: PWindow): float {.cdecl, importc: "SDL_GetWindowBrightness", dynlib: LibName.}
  ## Get the brightness (gamma correction) for a window.
  ##
  ## Return the last brightness value passed to SetWindowBrightness()
  ##
  ## See also: setWindowBrightness()


proc setWindowGammaRamp*(window: PWindow, red, green, blue: ptr Uint16): int {.cdecl, importc: "SDL_SetWindowGammaRamp", dynlib: LibName.}
  ## Set the gamma ramp for a window.
  ##
  ## ``window`` The window for which the gamma ramp should be set.
  ##
  ## ``red`` The translation table for the red channel, or nil.
  ##
  ## ``green`` The translation table for the green channel, or nil.
  ##
  ## ``blue`` The translation table for the blue channel, or nil.
  ##
  ## Return 0 on success, or -1 if gamma ramps are unsupported.
  ##
  ## Set the gamma translation table for the red, green, and blue channels
  ## of the video hardware.  Each table is an array of 256 16-bit quantities,
  ## representing a mapping between the input and output for that channel.
  ## The input is the index into the array, and the output is the 16-bit
  ## gamma value at that index, scaled to the output color precision.
  ##
  ## See also: getWindowGammaRamp()


proc getWindowGammaRamp*(window: PWindow, red, green, blue: ptr Uint16): int {.cdecl, importc: "SDL_GetWindowGammaRamp", dynlib: LibName.}
  ## Get the gamma ramp for a window.
  ##
  ## ``window`` The window from which the gamma ramp should be queried.
  ##
  ## ``red`` A pointer to a 256 element array of 16-bit quantities to hold
  ## the translation table for the red channel, or nil.
  ##
  ## ``green`` A pointer to a 256 element array of 16-bit quantities to hold
  ## the translation table for the green channel, or nil.
  ##
  ## ``blue``  A pointer to a 256 element array of 16-bit quantities to hold
  ## the translation table for the blue channel, or nil.
  ##
  ## Return 0 on success, or -1 if gamma ramps are unsupported.
  ##
  ## See also: setWindowGammaRamp()



proc destroyWindow*(window: PWindow) {.cdecl, importc: "SDL_DestroyWindow", dynlib: LibName.}
  ## Destroy a window.


proc isScreenSaverEnabled*(): bool {.cdecl, importc: "SDL_IsScreenSaverEnabled", dynlib: LibName.}
  ## Returns whether the screensaver is currently enabled (default on).
  ##
  ## See also: enableScreenSaver(), 
  ## disableScreenSaver()


proc enableScreenSaver*() {.cdecl, importc: "SDL_EnableScreenSaver", dynlib: LibName.}
  ## Allow the screen to be blanked by a screensaver
  ##
  ## See also: isScreenSaverEnabled(),
  ## disableScreenSaver()


proc disableScreenSaver*() {.cdecl, importc: "SDL_DisableScreenSaver", dynlib: LibName.}
  ## Prevent the screen from being blanked by a screensaver
  ##
  ## See also: isScreenSaverEnabled(), 
  ## enableScreenSaver()


# OpenGL support functions


proc glLoadLibrary*(path: cstring): int {.cdecl, importc: "SDL_GL_LoadLibrary", dynlib: LibName.}
  ## Dynamically load an OpenGL library.
  ##
  ## ``path`` The platform dependent OpenGL library name, or nil to open the
  ## default OpenGL library.
  ##
  ##  Return 0 on success, or -1 if the library couldn't be loaded.
  ##
  ##  This should be done after initializing the video driver, but before
  ##  creating any OpenGL windows.  If no OpenGL library is loaded, the default
  ##  library will be loaded upon creation of the first OpenGL window.
  ##
  ##  If you do this, you need to retrieve all of the GL functions used in
  ##  your program from the dynamic library using glGetProcAddress().
  ##
  ##  See also: glGetProcAddress(), 
  ##  glUnloadLibrary()


proc glGetProcAddress*(pr: cstring): pointer {.cdecl, importc: "SDL_GL_GetProcAddress", dynLib: LibName.}
  ## Get the address of an OpenGL function.


proc glUnloadLibrary*() {.cdecl, importc: "SDL_GL_UnloadLibrary", dynlib: LibName.}
  ## Unload the OpenGL library previously loaded by glLoadLibrary().
  ##
  ## See also: glLoadLibrary()


proc glExtensionSupported*(extension: cstring): bool {.cdecl, importc: "SDL_GL_ExtensionSupported", dynlib: LibName.}
  ## Return true if an OpenGL extension is supported for the current context.


proc glSetAttribute*(attr: TGLattr, value: int): int {.cdecl, importc: "SDL_GL_SetAttribute", dynlib: LibName.}
  ## Set an OpenGL window attribute before window creation.


proc glGetAttribute*(attr: TGLattr, value: ptr int): int {.cdecl, importc: "SDL_GL_GetAttribute", dynlib: LibName.}
  ## Get the actual value for an attribute from the current context.


proc glCreateContext*(window: PWindow): PGLContext {.cdecl, importc: "SDL_GL_CreateContext", dynlib: LibName.}
  ## Create an OpenGL context for use with an OpenGL window, and make it
  ## current.
  ##
  ## See also: glDeleteContext()


proc glMakeCurrent*(window: PWindow, context: PGLContext): int {.cdecl, importc: "SDL_GL_MakeCurrent", dynlib: LibName.}
  ## Set up an OpenGL context for rendering into an OpenGL window.
  ##
  ## The context must have been created with a compatible window.


proc glSetSwapInterval*(interval: int): int {.cdecl, importc: "SDL_GL_SetSwapInterval", dynlib: LibName.}
  ## Set the swap interval for the current OpenGL context.
  ##
  ## ``interval`` 0 for immediate updates, 1 for updates synchronized with the
  ## vertical retrace. If the system supports it, you may specify -1 to allow
  ## late swaps to happen immediately instead of waiting for the next retrace.
  ##
  ## Return 0 on success, or -1 if setting the swap interval is not supported.
  ##
  ## See also: glGetSwapInterval()


proc glGetSwapInterval*(): int {.cdecl, importc: "SDL_GL_GetSwapInterval", dynlib: LibName.}
  ## Get the swap interval for the current OpenGL context.
  ##
  ## Rreturn 0 if there is no vertical retrace synchronization, 1 if the buffer
  ## swap is synchronized with the vertical retrace, and -1 if late
  ## swaps happen immediately instead of waiting for the next retrace.
  ## If the system can't determine the swap interval, or there isn't a
  ## valid current context, this will return 0 as a safe default.
  ##
  ## See also: glSetSwapInterval()


proc glSwapWindow*(window: PWindow) {.cdecl, importc: "SDL_GL_SwapWindow", dynlib: LibName.}
  ## Swap the OpenGL buffers for a window, if double-buffering is supported.


proc glDeleteContext*(context: PGLContext) {.cdecl, importc: "SDL_GL_DeleteContext", dynlib: LibName.}
  ## Delete an OpenGL context.
  ##
  ## See also: glCreateContext()

