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
# Include file for SDL gesture event handling.
#


type
  TGestureID* = int64


# Function prototypes


proc recordGesture*(touchID: TTouchID): int {.cdecl, importc: "SDL_RecordGesture", dynlib: LibName.}
  ## Begin Recording a gesture on the specified touch, or all touches (-1)


proc saveAllDollarTemplates*(src: PRWops): int {.cdecl, importc: "SDL_SaveAllDollarTemplates", dynlib: LibName.}
  ## Save all currently loaded Dollar Gesture templates


proc saveDollarTemplate*(gestureId: TGestureID, src: PRWops): int {.cdecl, importc: "SLD_SaveDollarTemplate", dynlib: LibName.}
  ## Save a currently loaded Dollar Gesture template


proc loadDollarTemplates*(touchId: TTouchID, src: PRWops): int {.cdecl, importc: "SDL_LoadDollarTemplates", dynlib: LibName.}
  ## Load Dollar Gesture templates from a file

