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

##  clipboard.nim
##  =============
##
##  Include file for SDL clipboard handling.

# Procedures

proc setClipboardText*(text: cstring): cint {.
    cdecl, importc: "SDL_SetClipboardText", dynlib: SDL2_LIB.}
  ##  Put UTF-8 text into the clipboard.
  ##
  ##  See also:
  ##
  ##  ``getClipboardText()``

proc getClipboardText*(): cstring {.
    cdecl, importc: "SDL_GetClipboardText", dynlib: SDL2_LIB.}
  ##  Get UTF-8 text from the clipboard, which must be freed with ``free()``.
  ##
  ##  See also:
  ##
  ##  ``setClipboardText()``

proc hasClipboardText*(): bool {.
    cdecl, importc: "SDL_HasClipboardText", dynlib: SDL2_LIB.}
  ##  Returns a flag indicating whether the clipboard exists and contains
  ##  a text string that is non-empty.
  ##
  ##  ``getClipboardText()``
