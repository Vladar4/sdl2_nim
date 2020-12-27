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

##  gamecontroller.nim
##  ==================
##
##  Include file for SDL game controller event handling.
##
##  In order to use these procedures, ``init()`` must have been called
##  with the `INIT_GAMECONTROLLER` flag.  This causes SDL to scan the system
##  for game controllers, and load appropriate drivers.
##
##  If you would like to receive controller updates while the application
##  is in the background, you should set the following hint before calling
##  ``init()``: `HINT_JOYSTICK_ALLOW_BACKGROUND_EVENTS`

type
  GameController* = pointer ##  \
    ##  The gamecontroller structure used to identify an SDL game controller.

  GameControllerType* {.size: sizeof(cint).} = enum
    CONTROLLER_TYPE_UNKNOWN = 0,
    CONTROLLER_TYPE_XBOX360,
    CONTROLLER_TYPE_XBOXONE,
    CONTROLLER_TYPE_PS3,
    CONTROLLER_TYPE_PS4,
    CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
    CONTROLLER_TYPE_VIRTUAL,
    CONTROLLER_TYPE_PS5

  GameControllerBindType* {.size: sizeof(cint).} = enum
    CONTROLLER_BINDTYPE_NONE = 0,
    CONTROLLER_BINDTYPE_BUTTON,
    CONTROLLER_BINDTYPE_AXIS,
    CONTROLLER_BINDTYPE_HAT

type
  GameControllerButtonBindValueHat* = object
    hat*: cint
    hat_mask*: cint

  GameControllerButtonBindValue* {.union.} = object
    button*: cint
    axis*: cint
    hat*: GameControllerButtonBindValueHat

  GameControllerButtonBind* = object ##  \
    ##  Get the SDL joystick layer binding
    ##  for this controller button/axis mapping
    bindType*: GameControllerBindType
    value*: GameControllerButtonBindValue

##  To count the number of game controllers in the system for the following:
##
##  .. code-block:: nim
##    var nJoysticks: int = numJoysticks()
##    var nGameControllers: int = 0
##    for i in 0..nJoysticks-1:
##      if isGameController(i):
##        inc(nGameControllers)
##
##  Using the `HINT_GAMECONTROLLERCONFIG` hint or the
##  ``sdl.gameControllerAddMapping()`` you can add support for controllers SDL
##  is unaware of or cause an existing controller to have a different binding.
##
##  The format is:
##
##  guid,name,mappings
##
##  Where GUID is the string value from ``joystickGetGUIDString()``, name is
##  the human readable string for the device and mappings are controller
##  mappings to joystick ones.
##
##  Under Windows there is a reserved GUID of "xinput" that covers
##  any XInput devices.
##
##  The mapping format for joystick is:
##  * `bX` - a joystick button, index X
##  * `hX.Y` - hat X with value Y
##  * `aX` - axis X of the joystick
##
##  Buttons can be used as a controller axis and vice versa.
##
##  This string shows an example of a valid mapping for a controller
##
##  "03000000341a00003608000000000000,PS3 Controller,a:b1,b:b2,y:b3,x:b0,
##  start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,
##  leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,
##  lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7"

proc gameControllerAddMappingsFromRW*(rw: ptr RWops; freerw: cint): cint {.
    cdecl, importc: "SDL_GameControllerAddMappingsFromRW", dynlib: SDL2_LIB.}
  ##  Load a set of mappings from a seekable SDL data stream (memory or file),
  ##  filtered by the current ``getPlatform()``.
  ##
  ##  A community sourced database of controllers is available at https://raw.github.com/gabomdq/SDL_GameControllerDB/master/gamecontrollerdb.txt
  ##
  ##  If ``freerw`` is non-zero, the stream will be closed after being read.
  ##
  ##  ``Return`` number of mappings added, `-1` on error

template gameControllerAddMappingsFromFile*(file: untyped): untyped = ##  \
  ##  Load a set of mappings from a file,
  ##  filtered by the current ``getPlatform()``.
  gameControllerAddMappingsFromRW(rwFromFile(file, "rb"), 1)

proc gameControllerAddMapping*(mappingString: cstring): cint {.
    cdecl, importc: "SDL_GameControllerAddMapping", dynlib: SDL2_LIB.}
  ##  Add or update an existing mapping configuration.
  ##
  ##  ``Return`` `1` if mapping is added, `0` if updated, `-1` on error.

proc gameControllerNumMappings*(): cint {.
    cdecl, importc: "SDL_GameControllerNumMappings", dynlib: SDL2_LIB.}
  ##  Get the number of mappings installed.
  ##
  ##  ``Return`` the number of mappings.

proc gameControllerMappingForIndex*(mapping_index: cint): cstring {.
    cdecl, importc: "SDL_GameControllerMappingForIndex", dynlib: SDL2_LIB.}
  ##  Get the mapping at a particular index.
  ##
  ##  ``Return`` the mapping string. Must be freed with ``free()``.
  ##  Returns `nil` if the index is out of range.

proc gameControllerMappingForGUID*(guid: JoystickGUID): cstring {.
    cdecl, importc: "SDL_GameControllerMappingForGUID", dynlib: SDL2_LIB.}
  ##  Get a mapping string for a GUID.
  ##
  ##  ``Return`` the mapping string.  Must be freed with ``sdl.free()``.
  ##  Returns `nil` if no mapping is available

proc gameControllerMapping*(gamecontroller: GameController): cstring {.
    cdecl, importc: "SDL_GameControllerMapping", dynlib: SDL2_LIB.}
  ##  Get a mapping string for an open GameController.
  ##
  ##  ``Return`` the mapping string.  Must be freed with ``sdl.free()``.
  ##  Returns `nil` if no mapping is available

proc isGameController*(joystick_index: cint): bool {.
    cdecl, importc: "SDL_IsGameController", dynlib: SDL2_LIB.}
  ##  Is the joystick on this index supported by the game controller interface?

proc gameControllerNameForIndex*(joystick_index: cint): cstring {.
    cdecl, importc: "SDL_GameControllerNameForIndex", dynlib: SDL2_LIB.}
  ##  Get the implementation dependent name of a game controller.
  ##
  ##  This can be called before any controllers are opened.
  ##  If no name can be found, this procedure returns `nil`.

proc gameControllerTypeForIndex*(joystick_index: cint): GameControllerType {.
    cdecl, importc: "SDL_GameControllerTypeForIndex", dynlib: SDL2_LIB.}
  ##  Get the type of a game controller.
  ##
  ##  This can be called before any controllers are opened.

proc gameControllerMappingForDeviceIndex*(joystick_index: cint): cstring {.
    cdecl, importc: "SDL_GameControllerMappingForDeviceIndex", dynlib: SDL2_LIB.}
  ##  Get the mapping of a game controller.
  ##
  ##  This can be called before any controllers are opened.
  ##
  ##  `Return` the mapping string.
  ##  Must be freed with ``sdl.free()``.
  ##  Returns `nil` if no mapping is available.

proc gameControllerOpen*(joystick_index: cint): GameController {.
    cdecl, importc: "SDL_GameControllerOpen", dynlib: SDL2_LIB.}
  ##  Open a game controller for use.
  ##
  ##  The index passed as an argument refers to the N'th game controller
  ##  on the system.
  ##
  ##  This index is not the value which will identify this controller in future
  ##  controller events. The joystick's instance id (``JoystickID``) will be
  ##  used there instead.
  ##
  ##  ``Return`` a controller identifier, or `nil` if an error occurred.

proc gameControllerFromInstanceID*(joyid: JoystickID): GameController {.
    cdecl, importc: "SDL_GameControllerFromInstanceID", dynlib: SDL2_LIB.}
  ##  ``Return`` the ``GameController`` associated with an instance id.

proc gameControllerFromPlayerIndex*(player_index: cint): GameController {.
    cdecl, importc: "SDL_GameControllerFromPlayerIndex", dynlib: SDL2_LIB.}
  ##  ``Return`` the ``GameController`` associated with a player index.

proc gameControllerName*(gamecontroller: GameController): cstring {.
    cdecl, importc: "SDL_GameControllerName", dynlib: SDL2_LIB.}
  ##  ``Return`` the name for this currently opened controller.

proc gameControllerGetType*(gamecontroller: GameController): GameControllerType {.
    cdecl, importc: "SDL_GameControllerGetType", dynlib: SDL2_LIB.}
  ##  ``Return`` the type of this currently opened controller.

proc gameControllerGetPlayerIndex*(gamecontroller: GameController): cint {.
    cdecl, importc: "SDL_GameControllerGetPlayerIndex", dynlib: SDL2_LIB.}
  ##  Get the player index of an opened game controller,
  ##  or `-1` if it's not available.
  ##
  ##  For XInput controllers this returns the XInput user index.

proc gameControllerSetPlayerIndex*(
  gamecontroller: GameController, player_index: cint) {.
    cdecl, importc: "SDL_GameControllerSetPlayerIndex", dynlib: SDL2_LIB.}
  ##  Set the player index of an opened game controller.

proc gameControllerGetVendor*(gamecontroller: GameController): uint16 {.
    cdecl, importc: "SDL_GameControllerGetVendor", dynlib: SDL2_LIB.}
  ##  ``Return`` the USB vendor ID of an opened controller, if available.
  ##  If the vendor ID isn't available this procedure returns `0`.

proc gameControllerGetProduct*(gamecontroller: GameController): uint16 {.
    cdecl, importc: "SDL_GameControllerGetProduct", dynlib: SDL2_LIB.}
  ##  ``Return`` the USB product ID of an opened controller, if available.
  ##  If the product ID isn't available this procedure returns `0`.

proc gameControllerGetProductVersion*(gamecontroller: GameController): uint16 {.
    cdecl, importc: "SDL_GameControllerGetProductVersion", dynlib: SDL2_LIB.}
  ##  ``Return`` the product version of an opened controller, if available.
  ##  If the product version isn't available this procedure returns `0`.

proc gameControllerGetSerial*(gamecontroller: GameController): cstring {.
    cdecl, importc: "SDL_GameControllerGetSerial", dynlib: SDL2_LIB.}
  ##  Get the serial number of an opened controller, if available.
  ##
  ##  ``Return`` the serial number of the controller,
  ##  or `nil` if it is not available.

proc gameControllerGetAttached*(gamecontroller: GameController): bool {.
    cdecl, importc: "SDL_GameControllerGetAttached", dynlib: SDL2_LIB.}
  ##  ``Returns`` `true` if the controller has been opened and currently
  ##  connected, or `false` if it has not.

proc gameControllerGetJoystick*(gamecontroller: GameController): ptr Joystick {.
    cdecl, importc: "SDL_GameControllerGetJoystick", dynlib: SDL2_LIB.}
  ##  Get the underlying joystick object used by a controller.

proc gameControllerEventState*(state: cint): cint {.
    cdecl, importc: "SDL_GameControllerEventState", dynlib: SDL2_LIB.}
  ##  Enable/disable controller event polling.
  ##
  ##  If controller events are disabled, you must call
  ##  ``gameControllerUpdate()`` yourself and check the state of the
  ##  controller when you want controller information.
  ##
  ##  The state can be one of `QUERY`, `ENABLE` or `IGNORE`.

proc gameControllerUpdate*() {.
    cdecl, importc: "SDL_GameControllerUpdate", dynlib: SDL2_LIB.}
  ##  Update the current state of the open game controllers.
  ##
  ##  This is called automatically by the event loop if any game controller
  ##  events are enabled.

type
  GameControllerAxis* {.size: sizeof(uint8).} = enum ##  \
    ##  The list of axes available from a controller.
    ##
    ##  Thumbstick axis values range
    ##  from `JOYSTICK_AXIS_MIN` to `JOYSTICK_AXIS_MAX`,
    ##  and are centered within ~8000 of zero,
    ##  though advanced UI will allow users to set
    ##  or autodetect the dead zone, which varies between controllers.
    ##
    ##  Trigger axis values range from `0` to `JOYSTICK_AXIS_MAX`.
    CONTROLLER_AXIS_LEFTX,  CONTROLLER_AXIS_LEFTY,
    CONTROLLER_AXIS_RIGHTX, CONTROLLER_AXIS_RIGHTY,
    CONTROLLER_AXIS_TRIGGERLEFT, CONTROLLER_AXIS_TRIGGERRIGHT,
    CONTROLLER_AXIS_MAX,
    CONTROLLER_AXIS_INVALID = uint8.high

proc gameControllerGetAxisFromString*(pchString: cstring): GameControllerAxis {.
    cdecl, importc: "SDL_GameControllerGetAxisFromString", dynlib: SDL2_LIB.}
  ##  Turn this string into a axis mapping.

proc gameControllerGetStringForAxis*(axis: GameControllerAxis): cstring {.
    cdecl, importc: "SDL_GameControllerGetStringForAxis", dynlib: SDL2_LIB.}
  ##  Turn this axis enum into a string mapping.

proc gameControllerGetBindForAxis*(
    gamecontroller: GameController;
    axis: GameControllerAxis): GameControllerButtonBind {.
      cdecl, importc: "SDL_GameControllerGetBindForAxis", dynlib: SDL2_LIB.}
  ##  Get the SDL joystick layer binding for this controller button mapping.

proc gameControllerHasAxis*(
    gamecontroller: GameController;
    axis: GameControllerAxis): bool {.
      cdecl, importc: "SDL_GameControllerHasAxis", dynlib: SDL2_LIB.}
  ##  ``Return`` whether a game controller has a given axis.

proc gameControllerGetAxis*(
    gamecontroller: GameController;
    axis: GameControllerAxis): int16 {.
      cdecl, importc: "SDL_GameControllerGetAxis", dynlib: SDL2_LIB.}
  ##  Get the current state of an axis control on a game controller.
  ##
  ##  The state is a value ranging from `-32768` to `32767`
  ##  (except for the triggers, which range from `0` to `32767`.
  ##
  ##  The axis indices start at index `0`.

type
  GameControllerButton* {.size: sizeof(uint8).} = enum ##  \
    ##  The list of buttons available from a controller
    CONTROLLER_BUTTON_A, CONTROLLER_BUTTON_B,
    CONTROLLER_BUTTON_X, CONTROLLER_BUTTON_Y,
    CONTROLLER_BUTTON_BACK,
    CONTROLLER_BUTTON_GUIDE,
    CONTROLLER_BUTTON_START, 
    CONTROLLER_BUTTON_LEFTSTICK,    CONTROLLER_BUTTON_RIGHTSTICK,
    CONTROLLER_BUTTON_LEFTSHOULDER, CONTROLLER_BUTTON_RIGHTSHOULDER,
    CONTROLLER_BUTTON_DPAD_UP,      CONTROLLER_BUTTON_DPAD_DOWN,
    CONTROLLER_BUTTON_DPAD_LEFT,    CONTROLLER_BUTTON_DPAD_RIGHT,
    CONTROLLER_BUTTON_MISC1,
      ##  Xbox Series X share button,
      ##  PS5 microphone button,
      ##  Nintendo Switch Pro capture button
    SDL_CONTROLLER_BUTTON_PADDLE1,  ##  Xbox Elite paddle P1
    SDL_CONTROLLER_BUTTON_PADDLE2,  ##  Xbox Elite paddle P3
    SDL_CONTROLLER_BUTTON_PADDLE3,  ##  Xbox Elite paddle P2
    SDL_CONTROLLER_BUTTON_PADDLE4,  ##  Xbox Elite paddle P4
    SDL_CONTROLLER_BUTTON_TOUCHPAD, ##  PS4/PS5 touchpad button
    CONTROLLER_BUTTON_MAX,
    CONTROLLER_BUTTON_INVALID = uint8.high

proc gameControllerGetButtonFromString*(
    pchString: cstring): GameControllerButton {.
    cdecl, importc: "SDL_GameControllerGetButtonFromString", dynlib: SDL2_LIB.}
  ##  Turn this string into a button mapping.

proc gameControllerGetStringForButton*(button: GameControllerButton): cstring {.
    cdecl, importc: "SDL_GameControllerGetStringForButton", dynlib: SDL2_LIB.}
  ##  Turn this button enum into a string mapping.

proc gameControllerGetBindForButton*(
    gamecontroller: GameController;
    button: GameControllerButton): GameControllerButtonBind {.
      cdecl, importc: "SDL_GameControllerGetBindForButton", dynlib: SDL2_LIB.}
  ##  Get the SDL joystick layer binding for this controller button mapping.

proc gameControllerHasButton*(
    gamecontroller: GameController; button: GameControllerButton): bool {.
      cdecl, importc: "SDL_GameControllerHasButton", dynlib: SDL2_LIB.}
  ##  ``Return`` whether a game controller has a given button.

proc gameControllerGetButton*(
    gamecontroller: GameController; button: GameControllerButton): uint8 {.
      cdecl, importc: "SDL_GameControllerGetButton", dynlib: SDL2_LIB.}
  ##  Get the current state of a button on a game controller.
  ##
  ##  The button indices start at index `0`.

proc gameControllerGetNumTouchpads*(gamecontroller: GameController): cint {.
    cdecl, importc: "SDL_GameControllerGetNumTouchpads", dynlib: SDL2_LIB.}
  ##  Get the number of touchpads on a game controller.

proc gameControllerGetNumTouchpadFingers*(
    gamecontroller: GameController; touchpad: cint): cint {.
      cdecl, importc: "SDL_GameControllerGetNumTouchpadFingers", dynlib: SDL2_LIB.}
  ##  Get the number of supported simultaneous fingers
  ##  on a touchpad on a game controller.

proc gameControllerGetTouchpadFinger*(
    gamecontroller: GameController;
    touchpad, finger: cint;
    state: ptr uint8; x, y, pressure: ptr cfloat): cint {.
      cdecl, importc: "SDL_GameControllerGetTouchpadFinger", dynlib: SDL2_LIB.}
  ##  Get the current state of a finger on a touchpad on a game controller.


proc gameControllerHasSensor*(
    gamecontroller: GameController; sensorType: SensorType): bool {.
      cdecl, importc: "SDL_GameControllerHasSensor", dynlib: SDL2_LIB.}
  ##  Return whether a game controller has a particular sensor.
  ##
  ##  ``gamecontroller`` The controller to query
  ##
  ##  ``sensorType`` The type of sensor to query
  ##
  ##  ``Return`` `true` if the sensor exists, `false` otherwise.

proc gameControllerSetSensorEnabled*(
    gamecontroller: GameController;
    sensorType: SensorType; enabled: bool): cint {.
      cdecl, importc: "SDL_GameControllerSetSensorEnabled", dynlib: SDL2_LIB.}
  ##  Set whether data reporting for a game controller sensor is enabled.
  ##
  ##  ``gamecontroller`` The controller to update
  ##
  ##  ``sensorType`` The type of sensor to enable/disable
  ##
  ##  ``enabled`` Whether data reporting should be enabled
  ##
  ##  ``Return`` `0` or `-1` if an error occurred.


proc gameControllerIsSensorEnabled*(
    gamecontroller: GameController; sensorType: SensorType): bool {.
      cdecl, importc: "SDL_GameControllerIsSensorEnabled", dynlib: SDL2_LIB.}
  ##  Query whether sensor data reporting is enabled for a game controller.
  ##
  ##  ``gamecontroller`` The controller to query
  ##
  ##  ``sensorType`` The type of sensor to query
  ##
  ##  ``Return`` `true` if the sensor is enabled, `false` otherwise.

proc gameControllerGetSensorData*(
    gamecontroller: GameController; sensorType: SensorType,
    data: ptr cfloat, num_values: cint): cint {.
      cdecl, importc: "SDL_GameControllerGetSensorData", dynlib: SDL2_LIB.}
  ##  Get the current state of a game controller sensor.
  ##
  ##  The number of values and interpretation of the data is sensor dependent.
  ##  See ``sensor.nim`` for the details for each type of sensor.
  ##
  ##  ``gamecontroller`` The controller to query
  ##
  ##  ``SensorType`` The type of sensor to query
  ##
  ##  ``data`` A pointer filled with the current sensor state
  ##
  ##  ``num_values`` The number of values to write to data
  ##
  ##  ``Return`` `0` or `-1` if an error occurred.

proc gameControllerRumble*(
  gamecontroller: GameController; low_frequency_rumble: uint16;
  high_frequency_rumble: uint16; duration_ms: uint32): cint {.
    cdecl, importc: "SDL_GameControllerRumble", dynlib: SDL2_LIB.}
  ##  Start a rumble effect.
  ##
  ##  Each call to this procedure cancels any previous rumble effect,
  ##  and calling it with `0` intensity stops any rumbling.
  ##
  ##  ``gamecontroller``  The controller to vibrate
  ##
  ##  ``low_frequency_rumble``  The intensity of the low frequency (left)
  ##  rumble motor, from 0 to 0xFFFF
  ##
  ##  ``high_frequency_rumble`` The intensity of the high frequency (right)
  ##  rumble motor, from `0` to `0xFFFF`
  ##
  ##  ``duration_ms`` The duration of the rumble effect, in milliseconds
  ##
  ##  ``Return`` `0`, or `-1` if rumble isn't supported on this controller.

proc gameControllerRumbleTriggers*(
    gamecontroller: GameController;
    left_rumble, right_rumble: uint16; duration_ms: uint32): cint {.
      cdecl, importc: "SDL_GameControllerRumbleTriggers", dynlib: SDL2_LIB.}
  ##  Start a rumble effect in the game controller's triggers.
  ##  Each call to this procedure cancels any previous trigger rumble effect,
  ##  and calling it with `0` intensity stops any rumbling.
  ##
  ##  ``gamecontroller`` The controller to vibrate
  ##
  ##  ``left_rumble`` The intensity of the left trigger rumble motor,
  ##  from `0` to `0xFFFF`
  ##
  ##  ``right_rumble`` The intensity of the right trigger rumble motor,
  ##  from `0` to `0xFFFF`
  ##
  ##  ``duration_ms`` The duration of the rumble effect, in milliseconds
  ##
  ##  ``Return`` `0`, or `-1` if rumble isn't supported on this controller.

proc gameControllerHasLED*(gamecontroller: GameController): bool {.
    cdecl, importc: "SDL_GameControllerHasLED", dynlib: SDL2_LIB.}
  ##  Return whether a controller has an LED.
  ##
  ##  ``gamecontroller`` The controller to query
  ##
  ##  ``Return`` `true`,
  ##  or `false` if this controller does not have a modifiable LED.

proc gameControllerSetLED*(
    gamecontroller: GameController; red, green, blue: uint8): cint {.
      cdecl, importc: "SDL_GameControllerSetLED", dynlib: SDL2_LIB.}
  ##  Update a controller's LED color.
  ##
  ##  ``gamecontroller`` The controller to update
  ##
  ##  ``red`` The intensity of the red LED
  ##
  ##  ``green`` The intensity of the green LED
  ##
  ##  ``blue`` The intensity of the blue LED
  ##
  ##  ``Return`` `0`, or `-1` if this controller does not have a modifiable LED.

proc gameControllerClose*(gamecontroller: GameController) {.
    cdecl, importc: "SDL_GameControllerClose", dynlib: SDL2_LIB.}
  ##  Close a controller previously opened with ``gameControllerOpen()``.
