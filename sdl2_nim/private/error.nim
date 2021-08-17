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

##  error.nim
##  =========
##
##  Simple error message routines for SDL.

proc setError*(fmt: cstring): cint {.
    varargs, cdecl, importc: "SDL_SetError", dynlib: SDL2_LIB.}
  ##  Set the error message for the current thread.
  ##
  ##  ``Return`` `-1`, there is no error handling for this procedure.

proc getError*(): cstring {.
    cdecl, importc: "SDL_GetError", dynlib: SDL2_LIB.}
  ##  Get the last error message that was set.
  ##
  ##  SDL API procedures may set error messages and then succeed, so you should
  ##  only use the error value if a procedure fails.
  ##
  ##  This returns a pointer to a static buffer for convenience and should not
  ##  be called by multiple threads simultaneously.
  ##
  ##  ``Return`` a ``cstring`` of the last error message that was set.

proc getErrorMsg*(errstr: cstring; maxlen: cint): cstring {.
    cdecl, importc: "SDL_GetErrorMsg", dynlib: SDL2_LIB.}
  ##  Get the last error message that was set for the current thread.
  ##
  ##  SDL API procedures may set error messages and then succeed, so you should
  ##  only use the error value if a procedure fails.
  ##
  ##  ``errstr`` A buffer to fill with the last error message that was set
  ##  for the current thread
  ##
  ##  ``maxlen`` The size of the buffer pointed to by the errstr parameter
  ##
  ##  ``Return`` errstr.

proc clearError*() {.
    cdecl, importc: "SDL_ClearError", dynlib: SDL2_LIB.}
  ##  Clear the error message for the current thread.

