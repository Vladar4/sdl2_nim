#
#
# SDL2_rotozoom.c: rotozoomer, zoomer and shrinker for 32bit or 8bit surfaces
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

##  sdl_gfx_rotozoom.nim
##  ====================
##

import
  sdl

# Defines

const
  SMOOTHING_OFF* = 0  ##  Disable anti-aliasing (no smoothing).

const
  SMOOTHING_ON* = 1   ##  Enable anti-aliasing (smoothing).

# Procedure prototypes

# Rotozoom procedures

proc rotozoomSurface*(
    src: Surface; angle: cdouble;
    zoom: cdouble; smooth: cint): Surface {.
      cdecl, importc: "rotozoomSurface", dynlib: SDL2_GFX_LIB.}
  ##  Rotates and zooms a surface and optional anti-aliasing.

proc rotozoomSurfaceXY*(
    src: Surface; angle: cdouble;
    zoomx: cdouble; zoomy: cdouble; smooth: cint): Surface {.
      cdecl, importc: "rotozoomSurfaceXY", dynlib: SDL2_GFX_LIB.}
  ##  Rotates and zooms a surface with different horizontal and vertical
  ##  scaling factors and optional anti-aliasing.

proc rotozoomSurfaceSize*(
    width: cint; height: cint; angle: cdouble;
    zoom: cdouble; dstwidth: ptr cint; dstheight: ptr cint) {.
      cdecl, importc: "rotozoomSurfaceSize", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` the size of the resulting target surface
  ##  for a ``rotozoomSurface()`` call.

proc rotozoomSurfaceSizeXY*(
    width: cint; height: cint; angle: cdouble;
    zoomx: cdouble; zoomy: cdouble; dstwidth: ptr cint; dstheight: ptr cint) {.
      cdecl, importc: "rotozoomSurfaceSizeXY", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` the size of the resulting target surface
  ##  for a ``rotozoomSurfaceXY()`` call.

# Zooming procedures

proc zoomSurface*(
    src: Surface;
    zoomx: cdouble; zoomy: cdouble; smooth: cint): Surface {.
      cdecl, importc: "zoomSurface", dynlib: SDL2_GFX_LIB.}
  ##  Zoom a surface by independent horizontal and vertical factors
  ##  with optional smoothing.

proc zoomSurfaceSize*(
    width: cint; height: cint;
    zoomx: cdouble; zoomy: cdouble; dstwidth: ptr cint; dstheight: ptr cint) {.
      cdecl, importc: "zoomSurfaceSize", dynlib: SDL2_GFX_LIB.}
  ##  Calculates the size of the target surface for a ``zoomSurface()`` call.

# Shrinking procedures

proc shrinkSurface*(
    src: Surface; factorx: cint; factory: cint): Surface {.
      cdecl, importc: "shrinkSurface", dynlib: SDL2_GFX_LIB.}
  ##  Shrink a surface by an integer ratio using averaging.

# Specialized rotation procedures

proc rotateSurface90Degrees*(
    src: Surface; numClockwiseTurns: cint): Surface {.
      cdecl, importc: "rotateSurface90Degrees", dynlib: SDL2_GFX_LIB.}
  ##  Rotates a 32 bit surface in increments of 90 degrees.
