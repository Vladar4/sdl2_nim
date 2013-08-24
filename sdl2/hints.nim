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
# Official documentation for SDL configuration variables
#
# This file contains functions to set and get configuration hints,
# as well as listing each of them alphabetically.
#
# The convention for naming hints is HINT_X, where "X" is
# the environment variable that can be used to override the default.
#
# In general these hints are just that - they may or may not be
# supported or applicable on any given platform, but they provide
# a way for an application or user to give the library a hint as
# to how they would like the library to work.
#


const
  HINT_FRAMEBUFFER_ACCELERATION* = "SDL_FRAMEBUFFER_ACCELERATION"
    ## A variable controlling how 3D acceleration is used to accelerate the SDL 1.2 screen surface.
    ##
    ## SDL can try to accelerate the SDL 1.2 screen surface by using streaming
    ## textures with a 3D rendering engine.  This variable controls whether and
    ## how this is done.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Disable 3D acceleration
    ##
    ## "1" - Enable 3D acceleration, using the default renderer.
    ##
    ## "X" - Enable 3D acceleration, using X where X is one of the valid rendering drivers.  (e.g. "direct3d", "opengl", etc.)
    ##
    ## By default SDL tries to make a best guess for each platform whether
    ##  to use acceleration or not.


  HINT_RENDER_DRIVER* = "SDL_RENDER_DRIVER"
    ## A variable specifying which render driver to use.
    ##
    ## If the application doesn't pick a specific renderer to use, this variable
    ## specifies the name of the preferred renderer.  If the preferred renderer
    ## can't be initialized, the normal default renderer is used.
    ##
    ## This variable is case insensitive and can be set to the following values:
    ##
    ## "direct3d", 
    ## "opengl", 
    ## "opengles2", 
    ## "opengles", 
    ## "software"
    ##
    ## The default varies by platform, but it's the first one in the list that
    ## is available on the current platform.


  HINT_RENDER_OPENGL_SHADERS* = "SDL_RENDER_OPENGL_SHADERS"
    ## A variable controlling whether the OpenGL render driver uses shaders
    ## if they are available.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Disable shaders
    ##
    ## "1" - Enable shaders
    ##
    ##  By default shaders are used if OpenGL supports them.


  HINT_RENDER_SCALE_QUALITY* = "SDL_RENDER_SCALE_QUALITY"
    ## A variable controlling the scaling quality
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" or "nearest" - Nearest pixel sampling
    ##
    ## "1" or "linear" - Linear filtering (supported by OpenGL and Direct3D)
    ##
    ## "2" or "best" - Anisotropic filtering (supported by Direct3D)
    ##
    ## By default nearest pixel sampling is used


  HINT_RENDER_VSYNC* = "SDL_RENDER_VSYNC"
    ## A variable controlling whether updates to the SDL 1.2 screen surface
    ## should be synchronized with the vertical refresh, to avoid tearing.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Disable vsync
    ##
    ## "1" - Enable vsync
    ##
    ## By default SDL does not sync screen surface updates
    ## with vertical refresh.

 
  HINT_VIDEO_X11_XVIDMODE* = "SDL_VIDEO_X11_XVIDMODE"
    ## A variable controlling whether the X11 VidMode extension should be used.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Disable XVidMode
    ##
    ## "1" - Enable XVidMode
    ##
    ## By default SDL will use XVidMode if it is available.


  HINT_VIDEO_X11_XINERAMA* = "SDL_VIDEO_X11_XINERAMA"
    ## A variable controlling whether the X11 Xinerama extension should be used.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Disable Xinerama
    ##
    ## "1" - Enable Xinerama
    ##
    ##  By default SDL will use Xinerama if it is available.


  HINT_VIDEO_X11_XRANDR* = "SDL_VIDEO_X11_XRANDR"
    ##  A variable controlling whether the X11 XRandR extension should be used.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Disable XRandR
    ##
    ## "1" - Enable XRandR
    ##
    ## By default SDL will not use XRandR because of window manager issues.


  HINT_GRAB_KEYBOARD* = "SDL_GRAB_KEYBOARD"
    ## A variable controlling whether grabbing input grabs the keyboard
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Grab will affect only the mouse
    ##
    ## "1" - Grab will affect mouse and keyboard
    ##
    ## By default SDL will not grab the keyboard so system shortcuts still work.


  HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS* = "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS"
    ## Minimize your SDL_Window if it loses key focus when in Fullscreen mode.
    ## Defaults to true.


  HINT_IDLE_TIMER_DISABLED* = "SDL_IOS_IDLE_TIMER_DISABLED"
    ## A variable controlling whether the idle timer is disabled on iOS.
    ##
    ## When an iOS app does not receive touches for some time, the screen is
    ## dimmed automatically. For games where the accelerometer is the only input
    ## this is problematic. This functionality can be disabled by setting this
    ## hint.
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - Enable idle timer
    ##
    ## "1" - Disable idle timer


  HINT_ORIENTATIONS* = "SDL_IOS_ORIENTATIONS"
    ## A variable controlling which orientations are allowed on iOS.
    ##
    ## In some circumstances it is necessary to be able to explicitly control
    ## which UI orientations are allowed.
    ##
    ## This variable is a space delimited list of the following values:
    ## "LandscapeLeft", "LandscapeRight", "Portrait", "PortraitUpsideDown"


  HINT_XINPUT_ENABLED* = "SDL_XINPUT_ENABLED"
    ## A variable that lets you disable the detection and use of Xinput
    ## gamepad devices
    ##
    ## The variable can be set to the following values:
    ##
    ## "0" - Disable XInput timer (only uses direct input)
    ##
    ## "1" - Enable XInput timer (the default)


  HINT_GAMECONTROLLERCONFIG* = "SDL_GAMECONTROLLERCONFIG"
    ## A variable that lets you manually hint extra gamecontroller db entries
    ##
    ## The variable should be newline delimited rows of gamecontroller
    ## config data, see gamecontroller.nim
    ##
    ## This hint must be set before calling init(INIT_GAMECONTROLLER)
    ## You can update mappings after the system is initialized with
    ## gameControllerMappingForGUID() and gameControllerAddMapping()


  HINT_ALLOW_TOPMOST* = "SDL_ALLOW_TOPMOST"
    ## If set to 0 then never set the top most bit on a SDL Window,
    ## even if the video mode expects it.
    ##
    ## This is a debugging aid for developers and not expected to be used
    ## by end users. The default is "1"
    ##
    ## This variable can be set to the following values:
    ##
    ## "0" - don't allow topmost
    ##
    ## "1" - allow topmost


type
  THintPriority* = enum ## An enumeration of hint priorities
    HINT_DEFAULT,
    HINT_NORMAL,
    HINT_OVERRIDE


proc setHintWithPriority*(name, value: cstring,
  priority: THintPriority): bool {.cdecl, importc: "SDL_SetHintWithPriority", dynlib: LibName.}
  ## Set a hint with a specific priority
  ##
  ## The priority controls the behavior when setting a hint that already
  ## has a value.  Hints will replace existing hints of their priority and
  ## lower.  Environment variables are considered to have override priority.
  ##
  ## Return TRUE if the hint was set, FALSE otherwise


proc setHint*(name, value: cstring): bool {.cdecl, importc: "SDL_SetHint", dynlib: LibName.}
  ## Set a hint with normal priority
  ##
  ## Return SDL_TRUE if the hint was set, FALSE otherwise


proc getHint*(name: cstring): cstring {.cdecl, importc: "SDL_GetHint", dynlib: LibName.}
  ## Get a hint
  ##
  ## Return The string value of a hint variable.


proc clearHints*() {.cdecl, importc: "SDL_ClearHints", dynlib: LibName.}
  ## Clear all hints
  ##
  ## This function is called during quit() to free stored hints.

