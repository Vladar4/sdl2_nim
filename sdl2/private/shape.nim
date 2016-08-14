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

##  shape.nim
##  =========
##
##  Header file for the shaped window API.

const
  NONSHAPEABLE_WINDOW* = - 1
  INVALID_SHAPE_ARGUMENT* = - 2
  WINDOW_LACKS_SHAPE* = - 3

proc createShapedWindow*(
    title: cstring;
    x: cuint; y: cuint; w: cuint; h: cuint; flags: uint32): Window {.
      cdecl, importc: "SDL_CreateShapedWindow", dynlib: SDL2_LIB.}
  ##  Create a window that can be shaped with the specified position,
  ##  dimensions, and flags.
  ##
  ##  ``title`` The title of the window, in UTF-8 encoding.
  ##
  ##  ``x`` The x position of the window, `WINDOWPOS_CENTERED`,
  ##  or `WINDOWPOS_UNDEFINED`.
  ##
  ##  ``y`` The y position of the window, `WINDOWPOS_CENTERED`,
  ##  or `WINDOWPOS_UNDEFINED`.
  ##
  ##  ``w`` The width of the window.
  ##
  ##  ``h`` The height of the window.
  ##
  ##  ``flags``
  ##    The flags for the window, a mask of `WINDOW_BORDERLESS`
  ##    with any of the following:
  ##    `WINDOW_OPENGL`,    `WINDOW_INPUT_GRABBED`,
  ##    `WINDOW_HIDDEN`,    `WINDOW_RESIZABLE`,
  ##    `WINDOW_MAXIMIZED`, `WINDOW_MINIMIZED`,
  ##    `WINDOW_BORDERLESS` is always set,
  ##    and `WINDOW_FULLSCREEN` is always unset.
  ##
  ##  ``Return`` The window created, or `nil` if window creation failed.
  ##
  ##  See also:
  ##
  ##  ``destroyWindow()``

proc isShapedWindow*(window: Window): bool {.
    cdecl, importc: "SDL_IsShapedWindow", dynlib: SDL2_LIB.}
  ##  Return whether the given window is a shaped window.
  ##
  ##  ``window`` The window to query for being shaped.
  ##
  ##  ``Return`` `true` if the window is a window that can be shaped,
  ##  `false` if the window is unshaped or `nil`.
  ##
  ##  See also:
  ##
  ##  ``createShapedWindow()``

type
  WindowShapeMode* {.size: sizeof(cint).} = enum ##  \
    ##  An enum denoting the specific type of contents
    ##  present in an ``WindowShapeParams`` union.
    ShapeModeDefault, ##  \
      ##  The default mode, a binarized alpha cutoff of 1.
    ShapeModeBinarizeAlpha, ##  \
      ##  A binarized alpha cutoff with a given integer value.
    ShapeModeReverseBinarizeAlpha, ##  \
      ##  A binarized alpha cutoff with a given integer value,
      ##  but with the opposite comparison.
    ShapeModeColorKey ##  \
      ## A color key is applied.

template shapeModeAlpha*(mode: untyped): untyped =
  ( mode == ShapeModeDefault or
    mode == ShapeModeBinarizeAlpha or
    mode == ShapeModeReverseBinarizeAlpha)

type
  WindowShapeParams* = object  {.union.} ##  \
    ##  A union containing parameters for shaped windows.
    binarizationCutoff*: uint8 ##  \
      ##  A cutoff alpha value for binarization
      ##  of the window shape's alpha channel.
    colorKey*: Color

type
  WindowShapeModeObj* = object ##  \
    ##  A struct that tags the ``WindowShapeParams`` union
    ##  with an enum describing the type of its contents.
    mode*: WindowShapeMode ##  The mode of these window-shape parameters.
    parameters*: WindowShapeParams ##  Window-shape parameters.

proc setWindowShape*(
    window: Window;
    shape: Surface; shape_mode: ptr WindowShapeModeObj): cint {.
      cdecl, importc: "SDL_SetWindowShape", dynlib: SDL2_LIB.}
  ##  Set the shape and parameters of a shaped window.
  ##
  ##  ``window`` The shaped window whose parameters should be set.
  ##
  ##  ``shape`` A surface encoding the desired shape for the window.
  ##
  ##  ``shape_mode`` The parameters to set for the shaped window.
  ##
  ##  ``Return`` `0` on success, `INVALID_SHAPE_ARGUMENT` on invalid an invalid
  ##  shape argument, or `NONSHAPEABLE_WINDOW` if the ``Window`` given does not
  ##  reference a valid shaped window.
  ##
  ##  See also:
  ##
  ##  ``WindowShapeMode``
  ##
  ##  ``getShapedWindowMode()``

proc getShapedWindowMode*(
    window: Window; shape_mode: ptr WindowShapeModeObj): cint {.
      cdecl, importc: "SDL_GetShapedWindowMode", dynlib: SDL2_LIB.}
  ##  Get the shape parameters of a shaped window.
  ##
  ##  ``window`` The shaped window whose parameters should be retrieved.
  ##
  ##  ``shape_mode`` An empty shape-mode structure to fill,
  ##  or `nil` to check whether the window has a shape.
  ##
  ##  ``Return`` `0` if the window has a shape and, provided ``shape_mode``
  ##  was not `nil`, ``shape_mode`` has been filled with the mode data,
  ##  `NONSHAPEABLE_WINDOW` if the ``Window`` given is not a shaped window,
  ##  or `WINDOW_LACKS_SHAPE` if the ``Window`` given is a shapeable window
  ##  currently lacking a shape.
  ##
  ##  See also:
  ##
  ##  ``WindowShapeMode``
  ##
  ##  ``setWindowShape()``
