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
# Include file for SDL game controller event handling
#


#
# In order to use these functions, init() must have been called
# with the INIT_JOYSTICK flag.  This causes SDL to scan the system
# for game controllers, and load appropriate drivers.
#


type
  PGameController* = pointer ## The gamecontroller structure used to identify an SDL game controller


  TGameControllerBindType* = enum
    CONTROLLER_BINDTYPE_NONE = 0,
    CONTROLLER_BINDTYPE_BUTTON,
    CONTROLLER_BINDTYPE_AXIS,
    CONTROLLER_BINDTYPE_HAT


  TGameControllerButtonBind*{.bycopy.} = object
    ## Get the SDL joystick layer binding for this controller button/axis mapping
    bindType*: TGameControllerBindType
    value*: array[0..1, int]

#  union
#  {
#    int button;
#    int axis;
#    struct {
#        int hat;
#        int hat_mask;
#    } hat;
#} value;


#
# To count the number of game controllers in the system for the following:
#
# var nJoysticks: int = numJoysticks()
# var nGameControllers: int = 0
# for i in 0..nJoysticks-1:
#   if isGameController(i):
#     inc(nGameControllers)
#
# Using the HINT_GAMECONTROLLERCONFIG hint or the gameControllerAddMapping
# you can add support for controllers SDL is unaware of or cause an existing
# controller to have a different binding. The format is:
#
# guid,name,mappings
#
# Where GUID is the string value from joystickGetGUIDString(), name is the
# human readable string for the device and mappings are controller mappings
# to joystick ones.
#
# Under Windows there is a reserved GUID of "xinput" that covers any
# XInput devices.
#
# The mapping format for joystick is:
#   bX - a joystick button, index X
#   hX.Y - hat X with value Y
#   aX - axis X of the joystick
#
# Buttons can be used as a controller axis and vice versa.
#
# This string shows an example of a valid mapping for a controller
#
# "341a3608000000000000504944564944,Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7",
#


proc gameControllerAddMapping*(mappingString: cstring): int {.cdecl, importc: "SDL_GameControllerAddMapping", dynlib: LibName.}
  ## Add or update an existing mapping configuration
  ##
  ## Return 1 if mapping is added, 0 if updated, -1 on error


proc gameControllerMappingForGUID*(guid: TJoystickGUID): cstring {.cdecl, importc: "SDL_GameControllerMappingForGUID", dynlib: LibName.}
  ## Get a mapping string for a GUID
  ##
  ## Return the mapping string. Must be freed with free.
  ## Returns nil if no mapping is available
 

proc gameControllerMapping*(gamecontroller: PGameController): cstring {.cdecl, importc: "SDL_GameControllerMapping", dynlib: LibName.}
  ## Get a mapping string for an open GameController
  ##
  ## Return the mapping string. Must be freed with free.
  ## Returns nil if no mapping is available


proc isGameController*(joystick_index: int): bool {.cdecl, importc: "SDL_IsGameController", dynlib: LibName.}
  ## Is the joystick on this index supported by the game controller interface?


proc gameControllerNameForIndex*(joystick_index: int): cstring {.cdecl, importc: "SDL_GameControllerNameForIndex", dynlib: LibName.}
  ## Get the implementation dependent name of a game controller.
  ## This can be called before any controllers are opened.
  ## If no name can be found, this function returns nil.


proc gameControllerOpen*(joystick_index: int): PGameController {.cdecl, importc: "SDL_GameControllerOpen", dynlib: LibName.}
  ## Open a game controller for use.
  ## The index passed as an argument refers to the N'th game controller
  ## on the system.
  ## This index is the value which will identify this controller
  ## in future controller events.
  ##
  ## Return A controller identifier, or nil if an error occurred.


proc gameControllerName*(gamecontroller: PGameController): cstring {.cdecl, importc: "SDL_GameControllerName", dynlib: LibName.}
  ## Return the name for this currently opened controller


proc gameControllerGetAttached*(gamecontroller: PGameController): bool {.cdecl, importc: "SDL_GameControllerGetAttached", dynlib: LibName.}
  ## Returns TRUE if the controller has been opened and currently connected,
  ## or FALSE if it has not.

proc gameControllerGetJoystick*(gamecontroller: PGameController): PJoystick {.cdecl, importc: "SDL_GameControllerGetJoystick", dynlib: LibName.}
  ## Get the underlying joystick object used by a controller


proc gameControllerEventState*(state: int): int {.cdecl, importc: "SDL_GameControllerEventState", dynlib: LibName.}
  ## Enable/disable controller event polling.
  ##
  ## If controller events are disabled, you must call gameControllerUpdate()
  ## yourself and check the state of the controller when you want controller
  ## information.
  ##
  ## The state can be one of QUERY, ENABLE or IGNORE.


proc gameControllerUpdate*() {.cdecl, importc: "SDL_GameControllerUpdate", dynlib: LibName.}
  ## Update the current state of the open game controllers.
  ##
  ## This is called automatically by the event loop if any game controller
  ## events are enabled.


type
  TGameControllerAxis* = enum ## The list of axes available from a controller
    CONTROLLER_AXIS_INVALID = -1,
    CONTROLLER_AXIS_LEFTX,
    CONTROLLER_AXIS_LEFTY,
    CONTROLLER_AXIS_RIGHTX,
    CONTROLLER_AXIS_RIGHTY,
    CONTROLLER_AXIS_TRIGGERLEFT,
    CONTROLLER_AXIS_TRIGGERRIGHT,
    CONTROLLER_AXIS_MAX


proc gameControllerGetAxisFromString*(pchString: cstring): TGameControllerAxis {.cdecl, importc: "SDL_GameControllerGetAxisFromString", dynlib: LibName.}
  ## Turn this string into a axis mapping.


proc gameControllerGetStringForAxis*(axis: TGameControllerAxis): cstring {.cdecl, importc: "SDL_GameControllerGetStringForAxis", dynlib: LibName.}
  ## Turn this axis enum into a string mapping.

proc gameControllerGetBindForAxis*(gamecontroller: PGameController,
 axis: TGameControllerAxis): TGameControllerButtonBind {.cdecl, importc: "SDL_GameControllerGetBindForAxis", dynlib: LibName.}
  ## Get the SDL joystick layer binding for this controller button mapping


proc gameControllerGetAxis*(gamecontroller: PGameController,
  axis: TGameControllerAxis): int16 {.cdecl, importc: "SDL_GameControllerGetAxis", dynlib: LibName.}
  ## Get the current state of an axis control on a game controller.
  ##
  ## The state is a value ranging from -32768 to 32767.
  ##
  ##  The axis indices start at index 0.


type
  TGameControllerButton* = enum # The list of buttons available from a controller
    CONTROLLER_BUTTON_INVALID = -1,
    CONTROLLER_BUTTON_A,
    CONTROLLER_BUTTON_B,
    CONTROLLER_BUTTON_X,
    CONTROLLER_BUTTON_Y,
    CONTROLLER_BUTTON_BACK,
    CONTROLLER_BUTTON_GUIDE,
    CONTROLLER_BUTTON_START,
    CONTROLLER_BUTTON_LEFTSTICK,
    CONTROLLER_BUTTON_RIGHTSTICK,
    CONTROLLER_BUTTON_LEFTSHOULDER,
    CONTROLLER_BUTTON_RIGHTSHOULDER,
    CONTROLLER_BUTTON_DPAD_UP,
    CONTROLLER_BUTTON_DPAD_DOWN,
    CONTROLLER_BUTTON_DPAD_LEFT,
    CONTROLLER_BUTTON_DPAD_RIGHT,
    CONTROLLER_BUTTON_MAX


proc gameControllerGetButtonFromString*(pchString: cstring): TGameControllerButton {.cdecl, importc: "SDL_GameControllerGetButtonFromString", dynlib: LibName.}
  ## Turn this string into a button mapping.


proc gameControllerGetStringForButton*(button : TGameControllerButton): cstring {.cdecl, importc: "SDL_GameControllerGetStringForButton", dynlib: LibName.}
  ## Turn this button enum into a string mapping.


proc gameControllerGetBindForButton*(gamecontroller: PGameController,
    button: TGameControllerButton): TGameControllerButtonBind {.cdecl, importc: "SDL_GameControllerGetBindForButton", dynlib: LibName.}
  ## Get the SDL joystick layer binding for this controller button mapping


proc gameControllerGetButton*(gamecontroller: PGameController,
    button: TGameControllerButton): Uint8 {.cdecl, importc: "SDL_GameControllerGetButton", dynlib: LibName.}
  ## Get the current state of a button on a game controller.
  ##
  ## The button indices start at index 0.


proc gameControllerClose*(gamecontroller: PGameController) {.cdecl, importc: "SDL_GameControllerClose", dynlib: LibName.}
  ## Close a controller previously opened with gameControllerOpen().

