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

##  joystick.nim
##  ============
##
##  Include file for SDL joystick event handling.

##  The term "device_index" identifies currently plugged in joystick devices
##  between `0` and ``numJoysticks()``, with the exact joystick behind a
##  device_index changing as joysticks are plugged and unplugged.
##
##  The term "instance_id" is the current instantiation of a joystick device
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

  JoystickID* = int32

  JoystickPowerLevel* {.size: sizeof(cint).} = enum
    JOYSTICK_POWER_UNKNOWN = - 1,
    JOYSTICK_POWER_EMPTY,
    JOYSTICK_POWER_LOW,
    JOYSTICK_POWER_MEDIUM,
    JOYSTICK_POWER_FULL,
    JOYSTICK_POWER_WIRED,
    JOYSTICK_POWER_MAX

# Procedures

proc numJoysticks*(): cint {.
    cdecl, importc: "SDL_NumJoysticks", dynlib: SDL2_LIB.}
  ##  Count the number of joysticks attached to the system right now.

proc joystickNameForIndex*(device_index: cint): cstring {.
    cdecl, importc: "SDL_JoystickNameForIndex", dynlib: SDL2_LIB.}
  ##  Get the implementation dependent name of a joystick.
  ##
  ##  This can be called before any joysticks are opened.
  ##  If no name can be found, this procedure returns `nil`.

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

proc joystickFromInstanceID*(joyid: JoystickID): Joystick {.
    cdecl, importc: "SDL_JoystickFromInstanceID", dynlib: SDL2_LIB.}
  ##  ``Return`` the ``Joystick`` associated with an instance id.

proc joystickName*(joystick: Joystick): cstring {.
    cdecl, importc: "SDL_JoystickName", dynlib: SDL2_LIB.}
  ##  ``Return`` the name for this currently opened joystick.
  ##  If no name can be found, this procedure returns `nil`.

proc joystickGetDeviceGUID*(device_index: cint): JoystickGUID {.
    cdecl, importc: "SDL_JoystickGetDeviceGUID", dynlib: SDL2_LIB.}
  ##  ``Return`` the GUID for the joystick at this index.

proc joystickGetGUID*(joystick: Joystick): JoystickGUID {.
    cdecl, importc: "SDL_JoystickGetGUID", dynlib: SDL2_LIB.}
  ##  ``Return`` the GUID for this opened joystick.

proc joystickGetGUIDString*(
    guid: JoystickGUID; pszGUID: cstring; cbGUID: cint) {.
      cdecl, importc: "SDL_JoystickGetGUIDString", dynlib: SDL2_LIB.}
  ##  ``Return`` a string representation for this guid.
  ##
  ##  ``pszGUID`` must point to at least 33 bytes
  ##  (32 for the string plus a `nil` terminator).

proc joystickGetGUIDFromString*(pchGUID: cstring): JoystickGUID {.
    cdecl, importc: "SDL_JoystickGetGUIDFromString", dynlib: SDL2_LIB.}
  ##  Convert a string into a joystick formatted GUID.

proc joystickGetAttached*(joystick: Joystick): bool {.
    cdecl, importc: "SDL_JoystickGetAttached", dynlib: SDL2_LIB.}
  ##  ``Returns`` `true` if the joystick has been opened and currently
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

proc joystickGetAxis*(joystick: Joystick; axis: cint): int16 {.
    cdecl, importc: "SDL_JoystickGetAxis", dynlib: SDL2_LIB.}
  ##  Get the current state of an axis control on a joystick.
  ##
  ##  The state is a value ranging from `-32768` to `32767`.
  ##
  ##  The axis indices start at index `0`.

# Hat positions
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

proc joystickGetHat*(joystick: Joystick; hat: cint): uint8 {.
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

proc joystickClose*(joystick: Joystick) {.
    cdecl, importc: "SDL_JoystickClose", dynlib: SDL2_LIB.}
  ##  Close a joystick previously opened with ``joystickOpen()``.

proc joystickCurrentPowerLevel*(joystick: Joystick): JoystickPowerLevel {.
    cdecl, importc: "SDL_JoystickCurrentPowerLevel", dynlib: SDL2_LIB.}
  ##  Return the battery level of this ``joystick``.

