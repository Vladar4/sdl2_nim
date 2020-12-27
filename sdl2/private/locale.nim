#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>
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

##   locale.nim
##   ==========
##
##   Include file for SDL locale services

type
  Locale* = ptr LocaleObj
  LocaleObj* = object
    language*: cstring  ##  A language name, like "en" for English.
    country*: cstring   ##  A country, like "US" for America. Can be `nil`.

proc getPreferredLocales*(): Locale {.
    cdecl, importc: "SDL_GetPreferredLocales", dynlib: SDL2_LIB.}
  ##  Report the user's preferred locale.
  ##
  ##  This returns an array of ``sdl.Locale`` objects, the final item zeroed out.
  ##  When the caller is done with this array, it should call ``sdl.free()`` on
  ##  the returned value; all the memory involved is allocated in a single
  ##  block, so a single ``sdl.free()`` will suffice.
  ##
  ##  Returned language strings are in the format xx, where 'xx' is an ISO-639
  ##  language specifier (such as "en" for English, "de" for German, etc).
  ##  Country strings are in the format YY, where "YY" is an ISO-3166 country
  ##  code (such as "US" for the United States, "CA" for Canada, etc). Country
  ##  might be `nil` if there's no specific guidance on them (so you might get
  ##  { "en", "US" } for American English, but { "en", `nil` } means "English
  ##  language, generically"). Language strings are never `nil`, except to
  ##  terminate the array.
  ##
  ##  Please note that not all of these strings are 2 characters; some are
  ##  three or more.
  ##
  ##  The returned list of locales are in the order of the user's preference.
  ##  For example, a German citizen that is fluent in US English and knows
  ##  enough Japanese to navigate around Tokyo might have a list like:
  ##  { "de", "en_US", "jp", `nil` }. Someone from England might prefer British
  ##  English (where "color" is spelled "colour", etc), but will settle for
  ##  anything like it: { "en_GB", "en", `nil` }.
  ##
  ##  This procedure returns `nil` on error, including when the platform does not
  ##  supply this information at all.
  ##
  ##  This might be a "slow" call that has to query the operating system. It's
  ##  best to ask for this once and save the results. However, this list can
  ##  change, usually because the user has changed a system preference outside
  ##  of your program; SDL will send an `sdl.LOCALECHANGED` event in this case,
  ##  if possible, and you can call this procedure again to get an updated copy
  ##  of preferred locales.
  ##
  ##  ``Return`` array of locales, terminated with a locale with a `nil` language
  ##  field. Will return `nil` on error.

