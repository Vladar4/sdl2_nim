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
# Include file for SDL mouse event handling.
#


type
  PCursor* = pointer ## Implementation dependent

  PSystemCursor* = ptr TSystemCursor
  TSystemCursor* = enum ## Cursor types for createSystemCursor.
    SYSTEM_CURSOR_ARROW, ## Arrow
    SYSTEM_CURSOR_IBEAM, ## I-beam
    SYSTEM_CURSOR_WAIT, ## Wait
    SYSTEM_CURSOR_CROSSHAIR, ## Crosshair
    SYSTEM_CURSOR_WAITARROW, ## Small wait cursor (or Wait if not available)
    SYSTEM_CURSOR_SIZENWSE, ## Double arrow pointing northwest and southeast
    SYSTEM_CURSOR_SIZENESW, ## Double arrow pointing northeast and southwest
    SYSTEM_CURSOR_SIZEWE, ## Double arrow pointing west and east
    SYSTEM_CURSOR_SIZENS, ## Double arrow pointing north and south
    SYSTEM_CURSOR_SIZEALL, ## Four pointed arrow pointing north, south, east, and west
    SYSTEM_CURSOR_NO, ## Slashed circle or crossbones
    SYSTEM_CURSOR_HAND, ## Hand
    NUM_SYSTEM_CURSORS


# Function prototypes


proc getMouseFocus*(): PWindow {.cdecl, importc: "SDL_GetMouseFocus", dynlib: LibName.}
  ## Get the window which currently has mouse focus.


proc getMouseState*(x, y: ptr int): Uint32 {.cdecl, importc: "SDL_GetMouseState", dynlib: LibName.}
  ## Retrieve the current state of the mouse.
  ##
  ## The current button state is returned as a button bitmask, which can
  ## be tested using the button(x) template, and x and y are set to the
  ## mouse cursor position relative to the focus window for the currently
  ## selected mouse.  You can pass nil for either x or y.


proc getRelativeMouseState*(x, y: ptr int): Uint32 {.cdecl, importc: "SDL_GetRelativeMouseState", dynlib: LibName.}
  ## Retrieve the relative state of the mouse.
  ##
  ## The current button state is returned as a button bitmask, which can
  ## be tested using the button(x) macros, and x and y are set to the
  ## mouse deltas since the last call to getRelativeMouseState().


proc warpMouseInWindow*(window: PWindow, x, y: int) {.cdecl, importc: "SDL_WarpMouseInWindow", dynlib: LibName.}
  ## Moves the mouse to the given position within the window.
  ##
  ## ``window`` The window to move the mouse into, or nil for the current mouse focus
  ##
  ## ``x`` The x coordinate within the window
  ##
  ## ``y`` The y coordinate within the window
  ##
  ## This function generates a mouse motion event


proc setRelativeMouseMode*(enabled: bool): int {.cdecl, importc: "SDL_SetRelativeMouseMode", dynlib: LibName.}
  ## Set relative mouse mode.
  ##
  ## ``enabled`` Whether or not to enable relative mode
  ##
  ## Return 0 on success, or -1 if relative mode is not supported.
  ##
  ## While the mouse is in relative mode, the cursor is hidden, and the
  ## driver will try to report continuous motion in the current window.
  ## Only relative motion events will be delivered, the mouse position
  ## will not change.
  ##
  ## This function will flush any pending mouse motion.
  ##
  ## See also: getRelativeMouseMode()


proc getRelativeMouseMode*(): bool {.cdecl, importc: "SDL_GetRelativeMouseMode", dynlib: LibName.}
  ## Query whether relative mouse mode is enabled.
  ##
  ## See also: setRelativeMouseMode()


proc createCursor*(data, mask: ptr byte,
  w, h, hot_x, hot_y: int): PCursor {.cdecl, importc: "SDL_CreateCursor", dynlib: LibName.}
  ## Create a cursor, using the specified bitmap data and mask (in MSB format).
  ##
  ## The cursor width must be a multiple of 8 bits.
  ##
  ## The cursor is created in black and white according to the following:
  ##
  ## ``| data | mask | resulting pixel on screen``
  ##
  ## ``| _0__ | _1__ | White``
  ##
  ## ``| _1__ | _1__ | Black``
  ##
  ## ``| _0__ | _0__ | Transparent``
  ##
  ## ``| _1__ | _0__ | Inverted color if possible, black if not.``
  ##
  ##
  ## See also: freeCursor()


proc createColorCursor*(surface: PSurface,
  hot_x, hot_y: int): PCursor {.cdecl, importc: "SDL_CreateColorCursor", dynlib: LibName.}
  ## Create a color cursor.
  ##
  ## See also: freeCursor()


proc createSystemCursor*(id: TSystemCursor): PCursor {.cdecl, importc: "SDL_CreateSysyemCursor", dynlib: LibName.}
  ## Create a system cursor.
  ##
  ## See also: freeCursor()


proc setCursor*(cursor: PCursor) {.cdecl, importc: "SDL_SetCursor", dynlib: LibName.}
  ## Set the active cursor.


proc getCursor*(): PCursor {.cdecl, importc: "SDL_GetCursor", dynlib: LibName.}
  ## Return the active cursor.


proc getDefaultCursor*(): PCursor {.cdecl, importc: "SDL_GetDefaultCursor", dynlib: LibName.}
  ## Return the default cursor.


proc freeCursor*(cursor: PCursor) {.cdecl, importc: "SDL_FreeCursor", dynlib: LibName.}
  ## Frees a cursor created with createCursor().
  ##
  ## See also: createCursor()


proc showCursor*(toggle: int): int {.cdecl, importc: "SDL_ShowCursor", dynlib: LibName.}
  ## Toggle whether or not the cursor is shown.
  ##
  ## ``toggle`` 1 to show the cursor, 0 to hide it, -1 to query
  ## the current state.
  ##
  ## Return 1 if the cursor is shown, or 0 if the cursor is hidden.


template button*(x: expr): expr =
  ## Used as a mask when testing buttons in buttonstate.
  ##
  ## * Button 1:  Left mouse button
  ##
  ## * Button 2:  Middle mouse button
  ##
  ## * Button 3:  Right mouse button
  (1 shl ((x)-1))


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

