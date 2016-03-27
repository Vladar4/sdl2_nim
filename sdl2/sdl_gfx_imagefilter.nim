#
#
# SDL2_imageFilter.h: byte-image "filter" routines 
#
# Copyright (C) 2001-2012  Andreas Schiffler
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

##  sdl_gfx_imagefilter.nim
##  =======================
##

import
  sdl

# Procedure prototypes

##  1. MMX procedures work best if all data blocks are aligned
##  on a 32 bytes boundary.
##
##  2. Data that is not within an 8 byte boundary is processed
##  using the C routine.
##
##  3. Convolution routines do not have C routines at this time.

proc imageFilterMMXdetect*(): cint {.
    cdecl, importc: "SDL_imageFilterMMXdetect", dynlib: SDL2_GFX_LIB.}
  ##  Detect MMX capability in CPU.

proc imageFilterMMXoff*() {.
    cdecl, importc: "SDL_imageFilterMMXoff", dynlib: SDL2_GFX_LIB.}
  ##  Force use of MMX off.

proc imageFilterMMXon*() {.
    cdecl, importc: "SDL_imageFilterMMXon", dynlib: SDL2_GFX_LIB.}
  ##  Turn possible use of MMX back on.

##  All routines return:
##
##  `0`   OK
##
##  `-1`  Error (internal error, parameter error)

proc imageFilterAdd*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterAdd", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterAdd: D = saturation255(S1 + S2)

proc imageFilterMean*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterMean", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterMean: D = S1/2 + S2/2

proc imageFilterSub*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterSub", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterSub: D = saturation0(S1 - S2)

proc imageFilterAbsDiff*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterAbsDiff", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterAbsDiff: D = | S1 - S2 |

proc imageFilterMult*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterMult", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterMult: D = saturation(S1 * S2)

proc imageFilterMultNor*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterMultNor", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterMultNor: D = S1 * S2   (non-MMX)

proc imageFilterMultDivby2*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterMultDivby2", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterMultDivby2: D = saturation255(S1/2 * S2)

proc imageFilterMultDivby4*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterMultDivby4", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterMultDivby4: D = saturation255(S1/2 * S2/2)

proc imageFilterBitAnd*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterBitAnd", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterBitAnd: D = S1 & S2

proc imageFilterBitOr*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterBitOr", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterBitOr: D = S1 | S2

proc imageFilterDiv*(
    src1: ptr cuchar; src2: ptr cuchar;
    dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterDiv", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterDiv: D = S1 / S2   (non-MMX)

proc imageFilterBitNegation*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint): cint {.
      cdecl, importc: "SDL_imageFilterBitNegation", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterBitNegation: D = !S

proc imageFilterAddByte*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; c: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterAddByte", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterAddByte: D = saturation255(S + C)

proc imageFilterAdduint*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; c: cuint): cint {.
      cdecl, importc: "SDL_imageFilterAdduint", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterAdduint: D = saturation255(S + (uint)C)

proc imageFilterAddByteToHalf*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; c: cuchar): cint {.
    cdecl, importc: "SDL_imageFilterAddByteToHalf", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterAddByteToHalf: D = saturation255(S/2 + C)

proc imageFilterSubByte*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; c: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterSubByte", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterSubByte: D = saturation0(S - C)

proc imageFilterSubuint*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; c: cuint): cint {.
      cdecl, importc: "SDL_imageFilterSubuint", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterSubuint: D = saturation0(S - (uint)C)

proc imageFilterShiftRight*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; n: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterShiftRight", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterShiftRight: D = saturation0(S >> N)

proc imageFilterShiftRightuint*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; n: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterShiftRightuint", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterShiftRightuint: D = saturation0((uint)S >> N)

proc imageFilterMultByByte*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; c: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterMultByByte", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterMultByByte: D = saturation255(S * C)

proc imageFilterShiftRightAndMultByByte*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint;
    n: cuchar; c: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterShiftRightAndMultByByte",
      dynlib: SDL2_GFX_LIB.}
  ##  imageFilterShiftRightAndMultByByte: D = saturation255((S >> N) * C)

proc imageFilterShiftLeftByte*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; n: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterShiftLeftByte", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterShiftLeftByte: D = (S << N)

proc imageFilterShiftLeftuint*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; n: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterShiftLeftuint", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterShiftLeftuint: D = ((uint)S << N)

proc imageFilterShiftLeft*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; n: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterShiftLeft", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterShiftLeft: D = saturation255(S << N)

proc imageFilterBinarizeUsingThreshold*(
    src1: ptr cuchar; dest: ptr cuchar; length: cuint; T: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterBinarizeUsingThreshold",
      dynlib: SDL2_GFX_LIB.}
  ##  imageFilterBinarizeUsingThreshold: D = S >= T ? 255:0

proc imageFilterClipToRange*(
    src1: ptr cuchar; dest: ptr cuchar;
    length: cuint; Tmin: cuchar; Tmax: cuchar): cint {.
      cdecl, importc: "SDL_imageFilterClipToRange", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterClipToRange: D = (S >= Tmin) & (S <= Tmax) 255:0

proc imageFilterNormalizeLinear*(
    src: ptr cuchar; dest: ptr cuchar; length: cuint;
    cmin: cint; cmax: cint; nmin: cint; nmax: cint): cint {.
      cdecl, importc: "SDL_imageFilterNormalizeLinear", dynlib: SDL2_GFX_LIB.}
  ##  imageFilterNormalizeLinear:
  ##  D = saturation255((Nmax - Nmin)/(Cmax - Cmin)*(S - Cmin) + Nmin)
