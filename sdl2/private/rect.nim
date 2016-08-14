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

##  rect.nim
##  ========
##
##  Header file for Rect definition and management procedures.

type
  Point* = object ##  \
    ##  The object that defines a point
    ##
    ##  See also:
    ##
    ##  ``enclosePoints()``
    ##
    ##  ``pointInRect()``
    x*: cint
    y*: cint

type
  Rect* = object ##  \
    ##  A rectangle, with the origin at the upper left.
    ##
    ##  See also:
    ##
    ##  ``rectEmpty()``
    ##
    ##  ``rectEquals()``
    ##
    ##  ``hasIntersection()``
    ##
    ##  ``intersectRect()``
    ##
    ##  ``unionRect()``
    ##
    ##  ``enclosePoints()``
    x*: cint
    y*: cint
    w*: cint
    h*: cint

template pointInRect*(p, r: untyped): bool = ##  \
  ##  ``Return`` `true` if point resides inside a rectangle.
  ((p.x >= r.x) and (p.x < (r.x + r.w)) and
   (p.y >= r.y) and (p.y < (r.y + r.h)))

template rectEmpty*(r: untyped): bool = ##  \
  ##  ``Return`` `true` if the rectangle has no area.
  ((not r) or (r.w <= 0) or (r.h <= 0))

template rectEquals*(a, b: untyped): bool = ##  \
  ##  ``Return`` `true` if the two rectangles are equal.
  (a and b and
    (a.x == b.x) and (a.y == b.y) and
    (a.w == b.w) and (a.h == b.h))

proc hasIntersection*(a: ptr Rect; b: ptr Rect): bool {.
    cdecl, importc: "SDL_HasIntersection", dynlib: SDL2_LIB.}
  ##  Determine whether two rectangles intersect.
  ##
  ##  ``Return`` `true` if there is an intersection, `false` otherwise.

proc intersectRect*(a: ptr Rect; b: ptr Rect; result: ptr Rect): bool {.
    cdecl, importc: "SDL_IntersectRect", dynlib: SDL2_LIB.}
  ##  Calculate the intersection of two rectangles.
  ##
  ##  ``Return`` `true` if there is an intersection, `false` otherwise.

proc unionRect*(a: ptr Rect; b: ptr Rect; result: ptr Rect) {.
    cdecl, importc: "SDL_UnionRect", dynlib: SDL2_LIB.}
  ##  Calculate the union of two rectangles.

proc enclosePoints*(
    points: ptr Point; count: cint; clip: ptr Rect; result: ptr Rect): bool {.
    cdecl, importc: "SDL_EnclosePoints", dynlib: SDL2_LIB.}
  ##  Calculate a minimal rectangle enclosing a set of points.
  ##
  ##  ``Return`` `true` if any points were within the clipping rect.

proc intersectRectAndLine*(
    rect: ptr Rect;
    x1: ptr cint; y1: ptr cint;
    x2: ptr cint; y2: ptr cint): bool {.
    cdecl, importc: "SDL_IntersectRectAndLine", dynlib: SDL2_LIB.}
  ##  Calculate the intersection of a rectangle and line segment.
  ##
  ##  ``Return`` `true` if there is an intersection, `false` otherwise.
