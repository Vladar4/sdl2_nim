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

##  messagebox.nim
##  ==============
##

#type
#  MessageBoxFlags* {.size: sizeof(cint).} = enum ##  \
#    ##  If supported will display warning icon, etc.
#    MESSAGEBOX_ERROR = 0x00000010,      ##  error dialog
#    MESSAGEBOX_WARNING = 0x00000020,    ##  warning dialog
#    MESSAGEBOX_INFORMATION = 0x00000040 ##  informational dialog

# MessageBoxFlags
# If supported will display warning icon, etc.
const
  MESSAGEBOX_ERROR* = 0x00000010       ##  error dialog
  MESSAGEBOX_WARNING* = 0x00000020     ##  warning dialog
  MESSAGEBOX_INFORMATION* = 0x00000040 ##  informational dialog

#type
#  MessageBoxButtonFlags* {.size: sizeof(cint).} = enum ##  \
#    ##  Flags for ``MessageBoxButtonData``.
#    MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT = 0x00000001, ##  \
#      ##  Marks the default button when return is hit
#    MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT = 0x00000002  ##  \
#      ##  Marks the default button when escape is hit

# MessageBoxButtonFlags
# Flags for MessageBoxButtonData
const
  MESSAGEBOX_BUTTON_RETURNKEY_DEFAULT* = 0x00000001  ##  \
    ##  Marks the default button when return is hit
  MESSAGEBOX_BUTTON_ESCAPEKEY_DEFAULT* = 0x00000002  ##  \
    ##  Marks the default button when escape is hit

type
  MessageBoxButtonData* = object ##  \
    ##  Individual button data
    flags*: uint32          ##  ``MessageBoxButtonFlags``
    buttonid*: cint         ##  \
      ## User defined button id (value returned via ``showMessageBox()``)
    text*: cstring          ## The UTF-8 button text

type
  MessageBoxColor* = object ##  \
    ##  RGB value used in a message box color scheme
    r*: uint8
    g*: uint8
    b*: uint8

  MessageBoxColorType* {.size: sizeof(cint).} = enum
    MESSAGEBOX_COLOR_BACKGROUND,
    MESSAGEBOX_COLOR_TEXT,
    MESSAGEBOX_COLOR_BUTTON_BORDER,
    MESSAGEBOX_COLOR_BUTTON_BACKGROUND,
    MESSAGEBOX_COLOR_BUTTON_SELECTED,
    MESSAGEBOX_COLOR_MAX

type
  MessageBoxColorScheme* = object ##  \
    ##  A set of colors to use for message box dialogs
    colors*: array[MESSAGEBOX_COLOR_MAX, MessageBoxColor]

type
  MessageBoxData* = object ##  \
    ##  MessageBox object containing title, text, window, etc.
    flags*: uint32          ##  ``MessageBoxFlags``
    window*: Window         ##  ``Parent window, can be `nil`
    title*: cstring         ##  UTF-8 title
    message*: cstring       ##  UTF-8 message text
    numbuttons*: cint
    buttons*: ptr MessageBoxButtonData
    colorScheme*: ptr MessageBoxColorScheme ##  \
      ##  ``MessageBoxColorScheme``, can be `nil` to use system settings

proc showMessageBox*(
    messageboxdata: ptr MessageBoxData; buttonid: ptr cint): cint {.
      cdecl, importc: "SDL_ShowMessageBox", dynlib: SDL2_LIB.}
  ##  Create a modal message box.
  ##
  ##  ``messageboxdata`` The ``MessageBoxData`` object with title, text, etc.
  ##
  ##  ``buttonid`` The pointer to which user id of hit button should be copied.
  ##
  ##  ``Return`` `-1` on error, otherwise `0` and ``buttonid`` contains user id
  ##  of button hit or `-1` if dialog was closed.
  ##
  ##  ``Note:`` This procedure should be called on the thread that created
  ##  the parent window, or on the main thread if the messagebox has no parent.
  ##  It will block execution of that thread until the user clicks a button or
  ##  closes the messagebox.

proc showSimpleMessageBox*(
    flags: uint32; title: cstring; message: cstring; window: Window): cint {.
      cdecl, importc: "SDL_ShowSimpleMessageBox", dynlib: SDL2_LIB.}
  ##  Create a simple modal message box.
  ##
  ##  ``flags`` ``MessageBoxFlags``
  ##
  ##  ``title`` UTF-8 title text
  ##
  ##  ``message`` UTF-8 message text
  ##
  ##  ``window`` The parent window, or `nil` for no parent
  ##
  ##  ``Return`` `0` on success, `-1` on error
  ##
  ##  See also:
  ##
  ##  ``showMessageBox()``
