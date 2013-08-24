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
# Include file for SDL keyboard event handling
#


type
  TKeysym*{.bycopy.} = object
    ## The SDL keysym structure, used in key events.
    scancode*: TScancode ## SDL physical key code - see TScancode for details
    sym*: TKeycode ## SDL virtual key code - see TKeycode for details
    modifier*: Uint16 ## current key modifiers
    unicode*: Uint32 ## deprecated use TTextInputEvent instead


# Function prototypes


proc getKeyboardFocus*(void): PWindow {.cdecl, importc: "SDL_GetKeyboardFocus", dynlib: LibName.}
  ## Get the window which currently has keyboard focus.


proc getKeyboardState*(numkeys: ptr int): ptr Uint8 {.cdecl, importc: "SDL_GetKeyboardState", dynlib: LibName.}
  ## Get a snapshot of the current state of the keyboard.
  ##
  ## ``numkeys`` if non-nil, receives the length of the returned array.
  ##
  ## Return an array of key states.
  ## Indexes into this array are obtained by using TScancode values.
  ##
  ## Example:
  ##
  ##
  ## var state: ptr Uint8 = getKeyboardState(nil)
  ## if state[SCANCODE_RETURN]:
  ##   echo("<RETURN> is pressed.")


proc getModState*(): TKeymod {.cdecl, importc: "SDL_GetModState", dynlib: LibName.}
  ## Get the current key modifier state for the keyboard.


proc setModState*(modstate: TKeymod) {.cdecl, importc: "SDL_SetModState", dynlib: LibName.}
  ## Set the current key modifier state for the keyboard.
  ##
  ## This does not change the keyboard state, only the key modifier flags.


proc getKeyFromScancode*(scancode: TScancode): TKeycode {.cdecl, importc: "SDL_GetKeyFromScancode", dynlib: LibName.}
  ## Get the key code corresponding to the given scancode according
  ## to the current keyboard layout.
  ##
  ## See TKeycode for details.
  ##
  ## See also: getKeyName()


proc getScancodeFromKey*(key: TKeycode): TScancode {.cdecl, importc: "SDL_GetScancodeFromKey", dynlib: LibName.}
  ## Get the scancode corresponding to the given key code according to the
  ## current keyboard layout.
  ##
  ## See TScancode for details.
  ##
  ## See also: getScancodeName()


proc getScancodeName*(scancode: TScancode): cstring {.cdecl, importc: "SDL_GetScancodeName", dynlib: LibName.}
  ## Get a human-readable name for a scancode.
  ##
  ## Return a pointer to the name for the scancode.
  ## If the scancode doesn't have a name, this function returns
  ## an empty string ("").
  ##
  ## See also: TScancode


proc getScancodeFromName*(name: cstring): TScancode {.cdecl, importc: "SDL_GetScancodeFromName", dynlib: LibName.}
  ## Get a scancode from a human-readable name
  ##
  ## Return scancode, or SCANCODE_UNKNOWN if the name wasn't recognized
  ##
  ## See also: TScancode


proc getKeyName*(key: TKeycode): cstring {.cdecl, importc: "SDL_GetKeyName", dynlib: LibName.}
  ## Get a human-readable name for a key.
  ##
  ## Return A pointer to a UTF-8 string that stays valid at least until the
  ## next call to this function. If you need it around any longer, you must
  ## copy it.  If the key doesn't have a name, this function returns an
  ## empty string ("").
  ##
  ## See also: TKey


proc getKeyFromName*(name: cstring): TKeycode {.cdecl, importc: "SDL_GetKeyFromName", dynlib: LibName.}
  ## Get a key code from a human-readable name
  ##
  ## Return key code, or K_UNKNOWN if the name wasn't recognized
  ##
  ## See also: TKeycode


proc startTextInput*() {.cdecl, importc: "SDL_StartTextInput", dynlib: LibName.}
  ## Start accepting Unicode text input events.
  ## This function will show the on-screen keyboard if supported.
  ##
  ## See also: stopTextInput(), 
  ## setTextInputRect(), 
  ## hasScreenKeyboardSupport()


proc isTextInputActive*(): bool {.cdecl, importc: "SDL_IsTextInputActive", dynlib: LibName.}
  ## Return whether or not Unicode text input events are enabled.
  ##
  ## See also: startTextInput(), 
  ## stopTextInput()


proc stopTextInput*() {.cdecl, importc: "SDL_StopTextInput", dynlib: LibName.}
  ## Stop receiving any text input events.
  ## This function will hide the on-screen keyboard if supported.
  ##
  ## See also: startTextInput(), 
  ## hasScreenKeyboardSupport()


proc setTextInputRect*(rect: PRect) {.cdecl, importc: "SDL_SetTextInputRect", dynlib: LibName.}
  ## Set the rectangle used to type Unicode text inputs.
  ## This is used as a hint for IME and on-screen keyboard placement.
  ##
  ## See also: startTextInput()


proc hasScreenKeyboardSupport*(): bool {.cdecl, importc: "SDL_HasScreenKeyboardSupport", dynlib: LibName.}
  ## Returns whether the platform has some screen keyboard support.
  ##
  ## Return TRUE if some keyboard support is available else FALSE.
  ##
  ## Not all screen keyboard functions are supported on all platforms.
  ##
  ## See also: isScreenKeyboardShown()

proc isScreenKeyboardShown*(window: PWindow): bool {.cdecl, importc: "SDL_IsScreenKeyboardShown", dynlib: LibName.}
  ## Returns whether the screen keyboard is shown for given window.
  ##
  ## ``window`` The window for which screen keyboard should be queried.
  ##
  ## Return TRUE if screen keyboard is shown else FALSE.
  ##
  ## See also: hasScreenKeyboardSupport()

