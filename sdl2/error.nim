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
# Simple error message routines for SDL.
#


# Public functions


proc setError*(fmt: cstring): int {.cdecl, importc: "SDL_SetError", varargs, dynlib: LibName.}
  ## setError() unconditionally returns -1.


proc getError*(): cstring {.cdecl, importc: "SDL_GetError", dynlib: LibName.}


proc clearError*() {.cdecl, importc: "SDL_ClearError", dynlib: LibName.}


# Internal error functions
#
# Private error reporting function - used internally.

type
  TErrorCode* = enum
    ENOMEM,
    EFREAD,
    EFWRITE,
    EFSEEK,
    UNSUPPORTED,
    LASTERROR


proc error*(code: TErrorCode): int {.cdecl, importc: "SDL_Error", dynlib: LibName.}
  ## error() unconditionally returns -1.


template outOfMemory*() =
  error(ENOMEM)


template unsupported*() =
  error(UNSUPPORTED)


template invalidParamError*(param: expr) =
  setError("Parameter '%s' is invalid", (param))

