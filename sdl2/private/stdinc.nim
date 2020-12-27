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

##  stdinc.nim
##  ==========
##

proc malloc*(size: csize_t): pointer {.
    cdecl, importc: "SDL_malloc", dynlib: SDL2_LIB.}
  ##  Allocate memory with the same memory allocater that SDL uses.

proc calloc*(nmemb: csize_t; size: csize_t): pointer {.
    cdecl, importc: "SDL_calloc", dynlib: SDL2_LIB.}

proc realloc*(mem: pointer; size: csize_t): pointer {.
    cdecl, importc: "SDL_realloc", dynlib: SDL2_LIB.}

proc free*(mem: pointer) {.cdecl, importc: "SDL_free", dynlib: SDL2_LIB.}
  ##  When SDL allocates memory that you have to free,
  ##  free it with this procedure.

template ptrMath*(body: untyped) =  ##  \
  ##  Pointer arithmetic. Could be used for pixels manipulation.
  ##
  ##  Example:
  ##
  ##  .. code-block:: nim
  ##    var surface = sdl.convertSurfaceFormat(
  ##      sourceSurface, sdl.PixelFormat_RGBA8888, 0)
  ##    discard sdl.lockSurface(surface)
  ##    var pixels = cast[ptr uint32](surface.pixels)
  ##    let pitch = surface.pitch div 4
  ##    for y in 0..surface.h-1:
  ##      for x in 0..pitch-1:
  ##        ptrMath:                                #################
  ##          pixels[x + y * pitch] = uint32(x * y) # Using ptrMath #
  ##                                                #################
  ##    sdl.unlockSurface(surface)
  ##
  template `+`[T](p: ptr T, off: int): ptr T {.used.} =
    cast[ptr type(p[])](cast[ByteAddress](p) +% off * sizeof(p[]))

  template `+=`[T](p: ptr T, off: int) {.used.} =
    p = p + off

  template `-`[T](p: ptr T, off: int): ptr T {.used.} =
    cast[ptr type(p[])](cast[ByteAddress](p) -% off * sizeof(p[]))

  template `-=`[T](p: ptr T, off: int) {.used.} =
    p = p - off

  template `[]`[T](p: ptr T, off: int): T {.used.} =
    (p + off)[]

  template `[]=`[T](p: ptr T, off: int, val: T) {.used.} =
    (p + off)[] = val

  body

template fourCC*(a, b, c, d: untyped): uint32 = ##  \
  ##  Define a four character code as a uint32.
  ((uint32(uint8(a)) shl 0) or
   (uint32(uint8(b)) shl 8) or
   (uint32(uint8(c)) shl 16) or
   (uint32(uint8(d)) shl 24))

converter toCint*(x: int): cint = cint(x)

converter toInt*(x: uint8): int = int(x)

