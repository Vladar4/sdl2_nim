#
#
# SDL2_gfxPrimitives.h: graphics primitives for SDL
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

##  sdl_gfx_primitives.nim
##  ======================
##

{.deadCodeElim: on.}

import
  sdl

# Versioning
const
  MAJOR* = 1
  MINOR* = 0
  MICRO* = 1

# Procedure prototypes

##  ``Note:``
##  all ___Color routines expect the color to be in format `0xRRGGBBAA`.

# Pixel

proc pixelColor*(
    renderer: Renderer; x: int16; y: int16; color: uint32): cint {.
      cdecl, importc: "pixelColor", dynlib: SDL2_GFX_LIB.}
  ##  Pixel draw with alpha blending enabled if ``a`` < `255`.
  ##
  ##  ``x``, ``y``  Coordinates of the pixel.

proc pixelRGBA*(
    renderer: Renderer; x: int16; y: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "pixelRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Pixel draw with alpha blending enabled if ``a`` < `255`.
  ##
  ##  ``x``, ``y``  Coordinates of the pixel.

# Horizontal line

proc hlineColor*(
    renderer: Renderer; x1: int16; x2: int16; y: int16; color: uint32): cint {.
      cdecl, importc: "hlineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw horizontal line with alpha blending.
  ##
  ##  ``x1``  X coordinate of the first point (i.e. left) of the line.
  ##
  ##  ``x2``  X coordinate of the second point (i.e. right) of the line.
  ##
  ##  ``y`` Y coordinate of the points of the line.

proc hlineRGBA*(
    renderer: Renderer; x1: int16; x2: int16; y: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "hlineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw horizontal line with alpha blending.
  ##
  ##  ``x1``  X coordinate of the first point (i.e. left) of the line.
  ##
  ##  ``x2``  X coordinate of the second point (i.e. right) of the line.
  ##
  ##  ``y`` Y coordinate of the points of the line.

# Vertical line

proc vlineColor*(
    renderer: Renderer; x: int16; y1: int16; y2: int16; color: uint32): cint {.
      cdecl, importc: "vlineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw vertical line with alpha blending.
  ##
  ##  ``x`` X coordinate of the points of the line.
  ##
  ##  ``y1``  Y coordinate of the first point (i.e. top) of the line.
  ##
  ##  ``y2``  Y coordinate of the second point (i.e. bottom) of the line.

proc vlineRGBA*(
    renderer: Renderer; x: int16; y1: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "vlineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw vertical line with alpha blending.
  ##
  ##  ``x`` X coordinate of the points of the line.
  ##
  ##  ``y1``  Y coordinate of the first point (i.e. top) of the line.
  ##
  ##  ``y2``  Y coordinate of the second point (i.e. bottom) of the line.

# Rectangle

proc rectangleColor*(
    renderer: Renderer; x1: int16; y1: int16;
    x2: int16; y2: int16; color: uint32): cint {.
      cdecl, importc: "rectangleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw rectangle with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the rectangle.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the rectangle.

proc rectangleRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "rectangleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw rectangle with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the rectangle.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the rectangle.

# Rounded-Corner Rectangle

proc roundedRectangleColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; color: uint32): cint {.
      cdecl, importc: "roundedRectangleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner rectangle with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the rectangle.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the rectangle.
  ##
  ##  ``rad`` The radius of the corner arc.

proc roundedRectangleRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "roundedRectangleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner rectangle with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the rectangle.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the rectangle.
  ##
  ##  ``rad`` The radius of the corner arc.

# Filled rectangle (Box)

proc boxColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "boxColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw box (filled rectangle) with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the box.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the box.

proc boxRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "boxRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw box (filled rectangle) with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the box.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the box.

# Rounded-Corner Filled rectangle (Box)

proc roundedBoxColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; color: uint32): cint {.
      cdecl, importc: "roundedBoxColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner box (filled rectangle) with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the box.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the box.
  ##
  ##  ``rad`` The radius of the cornder arcs of the box.

proc roundedBoxRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "roundedBoxRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner box (filled rectangle) with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point (i.e. top right)
  ##  of the box.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point (i.e. bottom left)
  ##  of the box.
  ##
  ##  ``rad`` The radius of the cornder arcs of the box.

# Line

proc lineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "lineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw line with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the line.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point of the line.

proc lineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "lineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw line with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the line.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point of the line.

# AA Line

proc aalineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "aalineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased line with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the aa-line.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point of the aa-line.

proc aalineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aalineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased line with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the aa-line.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point of the aa-line.

# Thick Line

proc thickLineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    width: uint8; color: uint32): cint {.
      cdecl, importc: "thickLineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw thick line with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the line.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point of the line.
  ##
  ##  ``width`` Width of the line in pixels. Must be `>0`.

proc thickLineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    width: uint8; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "thickLineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw thick line with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the line.
  ##
  ##  ``x2``, ``y2``  Coordinates of the second point of the line.
  ##
  ##  ``width`` Width of the line in pixels. Must be `>0`.

# Circle

proc circleColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    color: uint32): cint {.
      cdecl, importc: "circleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw circle with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the circle.
  ##
  ##  ``rad`` Radius in pixels of the circle.

proc circleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "circleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw circle with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the circle.
  ##
  ##  ``rad`` Radius in pixels of the circle.

# Arc

proc arcColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "arcColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw arc with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the arc.
  ##
  ##  ``rad`` Radius in pixels of the arc.
  ##
  ##  ``start``, ``end`` Starting and ending radius in degrees of the arc.
  ##  `0` degrees is down, increasing counterclockwise.

proc arcRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "arcRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw arc with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the arc.
  ##
  ##  ``rad`` Radius in pixels of the arc.
  ##
  ##  ``start``, ``end`` Starting and ending radius in degrees of the arc.
  ##  `0` degrees is down, increasing counterclockwise.

# AA Circle

proc aacircleColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    color: uint32): cint {.
      cdecl, importc: "aacircleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased circle with alpha blending.
  ##
  ##  ``x``, ``y`` Coordinates of the center of the aa-circle.
  ##
  ##  ``rad`` Radius in pixels of the aa-circle.

proc aacircleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aacircleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased circle with alpha blending.
  ##
  ##  ``x``, ``y`` Coordinates of the center of the aa-circle.
  ##
  ##  ``rad`` Radius in pixels of the aa-circle.

# Filled Circle

proc filledCircleColor*(
    renderer: Renderer; x: int16; y: int16; r: int16;
    color: uint32): cint {.
      cdecl, importc: "filledCircleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled circle with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the filled circle.
  ##
  ##  ``rad`` Radius in pixels of the filled circle.

proc filledCircleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledCircleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled circle with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the filled circle.
  ##
  ##  ``rad`` Radius in pixels of the filled circle.

# Ellipse

proc ellipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "ellipseColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw ellipse with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the ellipse.
  ##
  ##  ``rx``  Horizontal radius in pixels of the ellipse.
  ##
  ##  ``ry``  Vertical radius in pixels of the ellipse.

proc ellipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "ellipseRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw ellipse with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the ellipse.
  ##
  ##  ``rx``  Horizontal radius in pixels of the ellipse.
  ##
  ##  ``ry``  Vertical radius in pixels of the ellipse.

# AA Ellipse

proc aaellipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "aaellipseColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased ellipse with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the aa-ellipse.
  ##
  ##  ``rx``  Horizontal radius in pixels of the aa-ellipse.
  ##
  ##  ``ry``  Vertical radius in pixels of the aa-ellipse.

proc aaellipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aaellipseRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased ellipse with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the aa-ellipse.
  ##
  ##  ``rx``  Horizontal radius in pixels of the aa-ellipse.
  ##
  ##  ``ry``  Vertical radius in pixels of the aa-ellipse.

# Filled Ellipse

proc filledEllipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "filledEllipseColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled ellipse with alpha blending.
  ##
  ##  ``x``, ``y`` Coordinates of the center of the filled ellipse.
  ##
  ##  ``rx``  Horizontal radius in pixels of the filled ellipse.
  ##
  ##  ``ry``  Vertical radius in pixels of the filled ellipse.

proc filledEllipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledEllipseRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled ellipse with alpha blending.
  ##
  ##  ``x``, ``y`` Coordinates of the center of the filled ellipse.
  ##
  ##  ``rx``  Horizontal radius in pixels of the filled ellipse.
  ##
  ##  ``ry``  Vertical radius in pixels of the filled ellipse.

# Pie

proc pieColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "pieColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw pie (outline) with alpha blending.
  ##
  ##  ``x``, ``y`` Coordinates of the center of the pie.
  ##
  ##  ``rad`` Radius in pixels of the pie.
  ##
  ##  ``start``, ``end``  Starting and ending radius in degrees of the pie.

proc pieRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "pieRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw pie (outline) with alpha blending.
  ##
  ##  ``x``, ``y`` Coordinates of the center of the pie.
  ##
  ##  ``rad`` Radius in pixels of the pie.
  ##
  ##  ``start``, ``end``  Starting and ending radius in degrees of the pie.

# Filled Pie

proc filledPieColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "filledPieColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled pie with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the filled pie.
  ##
  ##  ``rad`` Radius in pixels of the filled pie.
  ##
  ##  ``start``, ``end`` Starting and ending radius in degrees
  ##  of the filled pie.

proc filledPieRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledPieRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled pie with alpha blending.
  ##
  ##  ``x``, ``y``  Coordinates of the center of the filled pie.
  ##
  ##  ``rad`` Radius in pixels of the filled pie.
  ##
  ##  ``start``, ``end`` Starting and ending radius in degrees
  ##  of the filled pie.

# Trigon

proc trigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "trigonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw trigon (triangle outline) with alpha blending.
  ##
  ##  ``x1``, ``y1`` Coordinates of the first point of the trigon.
  ##
  ##  ``x2``, ``y2`` Coordinates of the second point of the trigon.
  ##
  ##  ``x3``, ``y3`` Coordinates of the third point of the trigon.

proc trigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "trigonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw trigon (triangle outline) with alpha blending.
  ##
  ##  ``x1``, ``y1`` Coordinates of the first point of the trigon.
  ##
  ##  ``x2``, ``y2`` Coordinates of the second point of the trigon.
  ##
  ##  ``x3``, ``y3`` Coordinates of the third point of the trigon.

# AA-Trigon

proc aatrigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "aatrigonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased trigon (triangle outline) with alpha blending.
  ##
  ##  ``x1``, ``y1`` Coordinates of the first point of the aa-trigon.
  ##
  ##  ``x2``, ``y2`` Coordinates of the second point of the aa-trigon.
  ##
  ##  ``x3``, ``y3`` Coordinates of the third point of the aa-trigon.

proc aatrigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aatrigonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased trigon (triangle outline) with alpha blending.
  ##
  ##  ``x1``, ``y1`` Coordinates of the first point of the aa-trigon.
  ##
  ##  ``x2``, ``y2`` Coordinates of the second point of the aa-trigon.
  ##
  ##  ``x3``, ``y3`` Coordinates of the third point of the aa-trigon.

# Filled Trigon

proc filledTrigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "filledTrigonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled trigon (triangle) with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the filled trigon.
  ##
  ##  ``x2``, ``y2``  Coordinates of the first point of the filled trigon.
  ##
  ##  ``x3``, ``y3``  Coordinates of the first point of the filled trigon.

proc filledTrigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledTrigonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled trigon (triangle) with alpha blending.
  ##
  ##  ``x1``, ``y1``  Coordinates of the first point of the filled trigon.
  ##
  ##  ``x2``, ``y2``  Coordinates of the first point of the filled trigon.
  ##
  ##  ``x3``, ``y3``  Coordinates of the first point of the filled trigon.

# Polygon

proc polygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "polygonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw polygon with alpha blending.
  ##
  ##  ``vx``, ``vy`` Vertex arrays containing coordinates of the points
  ##  of the polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.

proc polygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "polygonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw polygon with alpha blending.
  ##
  ##  ``vx``, ``vy`` Vertex arrays containing coordinates of the points
  ##  of the polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.

# AA-Polygon

proc aapolygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "aapolygonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased polygon with alpha blending.
  ##
  ##  ``vx``, ``vy`` Vertex arrays containing coordinates of the points
  ##  of the aa-polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.

proc aapolygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aapolygonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased polygon with alpha blending.
  ##
  ##  ``vx``, ``vy`` Vertex arrays containing coordinates of the points
  ##  of the aa-polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.

# Filled Polygon

proc filledPolygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "filledPolygonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled polygon with alpha blending.
  ##
  ##  ``vx``, ``vy``  Vertex arrays containing coordinates of the points
  ##  of the filled polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.

proc filledPolygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledPolygonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled polygon with alpha blending.
  ##
  ##  ``vx``, ``vy``  Vertex arrays containing coordinates of the points
  ##  of the filled polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.

# Textured Polygon

proc texturedPolygon*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; texture: Surface; texture_dx: cint; texture_dy: cint): cint {.
      cdecl, importc: "texturedPolygon", dynlib: SDL2_GFX_LIB.}
  ##  Draw polygon filled with the given texture.
  ##
  ##  ``vx``, ``vy``  Vertex arrays containing coordinates of the points
  ##  of the textured polygon.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.
  ##
  ##  ``texture`` The ``sdl.Surface`` to use to fill the polygon.
  ##
  ##  ``texture_dx``, ``texture_dy``  The offset of the texture
  ##  relative to the screen. If you move the polygon `10` pixels to the left
  ##  and want the texture to appear the same, you need to increase
  ##  the ``texture_dx`` value.

# Bezier

proc bezierColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; s: cint; color: uint32): cint {.
      cdecl, importc: "bezierColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw a bezier curve with alpha blending.
  ##
  ##  ``vx``, ``vy``  Vertex arrays containing coordinates of the points
  ##  of the bezier curve.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.
  ##
  ##  ``s`` Number of steps for the interpolation. Minimum number is `2`.

proc bezierRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; s: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "bezierRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw a bezier curve with alpha blending.
  ##
  ##  ``vx``, ``vy``  Vertex arrays containing coordinates of the points
  ##  of the bezier curve.
  ##
  ##  ``n`` Number of points in the vertex array. Minimum number is `3`.
  ##
  ##  ``s`` Number of steps for the interpolation. Minimum number is `2`.

# Characters/Strings

proc gfxPrimitivesSetFont*(fontdata: pointer; cw: uint32; ch: uint32) {.
    cdecl, importc: "gfxPrimitivesSetFont", dynlib: SDL2_GFX_LIB.}
  ##  Sets or resets the current global font data.
  ##
  ##  The font data array is organized in follows:
  ##
  ##  `[fontdata] = [character 0][character 1]...[character 255]`
  ##  where
  ##  `[character n] = [byte 1 row 1][byte 2 row 1]...[byte {pitch} row 1]
  ##  [byte 1 row 2] ...[byte {pitch} row height]`
  ##  where
  ##  `[byte n] = [bit 0]...[bit 7]`
  ##  where
  ##  `[bit n] = [0 for transparent pixel|1 for colored pixel]`
  ##
  ##  ``fontdata``  Pointer to array of font data. Set to `nil`, to reset
  ##  global font to the default `8x8` font.
  ##
  ##  ``cw``, ``ch``  Width and height of character in bytes.
  ##  Ignored if ``fontdata`` == `nil`.

proc gfxPrimitivesSetFontRotation*(rotation: uint32) {.
    cdecl, importc: "gfxPrimitivesSetFontRotation", dynlib: SDL2_GFX_LIB.}
  ##  Sets current global font character rotation steps.
  ##
  ##  Default is `0` (no rotation).
  ##
  ##  `1` = 90deg clockwise.
  ##
  ##  `2` = 180deg clockwise.
  ##
  ##  `3` = 270deg clockwise.
  ##
  ##  Changing the rotation, will reset the character cache.
  ##
  ##  ``rotation``  Number of 90deg clockwise steps to rotate.

proc characterColor*(
    renderer: Renderer; x: int16; y: int16; c: char;
    color: uint32): cint {.
      cdecl, importc: "characterColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw a character of the currently set font.
  ##
  ##  ``x``, ``y``  Coordinates of the upper left corner of the character.
  ##
  ##  ``c`` The character to draw.

proc characterRGBA*(
    renderer: Renderer; x: int16; y: int16; c: char;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "characterRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw a character of the currently set font.
  ##
  ##  ``x``, ``y``  Coordinates of the upper left corner of the character.
  ##
  ##  ``c`` The character to draw.

proc stringColor*(
    renderer: Renderer; x: int16; y: int16; s: cstring;
    color: uint32): cint {.
      cdecl, importc: "stringColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw a string in the currently set font.
  ##
  ##  ``x``, ``y``  Coordinates of the upper left corner of the string.
  ##
  ##  ``s`` The string to draw.

proc stringRGBA*(
    renderer: Renderer; x: int16; y: int16; s: cstring;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "stringRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw a string in the currently set font.
  ##
  ##  ``x``, ``y``  Coordinates of the upper left corner of the string.
  ##
  ##  ``s`` The string to draw.

