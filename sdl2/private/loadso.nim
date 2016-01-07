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

##  loadso.nim
##  ==========
##
##  System dependent library loading routines.
##
##  Some things to keep in mind:
##
##  * These procedures only work on C function names. Other languages may
##  have name mangling and intrinsic language support that varies from
##  compiler to compiler.
##
##  * Make sure you declare your function pointers with the same calling
##  convention as the actual library function. Your code will crash
##  mysteriously if you do not do this.
##
##  * Avoid namespace collisions. If you load a symbol from the library,
##  it is not defined whether or not it goes into the global symbol
##  namespace for the application. If it does and it conflicts with
##  symbols in your code or other shared libraries, you will not get
##  the results you expect. :)

proc loadObject*(sofile: cstring): pointer {.
    cdecl, importc: "SDL_LoadObject", dynlib: SDL2_LIB.}
  ##  This procedure dynamically loads a shared object and returns a pointer
  ##  to the object handle (or `nil` if there was an error).
  ##  The ``sofile`` parameter is a system dependent name of the object file.

proc loadFunction*(handle: pointer; name: cstring): pointer {.
    cdecl, importc: "SDL_LoadFunction", dynlib: SDL2_LIB.}
  ##  Given an object ``handle``, this procedure looks up the address of the
  ##  named function in the shared object and returns it.  This address
  ##  is no longer valid after calling ``unloadObject()``.

proc unloadObject*(handle: pointer) {.
    cdecl, importc: "SDL_UnloadObject", dynlib: SDL2_LIB.}
  ##  Unload a shared object from memory.
