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

##  hints.nim
##  =========
##
##  Official documentation for SDL configuration variables.
##
##  This file contains procedures to set and get configuration hints,
##  as well as listing each of them alphabetically.
##
##  The convention for naming hints is `HINT_X`, where "X" is
##  the environment variable that can be used to override the default.
##
##  In general these hints are just that - they may or may not be
##  supported or applicable on any given platform, but they provide
##  a way for an application or user to give the library a hint as
##  to how they would like the library to work.

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
  HINT_RENDER_DIRECT3D11_DEBUG* = "SDL_RENDER_DIRECT3D11_DEBUG" ##  \
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
    ##  By default nearest pixel sampling is used.

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
  HINT_VIDEO_X11_NET_WM_PING* = "SDL_VIDEO_X11_NET_WM_PING" ##  \
    ##  A variable controlling whether the X11 _NET_WM_PING protocol
    ##  should be supported.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Disable _NET_WM_PING
    ##  * "1"       - Enable _NET_WM_PING
    ##
    ##  By default SDL will use _NET_WM_PING, but for applications that know
    ##  they will not always be able to respond to ping requests in a timely
    ##  manner they can turn it off to avoid the window manager thinking the
    ##  app is hung.
    ##
    ##  The hint is checked in ``createWindow()``.

const
  HINT_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN* = "SDL_WINDOW_FRAME_USABLE_WHILE_CURSOR_HIDDEN" ##  \
    ##  A variable controlling whether the window frame and title bar are
    ##  interactive when the cursor is hidden.
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - The window frame is not interactive when the cursor is
    ##    hidden (no move, resize, etc)
    ##  * "1"       - The window frame is interactive when the cursor is hidden
    ##
    ##  By default SDL will allow interaction with the window frame
    ##  when the cursor is hidden.

const
  HINT_WINDOWS_ENABLE_MESSAGELOOP* = "SDL_WINDOWS_ENABLE_MESSAGELOOP" ##  \
    ##  A variable controlling whether the windows message loop is processed
    ##  by SDL
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - The window message loop is not run
    ##  * "1"       - The window message loop is processed in ``pumpEvents()``
    ##
    ##  By default SDL will process the windows message loop.


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
    ##  By default SDL will use raw input for relative mouse mode.

const
  HINT_MOUSE_FOCUS_CLICKTHROUGH* = "SDL_MOUSE_FOCUS_CLICKTHROUGH" ##  \
    ##  Allow mouse click events when clicking to focus an SDL window
    ##
    ##  This variable can be set to the following values:
    ##  * "0"       - Ignore mouse clicks that activate a window
    ##  * "1"       - Generate events for mouse clicks that activate a window
    ##
    ##  By default SDL will ignore mouse clicks that activate a window.

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
    ##  As of SDL 2.0.4, ``sdl.enableScreenSaver()`` and
    ##  ``sdl.disableScreenSaver()`` accomplish the same thing on iOS.
    ##  They should be preferred over this hint.
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
  HINT_APPLE_TV_CONTROLLER_UI_EVENTS* = "SDL_APPLE_TV_CONTROLLER_UI_EVENTS" ##  \
    ##  A variable controlling whether controllers used with the Apple TV
    ##  generate UI events.
    ##
    ##  When UI events are generated by controller input, the app will be
    ##  backgrounded when the Apple TV remote's menu button is pressed, and
    ##  when the pause or B buttons on gamepads are pressed.
    ##
    ##  More information about properly making use of controllers for the
    ##  Apple TV can be found here:
    ##  https://developer.apple.com/tvos/human-interface-guidelines/remote-and-controllers/
    ##
    ##  This variable can be set to the following values:
    ##  * "0"     - Controller input does not generate UI events (the default).
    ##  * "1"     - Controller input generates UI events.

const
  HINT_APPLE_TV_REMOTE_ALLOW_ROTATION* = "SDL_APPLE_TV_REMOTE_ALLOW_ROTATION" ##  \
    ##  A variable controlling whether the Apple TV remote's joystick axes
    ##  will automatically match the rotation of the remote.
    ##
    ##  This variable can be set to the following values:
    ##  * "0" - Remote orientation does not affect joystick axes (the default).
    ##  * "1" - Joystick axes are based on the orientation of the remote.

const
  HINT_ACCELEROMETER_AS_JOYSTICK* = "SDL_ACCELEROMETER_AS_JOYSTICK" ##  \
    ##  A variable controlling whether an Android / iOS built-in accelerometer
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
  HINT_XINPUT_USE_OLD_JOYSTICK_MAPPING* = "SDL_XINPUT_USE_OLD_JOYSTICK_MAPPING"  ##  \
    ## A variable that causes SDL to use the old axis and button mapping for
    ## XInput devices.
    ##
    ##  This hint is for backwards compatibility only and will be removed in
    ##  SDL 2.1.
    ##
    ##  The default value is `0`.  This hint must be set before ``sdl.init()``.

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
  HINT_THREAD_STACK_SIZE* = "SDL_THREAD_STACK_SIZE" ##  \
    ##  A string specifying SDL's threads stack size in bytes
    ##  or `0` for the backend's default size.
    ##
    ##  Use this hint in case you need to set SDL's threads stack size to other
    ##  than the default.
    ##
    ##  This is specially useful if you build SDL against a non glibc libc
    ##  library (such as musl) which provides a relatively small default thread
    ##  stack size (a few kilobytes versus the default 8MB glibc uses).
    ##
    ##  Support for this hint is currently available only in the pthread,
    ##  Windows, and PSP backend.

const
  HINT_VIDEO_HIGHDPI_DISABLED* = "SDL_VIDEO_HIGHDPI_DISABLED" ##  \
    ##  If set to 1, then do not allow high-DPI windows.
    ##  ("Retina" on Mac and iOS)

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
  HINT_WINRT_PRIVACY_POLICY_URL* = "SDL_WINRT_PRIVACY_POLICY_URL" ##  \
    ##  A URL to a WinRT app's privacy policy
    ##
    ##  All network-enabled WinRT apps must make a privacy policy available
    ##  to its users.  On Windows 8, 8.1, and RT, Microsoft mandates that this
    ##  policy be be available in the Windows Settings charm, as accessed from
    ##  within the app. SDL provides code to add a URL-based link there, which
    ##  can point to the app's privacy policy.
    ##
    ##  To setup a URL to an app's privacy policy, set
    ##  `HINT_WINRT_PRIVACY_POLICY_URL` before calling any ``sdl.init()``
    ##  procedures. The contents of the hint should be a valid URL.
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
  HINT_WINRT_PRIVACY_POLICY_LABEL* = "SDL_WINRT_PRIVACY_POLICY_LABEL" ##  \
    ##  Label text for a WinRT app's privacy policy link
    ##
    ##  Network-enabled WinRT apps must include a privacy policy.
    ##  On Windows 8, 8.1, and RT, Microsoft mandates that this policy be
    ##  available via the Windows Settings charm. SDL provides code to add a
    ##  link there, with its label text being set via the optional hint,
    ##  `HINT_WINRT_PRIVACY_POLICY_LABEL`.
    ##
    ##  Please note that a privacy policy's contents are not set via this hint.
    ##  A separate hint, `HINT_WINRT_PRIVACY_POLICY_URL`, is used to link
    ##  to the actual text of the policy.
    ##
    ##  The contents of this hint should be encoded as a UTF8 string.
    ##
    ##  The default value is "Privacy Policy".  This hint should only be set
    ##  during app initialization, preferably before any calls
    ##  to ``sdl.init()``.
    ##
    ##  For additional information on linking to a privacy policy, see the
    ##  documentation for `HINT_WINRT_PRIVACY_POLICY_URL`.

const
  HINT_WINRT_HANDLE_BACK_BUTTON* = "SDL_WINRT_HANDLE_BACK_BUTTON" ##  \
    ##  Allows back-button-press events on Windows Phone to be marked
    ##  as handled.
    ##
    ##  Windows Phone devices typically feature a Back button. When pressed,
    ##  the OS will emit back-button-press events, which apps are expected to
    ##  handle in an appropriate manner. If apps do not explicitly mark these
    ##  events as 'Handled', then the OS will invoke its default behavior for
    ##  unhandled back-button-press events, which on Windows Phone 8 and 8.1 is
    ##  to terminate the app (and attempt to switch to the previous app, or to
    ##  the device's home screen).
    ##
    ##  Setting the `HINT_WINRT_HANDLE_BACK_BUTTON` hint to `1` will cause SDL
    ##  to mark back-button-press events as 'Handled', if and when one is sent
    ##  to the app.
    ##
    ##  Internally, Windows Phone sends back button events as parameters to
    ##  special back-button-press callback procedures. Apps that need to respond
    ##  to back-button-press events are expected to register one or more
    ##  callback procedures for such, shortly after being launched (during the
    ##  app's initialization phase). After the back button is pressed, the OS
    ##  will invoke these callbacks. If the app's callback(s) do not explicitly
    ##  mark the event as handled by the time they return, or if the app never
    ##  registers one of these callback, the OS will consider the event
    ##  un-handled, and it will apply its default back button behavior
    ##  (terminate the app).
    ##
    ##  SDL registers its own back-button-press callback with the Windows Phone
    ##  OS.  This callback will emit a pair of SDL key-press events
    ##  (`sdl.KEYDOWN` and `sdl.KEYUP`), each with a scancode of
    ##  `SCANCODE_AC_BACK`, after which it will check the contents of the hint,
    ##  `HINT_WINRT_HANDLE_BACK_BUTTON`.
    ##
    ##  If the hint's value is set to `1`, the back button event's 'Handled'
    ##  property will get set to `true`.  If the hint's value is set to
    ##  something else, or if it is unset, SDL will leave the event's 'Handled'
    ##  property alone. (By default, the OS sets this property to `false`,
    ##  to note.)
    ##
    ##  SDL apps can either set `HINT_WINRT_HANDLE_BACK_BUTTON` well before a
    ##  back button is pressed, or can set it in direct-response to a
    ##  back button being pressed.
    ##
    ##  In order to get notified when a back button is pressed, SDL apps should
    ##  register a callback procedure with ``addEventWatch()``, and have it
    ##  listen for `sdl.KEYDOWN` events that have a scancode of
    ##  `SCANCODE_AC_BACK`.
    ##
    ##  (Alternatively, `sdl.KEYUP` events can be listened-for. Listening for
    ##  either event type is suitable.) Any value of
    ##  `HINT_WINRT_HANDLE_BACK_BUTTON` set by such a callback, will be applied
    ##  to the OS' current back-button-press event.
    ##
    ##  More details on back button behavior in Windows Phone apps can be found
    ##  at the following page, on Microsoft's developer site:
    ##
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
    ##    button on their titlebars).
    ##
    ##  The default value is "1". Spaces are disabled regardless of this hint
    ##  if the OS isn't at least Mac OS X Lion (10.7). This hint must be set
    ##  before any windows are created.

const
  HINT_MAC_BACKGROUND_APP* = "SDL_MAC_BACKGROUND_APP" ##  \
    ##  When set don't force the SDL app to become a foreground process
    ##
    ##  This hint only applies to Mac OS X.

const
  HINT_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION* = "SDL_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION" ##  \
    ##  Android APK expansion main file version.
    ##  Should be a string number like "1", "2" etc.
    ##
    ##  Must be set together with
    ##  `HINT_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION`.
    ##
    ##  If both hints were set then ``rwFromFile()`` will look into expansion
    ##  files after a given relative path was not found in the internal storage
    ##  and assets.
    ##
    ##  By default this hint is not set and the APK expansion files are not
    ##  searched.

const
  HINT_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION* = "SDL_ANDROID_APK_EXPANSION_PATCH_FILE_VERSION"  ##  \
    ##  Android APK expansion patch file version.
    ##  Should be a string number like "1", "2" etc.
    ##
    ##  Must be set together with
    ##  `HINT_ANDROID_APK_EXPANSION_MAIN_FILE_VERSION`.
    ##
    ##  If both hints were set then ``rwFromFile()`` will look into expansion
    ##  files after a given relative path was not found in the internal storage
    ##  and assets.
    ##
    ##  By default this hint is not set and the APK expansion files are not
    ##  searched.

const
  HIND_IME_INTERNAL_EDITING* = "SDL_IME_INTERNAL_EDITING" ##  \
    ##  A variable to control whether certain IMEs should handle text editing
    ##  internally instead of sending `sdl.TEXTEDITING` events.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"       - `sdl.TEXTEDITING` events are sent, and it is the
    ##    application's responsibility to render the text from these events and
    ##    differentiate it somehow from committed text. (default)
    ##  * "1"       - If supported by the IME then `sdl.TEXTEDITING`
    ##    events are not sent, and text that is being composed
    ##    will be rendered in its own UI.

const
  HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH* = "SDL_ANDROID_SEPARATE_MOUSE_AND_TOUCH"  ##  \
    ##  A variable to control whether mouse and touch events are to be treated
    ##  together or separately.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"       - Mouse events will be handled as touch events,
    ##    and touch will raise fake mouse events.
    ##    This is the behaviour of SDL <= 2.0.3. (default)
    ##  * "1"       - Mouse events will be handled separately
    ##    from pure touch events.
    ##
    ##  The value of this hint is used at runtime,
    ##  so it can be changed at any time.

const
  HINT_EMSCRIPTEN_KEYBOARD_ELEMENT* = "SDL_EMSCRIPTEN_KEYBOARD_ELEMENT" ##  \
    ##  Override the binding element for keyboard inputs for Emscripten builds.
    ##
    ##  This hint only applies to the emscripten platform
    ##
    ##  The variable can be one of
    ##  * "#window"      - The javascript window object (this is the default)
    ##  * "#document"    - The javascript document object
    ##  * "#screen"      - the javascript window.screen object
    ##  * "#canvas"      - the WebGL canvas element
    ##  * any other string without a leading `#` sign applies to the element
    ##    on the page with that ID.

const
  HINT_NO_SIGNAL_HANDLERS* = "SDL_NO_SIGNAL_HANDLERS" ##  \
    ##  Tell SDL not to catch the SIGINT or SIGTERM signals.
    ##
    ##  This hint only applies to Unix-like platforms.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"       - SDL will install a SIGINT and SIGTERM handler,
    ##    and when it catches a signal, convert it into an `sdl.QUIT` event.
    ##  * "1"       - SDL will not install a signal handler at all.

const
  HINT_WINDOWS_NO_CLOSE_ON_ALT_F4* = "SDL_WINDOWS_NO_CLOSE_ON_ALT_F4" ##  \
    ##  Tell SDL not to generate window-close events for Alt+F4 on Windows.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"   - SDL will generate a window-close event when it sees Alt+F4.
    ##  * "1"   - SDL will only do normal key handling for Alt+F4.

const
  HINT_BMP_SAVE_LEGACY_FORMAT* = "SDL_BMP_SAVE_LEGACY_FORMAT" ##  \
    ##  Prevent SDL from using version 4 of the bitmap header when saving BMPs.
    ##
    ##  The bitmap header version 4 is required for proper alpha channel
    ##  support and SDL will use it when required. Should this not be desired,
    ##  this hint can force the use of the 40 byte header version which is
    ##  supported everywhere.
    ##
    ##  The variable can be set to the following values:
    ##  * "0"     - Surfaces with a colorkey or an alpha channel are saved to a
    ##    32-bit BMP file with an alpha mask. SDL will use the bitmap
    ##    header version 4 and set the alpha mask accordingly.
    ##  * "1"     - Surfaces with a colorkey or an alpha channel are saved to a
    ##    32-bit BMP file without an alpha mask. The alpha channel data
    ##    will be in the file, but applications are going to ignore it.
    ##
    ##  The default value is "0".

const
  HINT_WINDOWS_DISABLE_THREAD_NAMING* = "SDL_WINDOWS_DISABLE_THREAD_NAMING" ##  \
    ##  Tell SDL not to name threads on Windows.
    ##
    ##  The variable can be set to the following values:
    ##  * "0" - SDL will raise the 0x406D1388 Exception to name threads.
    ##    This is the default behavior of SDL <= 2.0.4. (default)
    ##  * "1" - SDL will not raise this exception, and threads will be unnamed.
    ##    For .NET languages this is required when running under a debugger.

const
  HINT_RPI_VIDEO_LAYER* = "SDL_RPI_VIDEO_LAYER"
    ##  Tell SDL which Dispmanx layer to use on a Raspberry PI
    ##
    ##  Also known as Z-order.
    ##  The variable can take a negative or positive value.
    ##  The default is `10000`.

type
  HintPriority* {.size: sizeof(cint).} = enum ##  \
    ##  An enumeration of hint priorities
    HINT_DEFAULT, HINT_NORMAL, HINT_OVERRIDE

proc setHintWithPriority*(
    name: cstring; value: cstring; priority: HintPriority): bool {.
      cdecl, importc: "SDL_SetHintWithPriority", dynlib: SDL2_LIB.}
  ##  Set a hint with a specific priority.
  ##
  ##  The priority controls the behavior when setting a hint that already
  ##  has a value.  Hints will replace existing hints of their priority and
  ##  lower.  Environment variables are considered to have override priority.
  ##
  ##  ``Return`` `true` if the hint was set, `false` otherwise.

proc setHint*(name: cstring; value: cstring): bool {.
    cdecl, importc: "SDL_SetHint", dynlib: SDL2_LIB.}
  ##  Set a hint with normal priority.
  ##
  ##  ``Return`` `true` if the hint was set, `false` otherwise.

proc getHint*(name: cstring): cstring {.
    cdecl, importc: "SDL_GetHint", dynlib: SDL2_LIB.}
  ##  Get a hint.
  ##
  ##  ``Return`` the string value of a hint variable.

proc getHintBoolean*(name: cstring; default_value: bool): bool {.
    cdecl, importc: "SDL_GetHintBoolean", dynlib: SDL2_LIB.}
  ##  Get a hint.
  ##
  ##  ``Return`` the boolean value of a hint variable.

type
  HintCallback* = proc (
      userdata: pointer; name: cstring;
      oldValue: cstring; newValue: cstring) {.cdecl.}

proc addHintCallback*(
    name: cstring; callback: HintCallback; userdata: pointer) {.
      cdecl, importc: "SDL_AddHintCallback", dynlib: SDL2_LIB.}
  ##  Add a procedure to watch a particular hint.
  ##
  ##  ``name`` The hint to watch.
  ##
  ##  ``callback`` The procedure to call when the hint value changes.
  ##
  ##  ``userdata`` A pointer to pass to the callback procedure.

proc delHintCallback*(
    name: cstring; callback: HintCallback; userdata: pointer) {.
      cdecl, importc: "SDL_DelHintCallback", dynlib: SDL2_LIB.}
  ##  Remove a procedure watching a particular hint.
  ##
  ##  ``name`` The hint being watched.
  ##
  ##  ``callback`` The procedure being called when the hint value changes.
  ##
  ##  ``userdata`` A pointer being passed to the callback procedure.

proc clearHints*() {.
    cdecl, importc: "SDL_ClearHints", dynlib: SDL2_LIB.}
  ##  Clear all hints.
  ##
  ##  This procedure is called during ``quit()`` to free stored hints.
