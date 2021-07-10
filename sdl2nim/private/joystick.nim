#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>
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

##  joystick.nim
##  ============
##
##  Include file for SDL joystick event handling.

##  The term ``device_index`` identifies currently plugged in joystick devices
##  between `0` and ``numJoysticks()``, with the exact joystick behind a
##  device_index changing as joysticks are plugged and unplugged.
##
##  The term ``instance_id`` is the current instantiation of a joystick device
##  in the system, if the joystick is removed and then re-inserted then it will
##  get a new instance_id, instance_id's are monotonically increasing
##  identifiers of a joystick plugged in.
##
##  The term ``JoystickGUID`` is a stable 128-bit identifier for a joystick
##  device that does not change over time, it identifies class of the device
##  (a X360 wired controller for example).
##  This identifier is platform dependent.

##  In order to use these procedures, ``init()`` must have been called
##  with the `INIT_JOYSTICK` flag.  This causes SDL to scan the system
##  for joysticks, and load appropriate drivers.
##
##  If you would like to receive joystick updates while the application
##  is in the background, you should set the following hint before calling
##  ``init()``: `HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS`

type
  Joystick* = pointer ##  \
    ##  An object that encodes the stable unique id for a joystick device

  JoystickGUID* = object
    data*: array[16, uint8]

  JoystickID* = int32 ##  \
    ##  This is a unique ID for a joystick for the time it is connected to the
    ##  system, and is never reused for the lifetime of the application. If the
    ##  joystick is disconnected and reconnected, it will get a new ID.
    ##
    ##  The ID value starts at `0` and increments from there.
    ##  The value `-1` is an invalid ID.

  JoystickType* {.size: sizeof(cint).} = enum
    JOYSTICK_TYPE_UNKNOWN,
    JOYSTICK_TYPE_GAMECONTROLLER,
    JOYSTICK_TYPE_WHEEL,
    JOYSTICK_TYPE_ARCADE_STICK,
    JOYSTICK_TYPE_FLIGHT_STICK,
    JOYSTICK_TYPE_DANCE_PAD,
    JOYSTICK_TYPE_GUITAR,
    JOYSTICK_TYPE_DRUM_KIT,
    JOYSTICK_TYPE_ARCADE_PAD,
    JOYSTICK_TYPE_THROTTLE

  JoystickPowerLevel* {.size: sizeof(cint).} = enum
    JOYSTICK_POWER_UNKNOWN = - 1,
    JOYSTICK_POWER_EMPTY,   ##  <= 5%
    JOYSTICK_POWER_LOW,     ##  <= 20%
    JOYSTICK_POWER_MEDIUM,  ##  <= 70%
    JOYSTICK_POWER_FULL,    ##  <= 100%
    JOYSTICK_POWER_WIRED,
    JOYSTICK_POWER_MAX

const
  IPHONE_MAX_GFORCE* = 5.0  ##  \
    ##  Set max recognized G-force from accelerometer
    ##  See src/joystick/uikit/SDL_sysjoystick.m for notes on why this is needed


# Procedures

proc lockJoysticks*() {.
    cdecl, importc: "SDL_LockJoysticks", dynlib: SDL2_LIB.}
  ##  Locking for multi-threaded access to the joystick API.
  ##
  ##  If you are using the joystick API or handling events from multiple threads
  ##  you should use these locking procedures to protect access
  ##  to the joysticks.
  ##
  ##  In particular, you are guaranteed that the joystick list won't change, so
  ##  the API procedures that take a joystick index will be valid, and joystick
  ##  and game controller events will not be delivered.

proc unlockJoysticks*() {.
    cdecl, importc: "SDL_UnlockJoysticks", dynlib: SDL2_LIB.}

proc numJoysticks*(): cint {.
    cdecl, importc: "SDL_NumJoysticks", dynlib: SDL2_LIB.}
  ##  Count the number of joysticks attached to the system right now.

proc joystickNameForIndex*(device_index: cint): cstring {.
    cdecl, importc: "SDL_JoystickNameForIndex", dynlib: SDL2_LIB.}
  ##  Get the implementation dependent name of a joystick.
  ##
  ##  This can be called before any joysticks are opened.
  ##  If no name can be found, this procedure returns `nil`.

proc joystickGetDevicePlayerIndex*(device_index: cint): cint {.
    cdecl, importc: "SDL_JoystickGetDevicePlayerIndex", dynlib: SDL2_LIB.}
  ##  Get the player index of a joystick, or `-1` if it's not available
  ##  This can be called before any joysticks are opened.

proc joystickGetDeviceGUID*(device_index: cint): JoystickGUID {.
    cdecl, importc: "SDL_JoystickGetDeviceGUID", dynlib: SDL2_LIB.}
  ##  Return the GUID for the joystick at this index.
  ##
  ##  This can be called before any joysticks are opened.

proc joystickGetDeviceVendor*(device_index: cint): uint16 {.
    cdecl, importc: "SDL_JoystickGetDeviceVendor", dynlib: SDL2_LIB.}
  ##  Get the USB vendor ID of a joystick, if available.
  ##
  ##  This can be called before any joysticks are opened.
  ##  If the vendor ID isn't available this procedure returns `0`.

proc joystickGetDeviceProduct*(device_index: cint): uint16 {.
    cdecl, importc: "SDL_JoystickGetDeviceProduct", dynlib: SDL2_LIB.}
  ##  Get the USB product ID of a joystick, if available.
  ##
  ##  This can be called before any joysticks are opened.
  ##  If the product ID isn't available this procedure returns `0`.

proc joystickGetDeviceProductVersion*(device_index: cint): uint16 {.
    cdecl, importc: "SDL_JoystickGetDeviceProductVersion", dynlib: SDL2_LIB.}
  ##  Get the product version of a joystick, if available.
  ##
  ##  This can be called before any joysticks are opened.
  ##  If the product version isn't available this procedure returns `0`.

proc joystickGetDeviceType*(device_index: cint): JoystickType {.
    cdecl, importc: "SDL_JoystickGetDeviceType", dynlib: SDL2_LIB.}
  ##  Get the type of a joystick, if available.
  ##
  ##  This can be called before any joysticks are opened.

proc joystickGetDeviceInstanceID*(device_index: cint): JoystickID {.
  cdecl, importc: "SDL_JoystickGetDeviceInstanceID", dynlib: SDL2_LIB.}
  ##  Get the instance ID of a joystick.
  ##
  ##  This can be called before any joysticks are opened.
  ##  If the index is out of range, this procedure will return `-1`.

proc joystickOpen*(device_index: cint): Joystick {.
    cdecl, importc: "SDL_JoystickOpen", dynlib: SDL2_LIB.}
  ##  Open a joystick for use.
  ##
  ##  The index passed as an argument refers to the N'th joystick on the system.
  ##  This index is not the value which will identify this joystick in future
  ##  joystick events. The joystick's instance id (``JoystickID``) will be used
  ##  there instead.
  ##
  ##  ``Return`` a joystick identifier, or `nil` if an error occurred.

proc joystickFromInstanceID*(instance_id: JoystickID): Joystick {.
    cdecl, importc: "SDL_JoystickFromInstanceID", dynlib: SDL2_LIB.}
  ##  ``Return`` the ``Joystick`` associated with an instance id.

proc joystickFromPlayerIndex*(player_index: cint): Joystick {.
    cdecl, importc: "SDL_JoystickFromPlayerIndex", dynlib: SDL2_LIB.}
  ##  ``Return`` the ``Joystick`` associated with a player index.


proc joystickAttachVirtual*(
    joystickType: JoystickType;
    naxes, nbuttons, nhats: cint): cint {.
      cdecl, importc: "SDL_JoystickAttachVirtual", dynlib: SDL2_LIB.}
  ##  Attaches a new virtual joystick.
  ##
  ##  ``Return`` the joystick's device index, or `-1` if an error occurred.

proc joystickDetachVirtual*(device_index: cint): cint {.
    cdecl, importc: "SDL_JoystickDetachVirtual", dynlib: SDL2_LIB.}
  ##  Detaches a virtual joystick.
  ##
  ##  ``Return`` `0` on success, or `-1` if an error occurred.

proc joystickIsVirtual*(device_index: cint): bool {.
    cdecl, importc: "SDL_JoystickIsVirtual", dynlib: SDL2_LIB.}
  ##  Indicates whether or not a virtual-joystick is at a given device index.

proc joystickSetVirtualAxis*(
    joystick: Joystick; axis: cint; value: int16): cint {.
      cdecl, importc: "SDL_JoystickSetVirtualAxis", dynlib: SDL2_LIB.}
  ##  Set values on an opened, virtual-joystick's controls.
  ##
  ##  Please note that values set here will not be applied until the next
  ##  call to ``sdl.joystickUpdate()``, which can either be called directly,
  ##  or can be called indirectly through various other SDL APIS,
  ##  including, but not limited to the following: ``sdl.pollEvent()``,
  ##  ``sdl.pumpEvents()``, ``sdl.waitEventTimeout()``, ``sdl.waitEvent()``.
  ##
  ##  ``Return`` `0` on success, `-1` on error.

proc joystickSetVirtualButton*(
    joystick: Joystick; button: cint; value: uint8): cint {.
      cdecl, importc: "SDL_JoystickSetVirtualButton", dynlib: SDL2_LIB.}
  ##  See ``joystickSetVirtualAxis()``

proc joystickSetVirtualHat*(
    joystick: Joystick; hat: cint; value: uint8): cint {.
      cdecl, importc: "SDL_JoystickSetVirtualHat", dynlib: SDL2_LIB.}
  ##  See ``joystickSetVirtualAxis()``

proc joystickName*(joystick: Joystick): cstring {.
    cdecl, importc: "SDL_JoystickName", dynlib: SDL2_LIB.}
  ##  ``Return`` the name for this currently opened joystick.
  ##  If no name can be found, this procedure returns `nil`.

proc joystickGetPlayerIndex*(joystick: Joystick): cint {.
    cdecl, importc: "SDL_JoystickGetPlayerIndex", dynlib: SDL2_LIB.}
  ##  Get the player index of an opened joystick, or `-1` if it's not available
  ##
  ##  For XInput controllers this returns the XInput user index.

proc joystickSetPlayerIndex*(joystick: Joystick, player_index: cint) {.
    cdecl, importc: "SDL_JoystickSetPlayerIndex", dynlib: SDL2_LIB.}
  ##  Set the player index of an opened joystick.

proc joystickGetGUID*(joystick: Joystick): JoystickGUID {.
    cdecl, importc: "SDL_JoystickGetGUID", dynlib: SDL2_LIB.}
  ##  ``Return`` the GUID for this opened joystick.

proc joystickGetVendor*(joystick: Joystick): uint16 {.
    cdecl, importc: "SDL_JoystickGetVendor", dynlib: SDL2_LIB.}
  ##  ``Return`` the USB vendor ID of an opened joystick, if available.
  ##  If the vendor ID isn't available this procedure returns `0`.

proc joystickGetProduct*(joystick: Joystick): uint16 {.
    cdecl, importc: "SDL_JoystickGetProduct", dynlib: SDL2_LIB.}
  ##  ``Return`` the USB product ID of an opened joystick, if available.
  ##  If the product ID isn't available this procedure returns `0`.

proc joystickGetProductVersion*(joystick: Joystick): uint16 {.
    cdecl, importc: "SDL_JoystickGetProductVersion", dynlib: SDL2_LIB.}
  ##  ``Return`` the product version of an opened joystick, if available.
  ##  If the product version isn't available this procedure returns `0`.

proc joystickGetSerial*(joystick: Joystick): cstring {.
    cdecl, importc: "SDL_JoystickGetSerial", dynlib: SDL2_LIB.}
  ##  Get the serial number of an opened joystick, if available.
  ##
  ##  ``Return`` the serial number of the joystick,
  ##  or `nil` if it is not available.

proc joystickGetType*(joystick: Joystick): JoystickType {.
    cdecl, importc: "SDL_JoystickGetType", dynlib: SDL2_LIB.}
  ##  ``Return`` the type of an opened joystick.

proc joystickGetGUIDString*(
    guid: JoystickGUID; pszGUID: cstring; cbGUID: cint) {.
      cdecl, importc: "SDL_JoystickGetGUIDString", dynlib: SDL2_LIB.}
  ##  ``Return`` a string representation for this guid.
  ##
  ##  ``pszGUID`` must point to at least 33 bytes
  ##  (32 for the string plus a `nil` terminator).

proc joystickGetGUIDFromString*(pchGUID: cstring): JoystickGUID {.
    cdecl, importc: "SDL_JoystickGetGUIDFromString", dynlib: SDL2_LIB.}
  ##  Convert a string into a joystick GUID.

proc joystickGetAttached*(joystick: Joystick): bool {.
    cdecl, importc: "SDL_JoystickGetAttached", dynlib: SDL2_LIB.}
  ##  ``Return`` `true` if the joystick has been opened and currently
  ##  connected, or `false` if it has not.

proc joystickInstanceID*(joystick: Joystick): JoystickID {.
    cdecl, importc: "SDL_JoystickInstanceID", dynlib: SDL2_LIB.}
  ##  Get the instance ID of an opened joystick,
  ##  or `-1` if the joystick is invalid.

proc joystickNumAxes*(joystick: Joystick): cint {.
    cdecl, importc: "SDL_JoystickNumAxes", dynlib: SDL2_LIB.}
  ##  Get the number of general axis controls on a joystick.

proc joystickNumBalls*(joystick: Joystick): cint {.
    cdecl, importc: "SDL_JoystickNumBalls", dynlib: SDL2_LIB.}
  ##  Get the number of trackballs on a joystick.
  ##
  ##  Joystick trackballs have only relative motion events associated
  ##  with them and their state cannot be polled.

proc joystickNumHats*(joystick: Joystick): cint {.
    cdecl, importc: "SDL_JoystickNumHats", dynlib: SDL2_LIB.}
  ##  Get the number of POV hats on a joystick.

proc joystickNumButtons*(joystick: Joystick): cint {.
    cdecl, importc: "SDL_JoystickNumButtons", dynlib: SDL2_LIB.}
  ##  Get the number of buttons on a joystick.

proc joystickUpdate*() {.
    cdecl, importc: "SDL_JoystickUpdate", dynlib: SDL2_LIB.}
  ##  Update the current state of the open joysticks.
  ##
  ##  This is called automatically by the event loop if any joystick
  ##  events are enabled.

proc joystickEventState*(state: cint): cint {.
    cdecl, importc: "SDL_JoystickEventState", dynlib: SDL2_LIB.}
  ##  Enable/disable joystick event polling.
  ##
  ##  If joystick events are disabled, you must call ``joystickUpdate()``
  ##  yourself and check the state of the joystick when you want joystick
  ##  information.
  ##
  ##  The ``state`` can be one of `QUERY`, `ENABLE` or `IGNORE`.

const
  JOYSTICK_AXIS_MAX* = 32767
  JOYSTICK_AXIS_MIN* = -32768

proc joystickGetAxis*(joystick: Joystick; axis: cint): int16 {.
    cdecl, importc: "SDL_JoystickGetAxis", dynlib: SDL2_LIB.}
  ##  Get the current state of an axis control on a joystick.
  ##
  ##  The state is a value ranging from `-32768` to `32767`.
  ##
  ##  The axis indices start at index `0`.

proc joystickGetAxisInitialState*(joystick: Joystick, axis: cint, state: ptr int16): cint {.
    cdecl, importc: "SDL_JoystickGetAxisInitialState", dynlib: SDL2_LIB.}
  ##  Get the initial state of an axis control on a joystick.
  ##
  ##  The state is a value ranging from `-32768` to `32767`.
  ##
  ##  The axis indices start at index `0`.
  ##
  ##  ``Return`` `1` if this axis has any initial value, or `0` if not.


# Hat positions
#[
const
  HAT_CENTERED* = 0x00000000
  HAT_UP* = 0x00000001
  HAT_RIGHT* = 0x00000002
  HAT_DOWN* = 0x00000004
  HAT_LEFT* = 0x00000008
  HAT_RIGHTUP* = (HAT_RIGHT or HAT_UP)
  HAT_RIGHTDOWN* = (HAT_RIGHT or HAT_DOWN)
  HAT_LEFTUP* = (HAT_LEFT or HAT_UP)
  HAT_LEFTDOWN* = (HAT_LEFT or HAT_DOWN)
]#

type
  HatPosition* {.size: sizeof(uint8).} = enum
    HAT_CENTERED = 0x00000000,
    HAT_UP = 0x00000001,
    HAT_RIGHT = 0x00000002,
    HAT_RIGHTUP = (HAT_RIGHT.uint8 or HAT_UP.uint8),
    HAT_DOWN = 0x00000004,
    HAT_RIGHTDOWN = (HAT_RIGHT.uint8 or HAT_DOWN.uint8),
    HAT_LEFT = 0x00000008,
    HAT_LEFTUP = (HAT_LEFT.uint8 or HAT_UP.uint8),
    HAT_LEFTDOWN = (HAT_LEFT.uint8 or HAT_DOWN.uint8)


proc joystickGetHat*(joystick: Joystick; hat: cint): HatPosition {.
    cdecl, importc: "SDL_JoystickGetHat", dynlib: SDL2_LIB.}
  ##  Get the current state of a POV hat on a joystick.
  ##
  ##  The hat indices start at index `0`.
  ##
  ##  ``Return`` The return value is one of the following positions:
  ##  * HAT_CENTERED
  ##  * HAT_UP
  ##  * HAT_RIGHT
  ##  * HAT_DOWN
  ##  * HAT_LEFT
  ##  * HAT_RIGHTUP
  ##  * HAT_RIGHTDOWN
  ##  * HAT_LEFTUP
  ##  * HAT_LEFTDOWN

proc joystickGetBall*(
    joystick: Joystick; ball: cint; dx: ptr cint; dy: ptr cint): cint {.
      cdecl, importc: "SDL_JoystickGetBall", dynlib: SDL2_LIB.}
  ##  Get the ball axis change since the last poll.
  ##
  ##  ``Return`` `0`, or `-1` if you passed it invalid parameters.
  ##
  ##  The ball indices start at index `0`.

proc joystickGetButton*(joystick: Joystick; button: cint): uint8 {.
    cdecl, importc: "SDL_JoystickGetButton", dynlib: SDL2_LIB.}
  ##  Get the current state of a button on a joystick.
  ##
  ##  The button indices start at index `0`.

proc joystickRumble*(
  joystick: Joystick; low_frequency_rumble: uint16;
  high_frequency_rumble: uint16; duration_ms: uint32): cint {.
    cdecl, importc: "SDL_JoystickRumble", dynlib: SDL2_LIB.}
  ##  Start a rumble effect.
  ##
  ##  Each call to this procedure cancels any previous rumble effect,
  ##  and calling it with `0` intensity stops any rumbling.
  ##
  ##  ``joystick`` The joystick to vibrate
  ##
  ##  ``low_frequency_rumble`` The intensity of the low frequency
  ##  (left) rumble motor, from `0` to `0xFFFF`
  ##
  ##  ``high_frequency_rumble`` The intensity of the high frequency
  ##  (right) rumble motor, from `0` to `0xFFFF`
  ##
  ##  ``duration_ms`` The duration of the rumble effect, in milliseconds
  ##
  ##  ``Return`` `0`, or `-1` if rumble isn't supported on this joystick.


proc joystickRumbleTriggers*(
    joystick: Joystick;
    left_rumble, right_rumble: uint16; duration_ms: uint32): cint {.
      cdecl, importc: "SDL_JoystickRumbleTriggers", dynlib: SDL2_LIB.}
  ##  Start a rumble effect in the joystick's triggers.
  ##  Each call to this procedure cancels any previous trigger rumble effect,
  ##  and calling it with 0 intensity stops any rumbling.
  ##
  ##  ``joystick`` The joystick to vibrate
  ##
  ##  ``left_rumble`` The intensity of the left trigger rumble motor,
  ##  from `0` to `0xFFFF`
  ##
  ##  ``right_rumble`` The intensity of the right trigger rumble motor,
  ##  from `0` to `0xFFFF`
  ##
  ##  ``duration_ms`` The duration of the rumble effect, in milliseconds
  ##
  ##  ``Return`` `0`,
  ##  or `-1` if trigger rumble isn't supported on this joystick.

proc joystickHasLED*(joystick: Joystick): bool {.
    cdecl, importc: "SDL_JoystickHasLED", dynlib: SDL2_LIB.}
  ##  Return whether a joystick has an LED.
  ##
  ##  ``joystick`` The joystick to query
  ##
  ##  ``Return`` `true`,
  ##  or `false` if this joystick does not have a modifiable LED

proc joystickSetLED*(joystick: Joystick; red, green, blue: uint8): cint {.
    cdecl, importc: "SDL_JoystickSetLED", dynlib: SDL2_LIB.}
  ##  Update a joystick's LED color.
  ##
  ##  ``joystick`` The joystick to update
  ##
  ##  ``red`` The intensity of the red LED
  ##
  ##  ``green`` The intensity of the green LED
  ##
  ##  ``blue`` The intensity of the blue LED
  ##
  ##  ``Return`` `0`, or `-1` if this joystick does not have a modifiable LED.

proc joystickClose*(joystick: Joystick) {.
    cdecl, importc: "SDL_JoystickClose", dynlib: SDL2_LIB.}
  ##  Close a joystick previously opened with ``joystickOpen()``.

proc joystickCurrentPowerLevel*(joystick: Joystick): JoystickPowerLevel {.
    cdecl, importc: "SDL_JoystickCurrentPowerLevel", dynlib: SDL2_LIB.}
  ##  Return the battery level of this ``joystick``.
