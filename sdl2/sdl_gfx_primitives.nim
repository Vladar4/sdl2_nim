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

import
  sdl

# Versioning
const
  MAJOR* = 1
  MINOR* = 0
  MICRO* = 1

# Function Prototypes

## ``Note:`` all ___Color routines expect the color to be in format 0xRRGGBBAA.

# Pixel

proc pixelColor*(
    renderer: Renderer; x: int16; y: int16; color: uint32): cint {.
      cdecl, importc: "pixelColor", dynlib: SDL2_GFX_LIB.}

proc pixelRGBA*(
    renderer: Renderer; x: int16; y: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "pixelRGBA", dynlib: SDL2_GFX_LIB.}

# Horizontal line

proc hlineColor*(
    renderer: Renderer; x1: int16; x2: int16; y: int16; color: uint32): cint {.
      cdecl, importc: "hlineColor", dynlib: SDL2_GFX_LIB.}

proc hlineRGBA*(
    renderer: Renderer; x1: int16; x2: int16; y: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "hlineRGBA", dynlib: SDL2_GFX_LIB.}

# Vertical line

proc vlineColor*(
    renderer: Renderer; x: int16; y1: int16; y2: int16; color: uint32): cint {.
      cdecl, importc: "vlineColor", dynlib: SDL2_GFX_LIB.}

proc vlineRGBA*(
    renderer: Renderer; x: int16; y1: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "vlineRGBA", dynlib: SDL2_GFX_LIB.}

# Rectangle

proc rectangleColor*(
    renderer: Renderer; x1: int16; y1: int16;
    x2: int16; y2: int16; color: uint32): cint {.
      cdecl, importc: "rectangleColor", dynlib: SDL2_GFX_LIB.}

proc rectangleRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "rectangleRGBA", dynlib: SDL2_GFX_LIB.}

# Rounded-Corner Rectangle

proc roundedRectangleColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; color: uint32): cint {.
      cdecl, importc: "roundedRectangleColor", dynlib: SDL2_GFX_LIB.}

proc roundedRectangleRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "roundedRectangleRGBA", dynlib: SDL2_GFX_LIB.}

# Filled rectangle (Box)

proc boxColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "boxColor", dynlib: SDL2_GFX_LIB.}

proc boxRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "boxRGBA", dynlib: SDL2_GFX_LIB.}

# Rounded-Corner Filled rectangle (Box)

proc roundedBoxColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; color: uint32): cint {.
      cdecl, importc: "roundedBoxColor", dynlib: SDL2_GFX_LIB.}

proc roundedBoxRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    rad: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "roundedBoxRGBA", dynlib: SDL2_GFX_LIB.}

# Line

proc lineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "lineColor", dynlib: SDL2_GFX_LIB.}

proc lineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "lineRGBA", dynlib: SDL2_GFX_LIB.}

# AA Line

proc aalineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    color: uint32): cint {.
      cdecl, importc: "aalineColor", dynlib: SDL2_GFX_LIB.}

proc aalineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aalineRGBA", dynlib: SDL2_GFX_LIB.}

# Thick Line

proc thickLineColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    width: uint8; color: uint32): cint {.
      cdecl, importc: "thickLineColor", dynlib: SDL2_GFX_LIB.}

proc thickLineRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    width: uint8; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "thickLineRGBA", dynlib: SDL2_GFX_LIB.}

# Circle

proc circleColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    color: uint32): cint {.
      cdecl, importc: "circleColor", dynlib: SDL2_GFX_LIB.}
proc circleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "circleRGBA", dynlib: SDL2_GFX_LIB.}

# Arc

proc arcColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "arcColor", dynlib: SDL2_GFX_LIB.}

proc arcRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "arcRGBA", dynlib: SDL2_GFX_LIB.}

# AA Circle

proc aacircleColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    color: uint32): cint {.
      cdecl, importc: "aacircleColor", dynlib: SDL2_GFX_LIB.}

proc aacircleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aacircleRGBA", dynlib: SDL2_GFX_LIB.}

# Filled Circle

proc filledCircleColor*(
    renderer: Renderer; x: int16; y: int16; r: int16;
    color: uint32): cint {.
      cdecl, importc: "filledCircleColor", dynlib: SDL2_GFX_LIB.}

proc filledCircleRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledCircleRGBA", dynlib: SDL2_GFX_LIB.}

# Ellipse

proc ellipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "ellipseColor", dynlib: SDL2_GFX_LIB.}

proc ellipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "ellipseRGBA", dynlib: SDL2_GFX_LIB.}

# AA Ellipse

proc aaellipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "aaellipseColor", dynlib: SDL2_GFX_LIB.}

proc aaellipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aaellipseRGBA", dynlib: SDL2_GFX_LIB.}

# Filled Ellipse

proc filledEllipseColor*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    color: uint32): cint {.
      cdecl, importc: "filledEllipseColor", dynlib: SDL2_GFX_LIB.}

proc filledEllipseRGBA*(
    renderer: Renderer; x: int16; y: int16; rx: int16; ry: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledEllipseRGBA", dynlib: SDL2_GFX_LIB.}

# Pie

proc pieColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "pieColor", dynlib: SDL2_GFX_LIB.}

proc pieRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "pieRGBA", dynlib: SDL2_GFX_LIB.}

# Filled Pie

proc filledPieColor*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16; color: uint32): cint {.
      cdecl, importc: "filledPieColor", dynlib: SDL2_GFX_LIB.}

proc filledPieRGBA*(
    renderer: Renderer; x: int16; y: int16; rad: int16;
    start: int16; finish: int16;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledPieRGBA", dynlib: SDL2_GFX_LIB.}

# Trigon

proc trigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "trigonColor", dynlib: SDL2_GFX_LIB.}

proc trigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "trigonRGBA", dynlib: SDL2_GFX_LIB.}

# AA-Trigon

proc aatrigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "aatrigonColor", dynlib: SDL2_GFX_LIB.}

proc aatrigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aatrigonRGBA", dynlib: SDL2_GFX_LIB.}

# Filled Trigon

proc filledTrigonColor*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; color: uint32): cint {.
      cdecl, importc: "filledTrigonColor", dynlib: SDL2_GFX_LIB.}

proc filledTrigonRGBA*(
    renderer: Renderer; x1: int16; y1: int16; x2: int16; y2: int16;
    x3: int16; y3: int16; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledTrigonRGBA", dynlib: SDL2_GFX_LIB.}

# Polygon

proc polygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "polygonColor", dynlib: SDL2_GFX_LIB.}

proc polygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "polygonRGBA", dynlib: SDL2_GFX_LIB.}

# AA-Polygon

proc aapolygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "aapolygonColor", dynlib: SDL2_GFX_LIB.}

proc aapolygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "aapolygonRGBA", dynlib: SDL2_GFX_LIB.}

# Filled Polygon

proc filledPolygonColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; color: uint32): cint {.
      cdecl, importc: "filledPolygonColor", dynlib: SDL2_GFX_LIB.}

proc filledPolygonRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "filledPolygonRGBA", dynlib: SDL2_GFX_LIB.}

# Textured Polygon

proc texturedPolygon*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; texture: Surface; texture_dx: cint; texture_dy: cint): cint {.
      cdecl, importc: "texturedPolygon", dynlib: SDL2_GFX_LIB.}

# Bezier

proc bezierColor*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; s: cint; color: uint32): cint {.
      cdecl, importc: "bezierColor", dynlib: SDL2_GFX_LIB.}

proc bezierRGBA*(
    renderer: Renderer; vx: ptr int16; vy: ptr int16;
    n: cint; s: cint; r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "bezierRGBA", dynlib: SDL2_GFX_LIB.}

# Characters/Strings

proc gfxPrimitivesSetFont*(fontdata: pointer; cw: uint32; ch: uint32) {.
    cdecl, importc: "gfxPrimitivesSetFont", dynlib: SDL2_GFX_LIB.}

proc gfxPrimitivesSetFontRotation*(rotation: uint32) {.
    cdecl, importc: "gfxPrimitivesSetFontRotation", dynlib: SDL2_GFX_LIB.}

proc characterColor*(
    renderer: Renderer; x: int16; y: int16; c: char;
    color: uint32): cint {.
      cdecl, importc: "characterColor", dynlib: SDL2_GFX_LIB.}

proc characterRGBA*(
    renderer: Renderer; x: int16; y: int16; c: char;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "characterRGBA", dynlib: SDL2_GFX_LIB.}

proc stringColor*(
    renderer: Renderer; x: int16; y: int16; s: cstring;
    color: uint32): cint {.
      cdecl, importc: "stringColor", dynlib: SDL2_GFX_LIB.}

proc stringRGBA*(
    renderer: Renderer; x: int16; y: int16; s: cstring;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "stringRGBA", dynlib: SDL2_GFX_LIB.}
