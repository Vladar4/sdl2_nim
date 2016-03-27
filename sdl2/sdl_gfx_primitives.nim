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

import
  sdl

# Versioning
const
  MAJOR* = 1
  MINOR* = 0
  MICRO* = 1

# Procedure prototypes

## ``Note:`` all ___Color routines expect the color to be in format 0xRRGGBBAA.

# Pixel

proc pixelColor*(
    renderer: Renderer; x: int16; y: int16; color: uint32): cint {.
      cdecl, importc: "pixelColor", dynlib: SDL2_GFX_LIB.}
  ##  Pixel draw with alpha blending enabled if ``a`` < `255`.

proc pixelRGBA*(
    renderer: Renderer; x: int16; y: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "pixelRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Pixel draw with alpha blending enabled if ``a`` < `255`.

# Horizontal line

proc hlineColor*(
    renderer: Renderer; x1: int16; x2: int16; y: int16; color: uint32): cint {.
      cdecl, importc: "hlineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw horizontal line with alpha blending.

proc hlineRGBA*(
    renderer: Renderer; x1: int16; x2: int16; y: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "hlineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw horizontal line with alpha blending.

# Vertical line

proc vlineColor*(
    renderer: Renderer; x: int16; y1: int16; y2: int16; color: uint32): cint {.
      cdecl, importc: "vlineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw vertical line with alpha blending.

proc vlineRGBA*(
    renderer: Renderer; x: int16; y1: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "vlineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw vertical line with alpha blending.

# Rectangle

proc rectangleColor*(
    renderer: Renderer; x1: int16; y1: int16;
    x2: int16; y2: int16; color: uint32): cint {.
      cdecl, importc: "rectangleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw rectangle with alpha blending.

proc rectangleRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "rectangleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw rectangle with alpha blending.

# Rounded-Corner Rectangle

proc roundedRectangleColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; color: uint32): cint {.
      cdecl, importc: "roundedRectangleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner rectangle with alpha blending.

proc roundedRectangleRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "roundedRectangleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner rectangle with alpha blending.

# Filled rectangle (Box)

proc boxColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "boxColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw box (filled rectangle) with alpha blending.

proc boxRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "boxRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw box (filled rectangle) with alpha blending.

# Rounded-Corner Filled rectangle (Box)

proc roundedBoxColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; color: uint32): cint {.
      cdecl, importc: "roundedBoxColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner box (filled rectangle) with alpha blending.

proc roundedBoxRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "roundedBoxRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw rounded-corner box (filled rectangle) with alpha blending.

# Line

proc lineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "lineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw line with alpha blending.

proc lineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "lineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw line with alpha blending.

# AA Line

proc aalineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "aalineColor", dynlib: SDL2_GFX_LIB.}
  ##  draw anti-aliased line with alpha blending.

proc aalineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aalineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  draw anti-aliased line with alpha blending.

# Thick Line

proc thickLineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    width: uint8; color: uint32): cint {.
      cdecl, importc: "thickLineColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw thick line with alpha blending.

proc thickLineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    width: uint8; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "thickLineRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw thick line with alpha blending.

# Circle

proc circleColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    color: uint32): cint {.
      cdecl, importc: "circleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw circle with alpha blending.

proc circleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "circleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw circle with alpha blending.

# Arc

proc arcColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "arcColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw arc with alpha blending.

proc arcRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "arcRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw arc with alpha blending.

# AA Circle

proc aacircleColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    color: uint32): cint {.
      cdecl, importc: "aacircleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased circle with alpha blending.

proc aacircleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aacircleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased circle with alpha blending.

# Filled Circle

proc filledCircleColor*(
    renderer: Renderer; x: int16; y: int16; r: int16;
    color: uint32): cint {.
      cdecl, importc: "filledCircleColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled circle with alpha blending.

proc filledCircleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledCircleRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled circle with alpha blending.

# Ellipse

proc ellipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "ellipseColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw ellipse with alpha blending.

proc ellipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "ellipseRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw ellipse with alpha blending.

# AA Ellipse

proc aaellipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "aaellipseColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased ellipse with alpha blending.

proc aaellipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aaellipseRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased ellipse with alpha blending.

# Filled Ellipse

proc filledEllipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "filledEllipseColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled ellipse with alpha blending.

proc filledEllipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledEllipseRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled ellipse with alpha blending.

# Pie

proc pieColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "pieColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw pie (outline) with alpha blending.

proc pieRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "pieRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw pie (outline) with alpha blending.

# Filled Pie

proc filledPieColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "filledPieColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled pie with alpha blending.

proc filledPieRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledPieRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled pie with alpha blending.

# Trigon

proc trigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "trigonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw trigon (triangle outline) with alpha blending.

proc trigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "trigonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw trigon (triangle outline) with alpha blending.

# AA-Trigon

proc aatrigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "aatrigonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased trigon (triangle outline) with alpha blending.

proc aatrigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aatrigonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased trigon (triangle outline) with alpha blending.

# Filled Trigon

proc filledTrigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "filledTrigonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled trigon (triangle) with alpha blending.

proc filledTrigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledTrigonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled trigon (triangle) with alpha blending.

# Polygon

proc polygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "polygonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw polygon with alpha blending.

proc polygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "polygonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw polygon with alpha blending.

# AA-Polygon

proc aapolygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "aapolygonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased polygon with alpha blending.

proc aapolygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aapolygonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw anti-aliased polygon with alpha blending.

# Filled Polygon

proc filledPolygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "filledPolygonColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled polygon with alpha blending.

proc filledPolygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledPolygonRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw filled polygon with alpha blending.

# Textured Polygon

proc texturedPolygon*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; texture: Surface; texture_dx: cint; texture_dy: cint): cint {.
      cdecl, importc: "texturedPolygon", dynlib: SDL2_GFX_LIB.}
  ##  Draw polygon filled with the given texture.

# Bezier

proc bezierColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; s: cint; color: uint32): cint {.
      cdecl, importc: "bezierColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw a bezier curve with alpha blending.

proc bezierRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; s: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "bezierRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw a bezier curve with alpha blending.

# Characters/Strings

proc gfxPrimitivesSetFont*(fontdata: pointer; cw: uint32; ch: uint32) {.
    cdecl, importc: "gfxPrimitivesSetFont", dynlib: SDL2_GFX_LIB.}
  ##  Sets or resets the current global font data.

proc gfxPrimitivesSetFontRotation*(rotation: uint32) {.
    cdecl, importc: "gfxPrimitivesSetFontRotation", dynlib: SDL2_GFX_LIB.}
  ##  Sets current global font character rotation steps.

proc characterColor*(
    renderer: Renderer; x: int16; y: int16; c: char;
    color: uint32): cint {.
      cdecl, importc: "characterColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw a character of the currently set font.

proc characterRGBA*(
    renderer: Renderer; x: int16; y: int16; c: char;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "characterRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw a character of the currently set font.

proc stringColor*(
    renderer: Renderer; x: int16; y: int16; s: cstring;
    color: uint32): cint {.
      cdecl, importc: "stringColor", dynlib: SDL2_GFX_LIB.}
  ##  Draw a string in the currently set font.

proc stringRGBA*(
    renderer: Renderer; x: int16; y: int16; s: cstring;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "stringRGBA", dynlib: SDL2_GFX_LIB.}
  ##  Draw a string in the currently set font.
