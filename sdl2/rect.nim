#
# Simple DirectMedia Layer
# Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>
#
# This software is provided 'as-is', without any express or implied
# warranty.  In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
#

#
# Header file for SDL_rect definition and management functions.
#


type
  PPoint* = ptr TPoint
  TPoint* = object
    ##  The structure that defines a point
    ##
    ## See also: enclosePoints
    x: int
    y: int

  PRect* = ptr TRect
  TRect* = object
    ## A rectangle, with the origin at the upper left.
    ##
    ## See also: rectEmpty, 
    ## rectEquals, 
    ## hasIntersection, 
    ## intersectRect, 
    ## unionRect, 
    ## enclosePoints
    x, y: int
    w, h: int


proc rectEmpty*(r: PRect): bool {.inline.} =
  ## Returns true if the rectangle has no area.
  return ((r != nil) or (r.w <= 0) or (r.h <= 0))


proc rectEquals*(a, b: PRect): bool {.inline.} =
  ## Returns true if the two rectangles are equal.
  return ((a != nil) and (b != nil) and (a.x == b.x) and (a.y == b.y) and
         (a.w == b.w) and (a.h == b.h))


proc hasIntersection*(a, b: PRect): bool {.cdecl, importc: "SDL_HasIntersection", dynlib: LibName.}
  ## Determine whether two rectangles intersect.
  ##
  ## Return TRUE if there is an intersection, FALSE otherwise.


proc intersectRect*(a, b, result: PRect): bool {.cdecl, importc: "SDL_IntersectRect", dynlib: LibName.}
  ## Calculate the intersection of two rectangles.
  ##
  ## Return TRUE if there is an intersection, FALSE otherwise.


proc unionRect*(a, b, result: PRect) {.cdecl, importc: "SDL_UnionRect", dynlib: LibName.}
  ## Calculate the union of two rectangles.


proc enclosePoints*(points: PPoint, count: int, clip, result: PRect): bool {.cdecl, importc: "SDL_EnclosePoints", dynlib: LibName.}
  ## Calculate a minimal rectangle enclosing a set of points.
  ##
  ## Return TRUE if any points were within the clipping rect.


proc intersectRectAndLine*(rect: PRect, x1, y1, x2, y2: ptr int): bool {.cdecl, importc: "SDL_IntersectRectAndLine", dynlib: LibName.}
  ## Calculate the intersection of a rectangle and line segment.
  ##
  ## Return TRUE if there is an intersection, FALSE otherwise.

