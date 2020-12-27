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

##  touch.nim
##  =========
##
##  Include file for SDL touch event handling.

type
  TouchID* = int64

  FingerID* = int64

  TouchDeviceType* {.size: sizeof(cint).} = enum
    TOUCH_DEVICE_INVALID = -1,
    TOUCH_DEVICE_DIRECT,
      ##  touch screen with window-relative coordinates
    TOUCH_DEVICE_INDIRECT_ABSOLUTE,
      ##  trackpad with absolute device coordinates
    TOUCH_DEVICE_INDIRECT_RELATIVE
      ##  trackpad with screen cursor-relative coordinates

  Finger* = object
    id*: FingerID
    x*: cfloat
    y*: cfloat
    pressure*: cfloat

const
  TOUCH_MOUSEID* = cast[uint32](-1'i32) ##  \
    ##  Used as the device ID for mouse events simulated with touch input

const
  MOUSE_TOUCHID*: int64 = -1  ##  \
    ##  Used as the ``sdl.TouchID`` for touch events simulated with mouse input

# Procedures

proc getNumTouchDevices*(): cint {.
    cdecl, importc: "SDL_GetNumTouchDevices", dynlib: SDL2_LIB.}
  ##  Get the number of registered touch devices.

proc getTouchDevice*(index: cint): TouchID {.
    cdecl, importc: "SDL_GetTouchDevice", dynlib: SDL2_LIB.}
  ##  Get the touch ID with the given index, or `0` if the index is invalid.

proc getTouchDeviceType*(touchID: TouchID): TouchDeviceType {.
    cdecl, importc: "SDL_GetTouchDeviceType", dynlib: SDL2_LIB.}
  ##  Get the type of the given touch device.

proc getNumTouchFingers*(touchID: TouchID): cint {.
    cdecl, importc: "SDL_GetNumTouchFingers", dynlib: SDL2_LIB.}
  ##  Get the number of active fingers for a given touch device.

proc getTouchFinger*(touchID: TouchID; index: cint): ptr Finger {.
    cdecl, importc: "SDL_GetTouchFinger", dynlib: SDL2_LIB.}
  ##  Get the finger object of the given touch, with the given index.
