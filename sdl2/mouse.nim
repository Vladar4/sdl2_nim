#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2014 Sam Lantinga <slouken@libsdl.org>
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

##  mouse.nim
##
##  Include file for SDL mouse event handling.

type
  Cursor* = pointer ##  Implementation dependent

  SystemCursor* {.size: sizeof(cint).} = enum ##  \
    ##  Cursor types for ``createSystemCursor()``.
    SYSTEM_CURSOR_ARROW,      ##  Arrow
    SYSTEM_CURSOR_IBEAM,      ##  I-beam
    SYSTEM_CURSOR_WAIT,       ##  Wait
    SYSTEM_CURSOR_CROSSHAIR,  ##  Crosshair
    SYSTEM_CURSOR_WAITARROW,  ##  Small wait cursor (or Wait if not available)
    SYSTEM_CURSOR_SIZENWSE,   ##  Double arrow pointing northwest and southeast
    SYSTEM_CURSOR_SIZENESW,   ##  Double arrow pointing northeast and southwest
    SYSTEM_CURSOR_SIZEWE,     ##  Double arrow pointing west and east
    SYSTEM_CURSOR_SIZENS,     ##  Double arrow pointing north and south
    SYSTEM_CURSOR_SIZEALL,    ##  \
      ##  Four pointed arrow pointing north, south, east, and west
    SYSTEM_CURSOR_NO,         ##  Slashed circle or crossbones
    SYSTEM_CURSOR_HAND,       ##  Hand
    NUM_SYSTEM_CURSORS

# Function prototypes

proc getMouseFocus*(): ptr Window {.
    cdecl, importc: "SDL_GetMouseFocus", dynlib: SDL2_LIB.}
  ##  Get the window which currently has mouse focus.

proc getMouseState*(x: ptr cint; y: ptr cint): uint32 {.
    cdecl, importc: "SDL_GetMouseState", dynlib: SDL2_LIB.}
  ##  Retrieve the current state of the mouse.
  ##
  ##  The current button state is returned as a button bitmask, which can
  ##  be tested using the ``button()`` template, and x and y are set to the
  ##  mouse cursor position relative to the focus window for the currently
  ##  selected mouse.  You can pass `nil` for either x or y.

proc getRelativeMouseState*(x: ptr cint; y: ptr cint): uint32 {.
    cdecl, importc: "SDL_GetRelativeMouseState", dynlib: SDL2_LIB.}
  ##  Retrieve the relative state of the mouse.
  ##
  ##  The current button state is returned as a button bitmask, which can
  ##  be tested using the ``button()`` template, and x and y are set to the
  ##  mouse deltas since the last call to ``getRelativeMouseState()``.

proc warpMouseInWindow*(window: ptr Window; x: cint; y: cint) {.
    cdecl, importc: "SDL_WarpMouseInWindow", dynlib: SDL2_LIB.}
  ##  Moves the mouse to the given position within the window.
  ##
  ##  ``window`` The window to move the mouse into,
  ##  or `nil` for the current mouse focus
  ##
  ##  ``x`` The x coordinate within the window
  ##
  ##  ``y`` The y coordinate within the window
  ##
  ##  ``Note:`` This function generates a mouse motion event

proc setRelativeMouseMode*(enabled: bool): cint {.
    cdecl, importc: "SDL_SetRelativeMouseMode", dynlib: SDL2_LIB.}
  ##  Set relative mouse mode.
  ##
  ##  ``enabled`` Whether or not to enable relative mode
  ##
  ##  ``Return`` `0` on success, or `-1` if relative mode is not supported.
  ##
  ##  While the mouse is in relative mode, the cursor is hidden, and the
  ##  driver will try to report continuous motion in the current window.
  ##  Only relative motion events will be delivered, the mouse position
  ##  will not change.
  ##
  ##  ``Note:`` This function will flush any pending mouse motion.
  ##
  ##  See also:
  ##
  ##  ``getRelativeMouseMode()``

proc getRelativeMouseMode*(): bool {.
    cdecl, importc: "SDL_GetRelativeMouseMode", dynlib: SDL2_LIB.}
  ##  Query whether relative mouse mode is enabled.
  ##
  ##  See also:
  ##
  ##  ``setRelativeMouseMode()``

proc createCursor*(
    data: ptr uint8; mask: ptr uint8;
    w: cint; h: cint; hot_x: cint; hot_y: cint): Cursor {.
      cdecl, importc: "SDL_CreateCursor", dynlib: SDL2_LIB.}
  ##  Create a cursor, using the specified bitmap data and mask (in MSB format).
  ##
  ##  The cursor width must be a multiple of 8 bits.
  ##
  ##  The cursor is created in black and white according to the following:
  ##
  ##    ====  ====  ========================================
  ##    data  mask  resulting pixel on screen
  ##    ====  ====  ========================================
  ##    0     1     White
  ##    1     1     Black
  ##    0     0     Transparent
  ##    1     0     Inverted color if possible, black if not.
  ##    ====  ====  =========================================
  ##
  ##  See also:
  ##
  ##  ``freeCursor()``

proc createColorCursor*(
    surface: ptr Surface; hot_x: cint; hot_y: cint): Cursor {.
      cdecl, importc: "SDL_CreateColorCursor", dynlib: SDL2_LIB.}
  ##  Create a color cursor.
  ##
  ##  See also:
  ##
  ##  ``freeCursor()``

proc createSystemCursor*(id: SystemCursor): Cursor {.
    cdecl, importc: "SDL_CreateSystemCursor", dynlib: SDL2_LIB.}
  ##  Create a system cursor.
  ##
  ##  See also:
  ##
  ##  ``freeCursor()``

proc setCursor*(cursor: Cursor) {.
    cdecl, importc: "SDL_SetCursor", dynlib: SDL2_LIB.}
  ##  Set the active cursor.

proc getCursor*(): Cursor {.
    cdecl, importc: "SDL_GetCursor", dynlib: SDL2_LIB.}
  ##  Return the active cursor.

proc getDefaultCursor*(): Cursor {.
    cdecl, importc: "SDL_GetDefaultCursor", dynlib: SDL2_LIB.}
  ##  Return the default cursor.

proc freeCursor*(cursor: Cursor) {.
    cdecl, importc: "SDL_FreeCursor", dynlib: SDL2_LIB.}
  ##  Frees a cursor created with ``createCursor()``.
  ##
  ##  See also:
  ##
  ##  ``createCursor()``

proc showCursor*(toggle: cint): cint {.
  cdecl, importc: "SDL_ShowCursor", dynlib: SDL2_LIB.}
  ##  Toggle whether or not the cursor is shown.
  ##
  ##  ``toggle`` `1` to show the cursor, `0` to hide it,
  ##  `-1` to query the current state.
  ##
  ##  ``Return`` `1` if the cursor is shown, or `0` if the cursor is hidden.

template button*(x: expr): expr = ##  \
  ##  Used as a mask when testing buttons in buttonstate.
  ##
  ##  * Button 1:  Left mouse button
  ##  * Button 2:  Middle mouse button
  ##  * Button 3:  Right mouse button
  (1 shl ((x) - 1))

const
  BUTTON_LEFT* = 1
  BUTTON_MIDDLE* = 2
  BUTTON_RIGHT* = 3
  BUTTON_X1* = 4
  BUTTON_X2* = 5
  BUTTON_LMASK* = button(BUTTON_LEFT)
  BUTTON_MMASK* = button(BUTTON_MIDDLE)
  BUTTON_RMASK* = button(BUTTON_RIGHT)
  BUTTON_X1MASK* = button(BUTTON_X1)
  BUTTON_X2MASK* = button(BUTTON_X2)
