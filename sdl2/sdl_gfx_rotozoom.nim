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

{.deadCodeElim: on.}

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
  ##
  ##  Rotates and zoomes a 32-bit or 8-bit ``src`` surface to newly created
  ##  ``dst`` surface. If the surface is not 8-bit or 32-bit RGBA/ABGR,
  ##  it will be converted into a 32-bit RGBA format on the fly.
  ##
  ##  ``angle`` The angle to rotate in degrees.
  ##
  ##  ``zoom``  The scaling factor.
  ##
  ##  ``smooth``  Antialiasing flag. Set to `SMOOTHING_ON` to enable.
  ##
  ##  ``Return`` the new rotozoomed surface.

proc rotozoomSurfaceXY*(
    src: Surface; angle: cdouble;
    zoomx: cdouble; zoomy: cdouble; smooth: cint): Surface {.
      cdecl, importc: "rotozoomSurfaceXY", dynlib: SDL2_GFX_LIB.}
  ##  Rotates and zooms a surface with different horizontal and vertical
  ##  scaling factors and optional anti-aliasing.
  ##
  ##  Rotates and zooms a 32-bit or 8-bit ``src`` surface to newly created
  ##  ``dst`` surface. If the surface is not 8-bit or 32-bit RGBA/ABGR,
  ##  it will be converted into a 32-bit RGBA format on the fly.
  ##
  ##  ``angle`` The angle to rotate in degrees.
  ##
  ##  ``zoomx`` The horizontal scaling factor.
  ##
  ##  ``zoomy`` The vertical scaling factor.
  ##
  ##  ``smooth``  Antialiasing flag. Set to `SMOOTHING_ON` to enable.
  ##
  ##  ``Return`` the new rotozoomed surface.

proc rotozoomSurfaceSize*(
    width: cint; height: cint; angle: cdouble;
    zoom: cdouble; dstwidth: ptr cint; dstheight: ptr cint) {.
      cdecl, importc: "rotozoomSurfaceSize", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` the size of the resulting target surface
  ##  for a ``rotozoomSurface()`` call.
  ##
  ##  ``width`` The source surface width.
  ##
  ##  ``height``  The source surface height.
  ##
  ##  ``angle`` The angle to rotate in degrees.
  ##
  ##  ``zoom``  The scaling factor.
  ##
  ##  ``dstwidth``  The calculated width of the rotozoomed destination surface.
  ##
  ##  ``dstheight`` The calculated height of the rotozoomed destination surface.

proc rotozoomSurfaceSizeXY*(
    width: cint; height: cint; angle: cdouble;
    zoomx: cdouble; zoomy: cdouble; dstwidth: ptr cint; dstheight: ptr cint) {.
      cdecl, importc: "rotozoomSurfaceSizeXY", dynlib: SDL2_GFX_LIB.}
  ##  ``Return`` the size of the resulting target surface
  ##  for a ``rotozoomSurfaceXY()`` call.
  ##
  ##  ``width`` The source surface width.
  ##
  ##  ``height``  The source surface height.
  ##
  ##  ``angle`` The angle to rotate in degrees.
  ##
  ##  ``zoomx``  The horizontal scaling factor.
  ##
  ##  ``zoomy`` The vertical scaling factor.
  ##
  ##  ``dstwidth``  The calculated width of the rotozoomed destination surface.
  ##
  ##  ``dstheight`` The calculated height of the rotozoomed destination surface.

# Zooming procedures

proc zoomSurface*(
    src: Surface;
    zoomx: cdouble; zoomy: cdouble; smooth: cint): Surface {.
      cdecl, importc: "zoomSurface", dynlib: SDL2_GFX_LIB.}
  ##  Zoom a surface by independent horizontal and vertical factors
  ##  with optional smoothing.
  ##
  ##  ``zoomx`` The horizontal zoom factor.
  ##
  ##  ``zoomy`` The vertical zoom factor.
  ##
  ##  ``smooth`` Antialiasing flag. Set to `SMOOTHING_ON` to enable.
  ##
  ##  ``Return`` the new, zoomed surface.

proc zoomSurfaceSize*(
    width: cint; height: cint;
    zoomx: cdouble; zoomy: cdouble; dstwidth: ptr cint; dstheight: ptr cint) {.
      cdecl, importc: "zoomSurfaceSize", dynlib: SDL2_GFX_LIB.}
  ##  Calculates the size of the target surface for a ``zoomSurface()`` call.
  ##
  ##  The minimum size of the target surface is `1`.
  ##  The input facors can be positive or negative.
  ##
  ##  ``width`` The width of the soruce surface to zoom.
  ##
  ##  ``height`` The height of the source surface to zoom.
  ##
  ##  ``zoomx`` The horizontal zoom factor.
  ##
  ##  ``zoomy`` The vertical zoom factor.
  ##
  ##  ``dstwidth``  Pointer to an integer to store the calculated width
  ##  of the zoomed target surface.
  ##
  ##  ``dstheight`` Pointer to an integer to store the calculated height
  ##  of the zoomed target surface.

# Shrinking procedures

proc shrinkSurface*(
    src: Surface; factorx: cint; factory: cint): Surface {.
      cdecl, importc: "shrinkSurface", dynlib: SDL2_GFX_LIB.}
  ##  Shrink a surface by an integer ratio using averaging.
  ##
  ##  ``factorx`` The horizontal shrinking ratio.
  ##
  ##  ``factory`` The vertical shrinking ratio.
  ##
  ##  ``Return`` the new, shrunken surface.

# Specialized rotation procedures

proc rotateSurface90Degrees*(
    src: Surface; numClockwiseTurns: cint): Surface {.
      cdecl, importc: "rotateSurface90Degrees", dynlib: SDL2_GFX_LIB.}
  ##  Rotates a 32 bit surface in increments of 90 degrees.
  ##
  ##  Specialized `90` degree rotator which rotates a ``src`` surface
  ##  in `90` degree increments clockwise returning a new surface.
  ##  Faster than rotozoomer since no scanning or interpolation takes place.
  ##
  ##  Input surface must be 8/16/24/32-bit.
  ##
  ##  (code contributed by J. Schiller, improved by C. Allport and A. Schiffler)
  ##
  ##  ``numClockwiseTurns`` Number of clockwise `90` degree turns to apply
  ##  to the source.
  ##
  ##  ``Return`` the new, rotated surface,
  ##  or `nil` for surfaces with incorrect input format.
