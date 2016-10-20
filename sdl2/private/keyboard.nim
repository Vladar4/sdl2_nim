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

##  keyboard.nim
##  ============
##
##  Include file for SDL keyboard event handling.

type
  Keysym* = object ##  \
    ##  The SDL keysym object, used in key events.
    ##
    ##  ``Note:`` If you are looking for translated character input,
    ##  see the TEXTINPUT event.
    scancode*: Scancode ## SDL physical key code - see ``Scancode`` for details
    sym*: Keycode       ## SDL virtual key code - see ``Keycode`` for details
    mods*: uint16        ## current key modifiers
    unused*: uint32

# Procedures

proc getKeyboardFocus*(): ptr Window {.
    cdecl, importc: "SDL_GetKeyboardFocus", dynlib: SDL2_LIB.}
  ##  Get the window which currently has keyboard focus.

proc getKeyboardState*(numkeys: ptr cint): ptr array[NUM_SCANCODES.int, uint8] {.
    cdecl, importc: "SDL_GetKeyboardState", dynlib: SDL2_LIB.}
  ##  Get a snapshot of the current state of the keyboard.
  ##
  ##  ``numkeys`` if non-`nil`, receives the length of the returned array.
  ##
  ##  ``Return`` an array of key states. Indexes into this array are obtained
  ##  by using ``Scancode`` values.
  ##
  ##  Example:
  ##
  ##  .. code-block:: nim
  ##    let state = getKeyboardState(nil)
  ##    if state[SCANCODE_RETURN] > 0:
  ##      echo "<RETURN> is pressed."

template `[]`*[Idx, T](a: array[Idx, T], x: Scancode): T = a[x.int]

proc getModState*(): Keymod {.
    cdecl, importc: "SDL_GetModState", dynlib: SDL2_LIB.}
  ##  Get the current key modifier state for the keyboard.

proc setModState*(modstate: Keymod) {.
    cdecl, importc: "SDL_SetModState", dynlib: SDL2_LIB.}
  ##  Set the current key modifier state for the keyboard.
  ##
  ##  ``Note:`` This does not change the keyboard state,
  ##  only the key modifier flags.

proc getKeyFromScancode*(scancode: Scancode): Keycode {.
    cdecl, importc: "SDL_GetKeyFromScancode", dynlib: SDL2_LIB.}
  ##  Get the key code corresponding to the given scancode according
  ##  to the current keyboard layout.
  ##
  ##  See ``Keycode`` for details.
  ##
  ##  See also:
  ##
  ##  ``getKeyName()``

proc getScancodeFromKey*(key: Keycode): Scancode {.
    cdecl, importc: "SDL_GetScancodeFromKey", dynlib: SDL2_LIB.}
  ##  Get the scancode corresponding to the given key code
  ##  according to the current keyboard layout.
  ##
  ##  See ``Scancode`` for details.
  ##
  ##  See also:
  ##
  ##  ``getScancodeName()``

proc getScancodeName*(scancode: Scancode): cstring {.
    cdecl, importc: "SDL_GetScancodeName", dynlib: SDL2_LIB.}
  ##  Get a human-readable name for a scancode.
  ##
  ##  ``Return`` a pointer to the name for the scancode.
  ##  If the scancode doesn't have a name, this procedure
  ##  returns an empty string ("").
  ##
  ##  See also:
  ##
  ##  ``Scancode``

proc getScancodeFromName*(name: cstring): Scancode {.
    cdecl, importc: "SDL_GetScancodeFromName", dynlib: SDL2_LIB.}
  ##  Get a scancode from a human-readable name.
  ##
  ##  ``Return`` scancode, or `SCANCODE_UNKNOWN` if the name wasn't recognized.
  ##
  ##  See also:
  ##
  ##  ``Scancode``

proc getKeyName*(key: Keycode): cstring {.
    cdecl, importc: "SDL_GetKeyName", dynlib: SDL2_LIB.}
  ##  Get a human-readable name for a key.
  ##
  ##  ``Return`` a pointer to a UTF-8 string that stays valid at least until
  ##  the next call to this procedure. If you need it around any longer,
  ##  you must copy it. If the key doesn't have a name, this procedure returns
  ##  an empty string ("").
  ##
  ##  See also:
  ##
  ##  ``Keycode``

proc getKeyFromName*(name: cstring): Keycode {.
    cdecl, importc: "SDL_GetKeyFromName", dynlib: SDL2_LIB.}
  ##  Get a key code from a human-readable name.
  ##
  ##  ``Return`` key code, or `K_UNKNOWN` if the name wasn't recognized.
  ##
  ##  See also:
  ##
  ##  ``Keycode``

proc startTextInput*() {.
    cdecl, importc: "SDL_StartTextInput", dynlib: SDL2_LIB.}
  ##  Start accepting Unicode text input events.
  ##
  ##  This procedure will show the on-screen keyboard if supported.
  ##
  ##  See also:
  ##
  ##  ``stopTextInput()``
  ##
  ##  ``setTextInputRect()``
  ##
  ##  ``hasScreenKeyboardSupport()``

proc isTextInputActive*(): bool {.
    cdecl, importc: "SDL_IsTextInputActive", dynlib: SDL2_LIB.}
  ##  Return whether or not Unicode text input events are enabled.
  ##
  ##  See also:
  ##
  ##  ``startTextInput()``
  ##
  ##  ``stopTextInput()``

proc stopTextInput*() {.
    cdecl, importc: "SDL_StopTextInput", dynlib: SDL2_LIB.}
  ##  Stop receiving any text input events.
  ##
  ##  This procedure will hide the on-screen keyboard if supported.
  ##
  ##  See also:
  ##
  ##  ``startTextInput()``
  ##
  ##  ``hasScreenKeyboardSupport()``

proc setTextInputRect*(rect: ptr Rect) {.
    cdecl, importc: "SDL_SetTextInputRect", dynlib: SDL2_LIB.}
  ##  Set the rectangle used to type Unicode text inputs.
  ##
  ##  This is used as a hint for IME and on-screen keyboard placement.
  ##
  ##  See also:
  ##
  ##  ``startTextInput()``

proc hasScreenKeyboardSupport*(): bool {.
    cdecl, importc: "SDL_HasScreenKeyboardSupport", dynlib: SDL2_LIB.}
  ##  Returns whether the platform has some screen keyboard support.
  ##
  ##  ``Return`` `true` if some keyboard support is available else `false`.
  ##
  ##  ``Note:`` Not all screen keyboard procedures are supported
  ##  on all platforms.
  ##
  ##  See also:
  ##
  ##  ``isScreenKeyboardShown()``

proc isScreenKeyboardShown*(window: ptr Window): bool {.
    cdecl, importc: "SDL_IsScreenKeyboardShown", dynlib: SDL2_LIB.}
  ##  Returns whether the screen keyboard is shown for given window.
  ##
  ##  ``window`` The window for which screen keyboard should be queried.
  ##
  ##  ``Return`` `true` if screen keyboard is shown else `false`.
  ##
  ##  See also:
  ##
  ##  ``hasScreenKeyboardSupport()``
