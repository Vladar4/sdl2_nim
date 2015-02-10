#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2014 Sam Lantinga <slouken@libsdl.org>
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

##  hints.nim
##
##  Official documentation for SDL configuration variables
##
##  This file contains functions to set and get configuration hints,
##  as well as listing each of them alphabetically.
##
##  The convention for naming hints is `HINT_X`, where "X" is
##  the environment variable that can be used to override the default.
##
##  In general these hints are just that - they may or may not be
##  supported or applicable on any given platform, but they provide
##  a way for an application or user to give the library a hint as
##  to how they would like the library to work.

import
  sdl_libname

const
  HINT_FRAMEBUFFER_ACCELERATION* = "SDL_FRAMEBUFFER_ACCELERATION" ##  \
    ##  A variable controlling how 3D acceleration is used  to accelerate the
    ##  SDL screen surface.
    ##
    ##  SDL can try to accelerate the SDL screen surface by using streaming
    ##  textures with a 3D rendering engine.  This variable controls whether
    ##  and how this is done.
    ##
    ##  This variable can be set to the following values:
    ##  * "0" - Disable 3D acceleration
    ##  * "1" - Enable 3D acceleration, using the default renderer.
    ##  * "X" - Enable 3D acceleration, using X where X is one of the valid
    ##  rendering drivers.  (e.g. "direct3d", "opengl", etc.)
    ##
    ##  By default SDL tries to make a best guess for each platform whether
    ##  to use acceleration or not.

const
  HINT_RENDER_DRIVER* = "SDL_RENDER_DRIVER" ##  \
    ##  A variable specifying which render driver to use.
    ##
    ##  If the application doesn't pick a specific renderer to use, this
    ##  variable specifies the name of the preferred renderer.  If the
    ##  preferred renderer can't be initialized, the normal default renderer
    ##  is used.
    ##
    ##  This variable is case insensitive and can be set to the following
    ##  values:
    ##  * "direct3d"
    ##  * "opengl"
    ##  * "opengles2"
    ##  * "opengles"
    ##  * "software"
    ##
    ##  The default varies by platform, but it's the first one in the list that
    ##  is available on the current platform.

const
  HINT_RENDER_OPENGL_SHADERS* = "SDL_RENDER_OPENGL_SHADERS" ##  \
    ##  A variable controlling whether the OpenGL render driver uses shaders
    ##  if they are available.
    ##
    ##  This variable can be set to the following values:
    ##  * "0" - Disable shaders
    ##  * "1" - Enable shaders
    ##
    ##  By default shaders are used if OpenGL supports them.

const
  HINT_RENDER_DIRECT3D_THREADSAFE* = "SDL_RENDER_DIRECT3D_THREADSAFE" ##  \
    ##  A variable controlling whether the Direct3D device is initialized
    ##  for thread-safe operations.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Thread-safety is not enabled (faster)
    ##  * "1"       - Thread-safety is enabled
    ##
    ##  By default the Direct3D device is created with thread-safety disabled.

const
  HINT_RENDER_DIRECT3D11_DEBUG* = "SDL_HINT_RENDER_DIRECT3D11_DEBUG" ##  \
    ##  A variable controlling whether to enable Direct3D 11+'s Debug Layer.
    ##
    ##  This variable does not have any effect on the Direct3D 9 based renderer.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable Debug Layer use
    ##  * "1"       - Enable Debug Layer use
    ##
    ##  By default, SDL does not use Direct3D Debug Layer.

const
  HINT_RENDER_SCALE_QUALITY* = "SDL_RENDER_SCALE_QUALITY" ##  \
    ##  A variable controlling the scaling quality
    ##
    ##  This variable can be set to the following values:
    ##  * "0" or "nearest" - Nearest pixel sampling
    ##  * "1" or "linear"  - Linear filtering (supported by OpenGL and Direct3D)
    ##  * "2" or "best"    - Currently this is the same as "linear"
    ##
    ##  By default nearest pixel sampling is used

const
  HINT_RENDER_VSYNC* = "SDL_RENDER_VSYNC" ##  \
    ##  A variable controlling whether updates to the SDL screen surface
    ##  should be synchronized with the vertical refresh, to avoid tearing.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable vsync
    ##  * "1"       - Enable vsync
    ##
    ##  By default SDL does not sync screen surface updates with vertical
    ##  refresh.

const
  HINT_VIDEO_ALLOW_SCREENSAVER* = "SDL_VIDEO_ALLOW_SCREENSAVER" ##  \
    ##  A variable controlling whether the screensaver is enabled.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable screensaver
    ##  * "1"       - Enable screensaver
    ##
    ##  By default SDL will disable the screensaver.

const
  HINT_VIDEO_X11_XVIDMODE* = "SDL_VIDEO_X11_XVIDMODE" ##  \
    ##  A variable controlling whether the X11 VidMode extension
    ##  should be used.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable XVidMode
    ##  * "1"       - Enable XVidMode
    ##
    ##  By default SDL will use XVidMode if it is available.

const
  HINT_VIDEO_X11_XINERAMA* = "SDL_VIDEO_X11_XINERAMA" ##  \
    ##  A variable controlling whether the X11 Xinerama extension
    ##  should be used.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable Xinerama
    ##  * "1"       - Enable Xinerama
    ##
    ##  By default SDL will use Xinerama if it is available.

const
  HINT_VIDEO_X11_XRANDR* = "SDL_VIDEO_X11_XRANDR" ##  \
    ##  A variable controlling whether the X11 XRandR extension
    ##  should be used.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable XRandR
    ##  * "1"       - Enable XRandR
    ##
    ##  By default SDL will not use XRandR because of window manager issues.

const
  HINT_GRAB_KEYBOARD* = "SDL_GRAB_KEYBOARD" ##  \
    ##  A variable controlling whether grabbing input grabs the keyboard
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Grab will affect only the mouse
    ##  * "1"       - Grab will affect mouse and keyboard
    ##
    ##  By default SDL will not grab the keyboard
    ##  so system shortcuts still work.

const
  HINT_MOUSE_RELATIVE_MODE_WARP* = "SDL_MOUSE_RELATIVE_MODE_WARP" ##  \
    ##  A variable controlling whether relative mouse mode is implemented
    ##  using mouse warping
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Relative mouse mode uses raw input
    ##  * "1"       - Relative mouse mode uses mouse warping
    ##
    ##  By default SDL will use raw input for relative mouse mode

const
  HINT_VIDEO_MINIMIZE_ON_FOCUS_LOSS* = "SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS" ##  \
    ##  Minimize your ``Window`` if it loses key focus when in fullscreen mode.
    ##  Defaults to `true`.

const
  HINT_IDLE_TIMER_DISABLED* = "SDL_IOS_IDLE_TIMER_DISABLED" ##  \
    ##  A variable controlling whether the idle timer is disabled on iOS.
    ##
    ##  When an iOS app does not receive touches for some time, the screen is
    ##  dimmed automatically. For games where the accelerometer is the only
    ##  input  this is problematic. This functionality can be disabled by
    ##  setting this hint.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Enable idle timer
    ##  * "1"       - Disable idle timer

const
  HINT_ORIENTATIONS* = "SDL_IOS_ORIENTATIONS" ##  \
    ##  A variable controlling which orientations are allowed on iOS.
    ##
    ##  In some circumstances it is necessary to be able to explicitly control
    ##  which UI orientations are allowed.
    ##
    ##  This variable is a space delimited list of the following values:
    ##  * "LandscapeLeft"
    ##  * "LandscapeRight"
    ##  * "Portrait"
    ##  * "PortraitUpsideDown"

const
  HINT_ACCELEROMETER_AS_JOYSTICK* = "SDL_ACCELEROMETER_AS_JOYSTICK" ##  \
    ##  A variable controlling whether an Android built-in accelerometer
    ##  should be listed as a joystick device, rather than listing actual
    ##  joysticks only.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - List only real joysticks and accept input from them
    ##  * "1"       - List real joysticks along with the accelerometer
    ##    as if it were a 3 axis joystick (the default).

const
  HINT_XINPUT_ENABLED* = "SDL_XINPUT_ENABLED" ##  \
    ##  A variable that lets you disable the detection and use of Xinput
    ##  gamepad devices
    ##
    ##  The variable can be set to the following values:
    ##  * "0"       - Disable XInput detection (only uses direct input)
    ##  * "1"       - Enable XInput detection (the default)

const
  HINT_GAMECONTROLLERCONFIG* = "SDL_GAMECONTROLLERCONFIG" ##  \
    ##  A variable that lets you manually hint extra gamecontroller db entries
    ##
    ##  The variable should be newline delimited rows of gamecontroller config
    ##  data, see `gamecontroller.nim`
    ##
    ##  This hint must be set before calling ``init(INIT_GAMECONTROLLER)``
    ##  You can update mappings after the system is initialized with
    ##  ``gameControllerMappingForGUID()`` and ``gameControllerAddMapping()``

const
  HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS* =
    "SDL_JOYSTICK_ALLOW_BACKGROUND_EVENTS" ##  \
    ##  A variable that lets you enable joystick (and gamecontroller) events
    ##  even when your app is in the background.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"       - Disable joystick & gamecontroller input events when the
    ##    application is in the background.
    ##  * "1"       - Enable joystick & gamecontroller input events when the
    ##    application is in the background.
    ##
    ##  The default value is "0".  This hint may be set at any time.

const
  HINT_ALLOW_TOPMOST* = "SDL_ALLOW_TOPMOST" ##  \
    ##  If set to `0` then never set the top most bit on a ``Window``,
    ##  even if the video mode expects it.
    ##
    ##  This is a debugging aid for developers and not expected to be used
    ##  by end users. The default is "1"
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - don't allow topmost
    ##  * "1"       - allow topmost

const
  HINT_TIMER_RESOLUTION* = "SDL_TIMER_RESOLUTION" ##  \
    ##  A variable that controls the timer resolution, in milliseconds.
    ##
    ##  The higher resolution the timer, the more frequently the CPU services
    ##  timer interrupts, and the more precise delays are, but this takes up
    ##  power and CPU time.  This hint is only used on Windows 7 and earlier.
    ##
    ##  See this blog post for more information:
    ##  http://randomascii.wordpress.com/2013/07/08/windows-timer-resolution-megawatts-wasted/
    ##
    ##  If this variable is set to "0", the system timer resolution is not set.
    ##
    ##  The default value is "1". This hint may be set at any time.

const
  HINT_VIDEO_HIGHDPI_DISABLED* = "SDL_VIDEO_HIGHDPI_DISABLED" ##  \
    ##  If set to 1, then do not allow high-DPI windows. ("Retina" on Mac)

const
  HINT_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK* =
    "SDL_MAC_CTRL_CLICK_EMULATE_RIGHT_CLICK" ##  \
    ##  A variable that determines whether ctrl+click should generate
    ##  a right-click event on Mac
    ##
    ##  If present, holding ctrl while left clicking will generate
    ##  a right click event when on Mac.

const
  HINT_VIDEO_WIN_D3DCOMPILER* = "SDL_VIDEO_WIN_D3DCOMPILER" ##  \
    ##  A variable specifying which shader compiler to preload
    ##  when using the Chrome ANGLE binaries
    ##
    ##  SDL has EGL and OpenGL ES2 support on Windows via the ANGLE project.
    ##  It can use two different sets of binaries, those compiled by the user
    ##  from source or those provided by the Chrome browser.
    ##  In the later case, these binaries require that SDL loads a DLL
    ##  providing the shader compiler.
    ##
    ##  This variable can be set to the following values:
    ##  * "d3dcompiler_46.dll" - default, best for Vista or later.
    ##  * "d3dcompiler_43.dll" - for XP support.
    ##  * "none" - do not load any library, useful if you compiled ANGLE from
    ##    source and included the compiler in your binaries.

const
  HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT* =
    "SDL_VIDEO_WINDOW_SHARE_PIXEL_FORMAT" ##  \
    ##  A variable that is the address of another ``Window``
    ##  (as a hex string formatted with "%p").
    ##
    ##  If this hint is set before ``createWindowFrom()`` and the ``Window``
    ##  it is set to has `WINDOW_OPENGL` set (and running on WGL only,
    ##  currently), then two things will occur on the newly created ``Window``:
    ##
    ##  1. Its pixel format will be set to the same pixel format as this
    ##  ``Window``.  This is needed for example when sharing an OpenGL context
    ##  across multiple windows.
    ##
    ##  2. The flag `WINDOW_OPENGL` will be set on the new window so it can be
    ##  used for OpenGL rendering.
    ##
    ##  This variable can be set to the following values:
    ##
    ##  The address (as a string "%p") of the ``Window`` that new windows
    ##  created with ``createWindowFrom()`` should share a pixel format with.

const
  HINT_WINRT_PRIVACY_POLICY_URL* = "SDL_HINT_WINRT_PRIVACY_POLICY_URL" ##  \
    ##  A URL to a WinRT app's privacy policy
    ##
    ##  All network-enabled WinRT apps must make a privacy policy available
    ##  to its users.  On Windows 8, 8.1, and RT, Microsoft mandates that this
    ##  policy be be available in the Windows Settings charm, as accessed from
    ##  within the app. SDL provides code to add a URL-based link there, which
    ##  can point to the app's privacy policy.
    ##
    ##  To setup a URL to an app's privacy policy, set
    ##  `HINT_WINRT_PRIVACY_POLICY_URL` before calling any ``init()``
    ##  functions. The contents of the hint should be a valid URL.
    ##  For example, "http://www.example.com".
    ##
    ##  The default value is "", which will prevent SDL from adding a privacy
    ##  policy link to the Settings charm.  This hint should only be set during
    ##  app init.
    ##
    ##  The label text of an app's "Privacy Policy" link may be customized via
    ##  another hint, `HINT_WINRT_PRIVACY_POLICY_LABEL`.
    ##
    ##  Please note that on Windows Phone, Microsoft does not provide standard
    ##  UI for displaying a privacy policy link, and as such,
    ##  `HINT_WINRT_PRIVACY_POLICY_URL` will not get used on that platform.
    ##  Network-enabled phone apps should display their privacy policy through
    ##  some other, in-app means.


const
  HINT_WINRT_PRIVACY_POLICY_LABEL* = "SDL_HINT_WINRT_PRIVACY_POLICY_LABEL" ##  \
    ##  Label text for a WinRT app's privacy policy link
    ##
    ##  Network-enabled WinRT apps must include a privacy policy.
    ##  On Windows 8, 8.1, and RT, Microsoft mandates that this policy be
    ##  available via the Windows Settings charm. SDL provides code to add a
    ##  link there, with it's label text being set via the optional hint,
    ##  `HINT_WINRT_PRIVACY_POLICY_LABEL`.
    ##
    ##  Please note that a privacy policy's contents are not set via this hint.
    ##  A separate hint, `HINT_WINRT_PRIVACY_POLICY_URL`, is used to link
    ##  to the actual text of the policy.
    ##
    ##  The contents of this hint should be encoded as a UTF8 string.
    ##
    ##  The default value is "Privacy Policy".  This hint should only be set
    ##  during app initialization, preferably before any calls to ``init()``.
    ##
    ##  For additional information on linking to a privacy policy, see the
    ##  documentation for `HINT_WINRT_PRIVACY_POLICY_URL`.

const
  HINT_WINRT_HANDLE_BACK_BUTTON* = "SDL_HINT_WINRT_HANDLE_BACK_BUTTON" ##  \
    ##  If set to "1", back button press events on Windows Phone 8+ will be
    ##  marked as handled.
    ##
    ##  TODO, WinRT: document `HINT_WINRT_HANDLE_BACK_BUTTON` need and use
    ##  For now, more details on why this is needed can be found at the
    ##  beginning of the following web page:
    ##  http://msdn.microsoft.com/en-us/library/windowsphone/develop/jj247550(v=vs.105).aspx

const
  HINT_VIDEO_MAC_FULLSCREEN_SPACES* = "SDL_VIDEO_MAC_FULLSCREEN_SPACES" ##  \
    ##  A variable that dictates policy for fullscreen Spaces on Mac OS X.
    ##
    ##  This hint only applies to Mac OS X.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"       - Disable Spaces support (`FULLSCREEN_DESKTOP` won't use
    ##    them and `WINDOW_RESIZABLE` windows won't offer the "fullscreen"
    ##    button on their titlebars).
    ##  * "1"       - Enable Spaces support (`FULLSCREEN_DESKTOP` will use
    ##    them and `WINDOW_RESIZABLE` windows will offer the "fullscreen"
    ##    button on their titlebars.
    ##
    ##  The default value is "1". Spaces are disabled regardless of this hint
    ##  if the OS isn't at least Mac OS X Lion (10.7). This hint must be set
    ##  before any windows are created.

type
  HintPriority* {.size: sizeof(cint).} = enum ##  \
    ##  An enumeration of hint priorities
    HINT_DEFAULT, HINT_NORMAL, HINT_OVERRIDE

proc setHintWithPriority*(
    name: cstring; value: cstring; priority: HintPriority): bool {.
      cdecl, importc: "SDL_SetHintWithPriority", dynlib: SDL2_LIB.}
  ##  Set a hint with a specific priority
  ##
  ##  The priority controls the behavior when setting a hint that already
  ##  has a value.  Hints will replace existing hints of their priority and
  ##  lower.  Environment variables are considered to have override priority.
  ##
  ##  ``Return`` `true` if the hint was set, `false` otherwise

proc setHint*(name: cstring; value: cstring): bool {.
    cdecl, importc: "SDL_SetHint", dynlib: SDL2_LIB.}
  ##  Set a hint with normal priority
  ##
  ##  ``Return`` `true` if the hint was set, `false` otherwise

proc getHint*(name: cstring): cstring {.
    cdecl, importc: "SDL_GetHint", dynlib: SDL2_LIB.}
  ##  Get a hint
  ##
  ##  ``Return`` the string value of a hint variable.

type
  HintCallback* = proc (
      userdata: pointer; name: cstring;
      oldValue: cstring; newValue: cstring) {.cdecl.}

proc addHintCallback*(
    name: cstring; callback: HintCallback; userdata: pointer) {.
      cdecl, importc: "SDL_AddHintCallback", dynlib: SDL2_LIB.}
  ##  Add a function to watch a particular hint
  ##
  ##  ``name`` The hint to watch
  ##
  ##  ``callback`` The function to call when the hint value changes
  ##
  ##  ``userdata`` A pointer to pass to the callback function

proc delHintCallback*(
    name: cstring; callback: HintCallback; userdata: pointer) {.
      cdecl, importc: "SDL_DelHintCallback", dynlib: SDL2_LIB.}
  ##  Remove a function watching a particular hint
  ##
  ##  ``name`` The hint being watched
  ##
  ##  ``callback`` The function being called when the hint value changes
  ##
  ##  ``userdata`` A pointer being passed to the callback function

proc clearHints*() {.
    cdecl, importc: "SDL_ClearHints", dynlib: SDL2_LIB.}
  ##  Clear all hints
  ##
  ##  This function is called during ``quit()`` to free stored hints.
