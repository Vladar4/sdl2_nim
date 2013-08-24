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
# Include file for SDL joystick event handling
#
# The term "device_index" identifies currently plugged in joystick devices
# between 0 and numJoysticks, with the exact joystick
# behind a device_index changing as joysticks are plugged and unplugged.
#
# The term "instance_id" is the current instantiation of a joystick device
# in the system, if the joystick is removed and then re-inserted
# then it will get a new instance_id, instance_id's are monotonically
# increasing identifiers of a joystick plugged in.
#
# The term JoystickGUID is a stable 128-bit identifier for a joystick device
# that does not change over time, it identifies class of
# the device (a X360 wired controller for example).
# This identifier is platform dependent.
#


#
# In order to use these functions, init() must have been called
# with the INIT_JOYSTICK flag. This causes SDL to scan the system
# for joysticks, and load appropriate drivers.
#


type

  PJoystick* = pointer ## The joystick structure used to identify an SDL joystick


  TJoystickGUID*{.bycopy.} = object
    ## A structure that encodes the stable unique id for a joystick device
    data*: array[0..15, Uint8]


  TJoystickID* = int32


# Function prototypes


proc numJoysticks*(): int {.cdecl, importc: "SDL_NumJoysticks", dynlib: LibName.}
  ## Count the number of joysticks attached to the system right now


proc joystickNameForIndex*(device_index: int): cstring {.cdecl, importc: "SDL_JoystickNameForIndex", dynlib: LibName.}
  ## Get the implementation dependent name of a joystick.
  ## This can be called before any joysticks are opened.
  ##  If no name can be found, this function returns nil.


proc joystickOpen*(device_index: int): PJoystick {.cdecl, importc: "SDL_JoystickOpen", dynlib: LibName.}
  ## Open a joystick for use.
  ## The index passed as an argument refers tothe N'th joystick on the system.
  ## This index is the value which will identify this joystick in future
  ## joystick events.
  ##
  ## Return a joystick identifier, or nil if an error occurred.


proc joystickName*(joystick: PJoystick): cstring {.cdecl, importc: "SDL_JoystickName", dynlib: LibName.}
  ## Return the name for this currently opened joystick.
  ## If no name can be found, this function returns nil.


proc joystickGetDeviceGUID*(device_index: int): TJoystickGUID {.cdecl, importc: "SDL_JoystickGetDeviceGUID", dynlib: LibName.}
  ## Return the GUID for the joystick at this index


proc joystickGetGUID*(joystick: PJoystick): TJoystickGUID {.cdecl, importc: "SDL_JoystickGetGUID", dynlib: LibName.}
  ## Return the GUID for this opened joystick


proc joystickGetGUIDString*(guid: TJoystickGUID, pszGUID: cstring, cbGUID: int) {.cdecl, importc: "SDL_JoystickGetGUIDString", dynlib: LibName.}
  ## Return a string representation for this guid.
  ## pszGUID must point to at least 33 bytes
  ## (32 for the string plus a nil terminator).

proc joystickGetGUIDFromString*(pchGUID: cstring): TJoystickGUID {.cdecl, importc: "SDL_JoystickGetGUIDFromString", dynlib: LibName.}
  ## convert a string into a joystick formatted guid


proc joystickGetAttached*(joystick: PJoystick): bool {.cdecl, importc: "SDL_JoystickGetAttached", dynlib: LibName.}
  ## Returns TRUE if the joystick has been opened and currently connected,
  ## or FALSE if it has not.


proc joystickInstanceID*(joystick: PJoystick): TJoystickID {.cdecl, importc: "SDL_JoystickInstanceID", dynlib: LibName.}
  ## Get the instance ID of an opened joystick or -1 if the joystick is invalid.


proc joystickNumAxes*(joystick: PJoystick): int {.cdecl, importc: "SDL_JoystickNumAxes", dynlib: LibName.}
  ## Get the number of general axis controls on a joystick.


proc joystickNumBalls*(joystick: PJoystick): int {.cdecl, importc: "SDL_JoystickNumBalls", dynlib: LibName.}
  ## Get the number of trackballs on a joystick.
  ##
  ## Joystick trackballs have only relative motion events associated
  ## with them and their state cannot be polled.


proc joystickNumHats*(joystick: PJoystick): int {.cdecl, importc: "SDL_JoystickNumHats", dynlib: LibName.}
  ## Get the number of POV hats on a joystick.


proc joystickNumButtons*(joystick: PJoystick): int {.cdecl, importc: "SDL_JoystickNumButtons", dynlib: LibName.}
  ## Get the number of buttons on a joystick.


proc joystickUpdate*() {.cdecl, importc: "SDL_JoystickUpdate", dynlib: LibName.}
  ## Update the current state of the open joysticks.
  ##
  ## This is called automatically by the event loop if any joystick
  ## events are enabled.


proc joystickEventState*(state: int): int {.cdecl, importc: "SDL_JoystickEventState", dynlib: LibName.}
  ## Enable/disable joystick event polling.
  ##
  ## If joystick events are disabled, you must call joystickUpdate()
  ## yourself and check the state of the joystick when you want joystick
  ## information.
  ##
  ## The state can be one of QUERY, ENABLE or IGNORE.


proc joystickGetAxis*(joystick: PJoystick, axis: int): int16 {.cdecl, importc: "SDL_JoystickGetAxis", dynlib: LibName.}
  ## Get the current state of an axis control on a joystick.
  ##
  ## The state is a value ranging from -32768 to 32767.
  ##
  ## The axis indices start at index 0.

#
# Hat positions
#
const
  HAT_CENTERED* = 0x00
  HAT_UP* = 0x01
  HAT_RIGHT* = 0x02
  HAT_DOWN* = 0x04
  HAT_LEFT* = 0x08
  HAT_RIGHTUP* = (HAT_RIGHT or HAT_UP)
  HAT_RIGHTDOWN* = (HAT_RIGHT or HAT_DOWN)
  HAT_LEFTUP* = (HAT_LEFT or HAT_UP)
  HAT_LEFTDOWN* = (HAT_LEFT or HAT_DOWN)


proc joystickGetHat*(joystick: PJoystick, hat: int): Uint8 {.cdecl, importc: "SDL_JoystickGetHat", dynlib: LibName.}
  ## Get the current state of a POV hat on a joystick.
  ##
  ## The hat indices start at index 0.
  ##
  ## Return The return value is one of the following positions:
  ##
  ## * HAT_CENTERED
  ##
  ## * HAT_UP
  ##
  ## * HAT_RIGHT
  ##
  ## * HAT_DOWN
  ##
  ## * HAT_LEFT
  ##
  ## * HAT_RIGHTUP
  ##
  ## * HAT_RIGHTDOWN
  ##
  ## * HAT_LEFTUP
  ##
  ## * HAT_LEFTDOWN

proc joystickGetBall*(joystick: PJoystick,
    ball: int , dx, dy: ptr int): int {.cdecl, importc: "SDL_JoystickGetBall", dynlib: LibName.}
  ## Get the ball axis change since the last poll.
  ##
  ## Return 0, or -1 if you passed it invalid parameters.
  ##
  ## The ball indices start at index 0.


proc joystickGetButton*(joystick: PJoystick, button: int): Uint8 {.cdecl, importc: "SDL_JoystickGetButton", dynlib: LibName.}
  ## Get the current state of a button on a joystick.
  ##
  ## The button indices start at index 0.

proc joystickClose*(joystick: PJoystick) {.cdecl, importc: "SDL_JoystickClose", dynlib: LibName.}
  ## Close a joystick previously opened with joystickOpen().

