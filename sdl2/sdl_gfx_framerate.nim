#
#
# SDL2_framerate.h: framerate manager
#
# Copyright (C) 2012  Andreas Schiffler
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
# claim that you wrote the original software. If you use this software
# in a product, an acknowledgment in the product documentation would be
# appreciated but is not required.
#
# 2. Altered source versions must be plainly marked as such, and must not be
# misrepresented as being the original software.
#
# 3. This notice may not be removed or altered from any source
# distribution.
#
# Andreas Schiffler -- aschiffler at ferzkopp dot net
#
#

# Definitions

const
  FPS_UPPER_LIMIT* = 200  ##  \
    ##  Highest possible rate supported by framerate controller in Hz (1/s).

const
  FPS_LOWER_LIMIT* = 1  ##  \
    ##  Lowest possible rate supported by framerate controller in Hz (1/s).

const
  FPS_DEFAULT* = 30 ##  \
    ##  Default rate of framerate controller in Hz (1/s).

type
  FPSmanager* = object  ##  \
    ##  Object holding the state and timing information
    ##  of the framerate controller.
    framecount*: uint32
    rateticks*: cfloat
    baseticks*: uint32
    lastticks*: uint32
    rate*: uint32

# Function Prototypes

proc initFramerate*(manager: ptr FPSmanager) {.
    cdecl, importc: "SDL_initFramerate", dynlib: SDL2_GFX_LIB.}

proc setFramerate*(manager: ptr FPSmanager; rate: uint32): cint {.
    cdecl, importc: "SDL_setFramerate", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` `0` or value for sucess and `-1` for error.

proc getFramerate*(manager: ptr FPSmanager): cint {.
    cdecl, importc: "SDL_getFramerate", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` `0` or value for sucess and `-1` for error.

proc getFramecount*(manager: ptr FPSmanager): cint {.
    cdecl, importc: "SDL_getFramecount", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` `0` or value for sucess and `-1` for error.

proc framerateDelay*(manager: ptr FPSmanager): uint32 {.
    cdecl, importc: "SDL_framerateDelay", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` `0` or value for sucess and `-1` for error.
