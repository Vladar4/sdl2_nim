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
# Include file for SDL touch event handling.
#


type
  TTouchID* = int64
  TFingerID* = int64

  PFinger* = ptr TFinger
  TFinger* = object
    id: TFingerID
    x, y, pressure: cfloat


const
  TOUCH_MOUSEID* = high(Uint32) ## Used as the device ID for mouse events simulated with touch input


# Function prototypes


proc getNumTouchDevices*(): int {.cdecl, importc: "SDL_GetNumTouchDevices", dynlib: LibName.}
  ## Get the number of registered touch devices.


proc getTouchDevice*(index: int): TTouchID {.cdecl, importc: "SDL_GetTouchDevice", dynlib: LibName.}
  ## Get the touch ID with the given index, or 0 if the index is invalid.


proc getNumTouchFingers*(touchID: TTouchID): int {.cdecl, importc: "SDL_GetNumTouchFingers", dynlib: LibName.}
  ## Get the number of active fingers for a given touch device.


proc getTouchFinger*(touchID: TTouchID, index: int): PFinger {.cdecl, importc: "SDL_GetTouchFinger", dynlib: LibName.}
  ## Get the finger object of the given touch, with the given index.

