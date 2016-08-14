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

##  timer.nim
##  =========
##

proc getTicks*(): uint32 {.
    cdecl, importc: "SDL_GetTicks", dynlib: SDL2_LIB.}
  ##  Get the number of milliseconds since the SDL library initialization.
  ##
  ##  This value wraps if the program runs for more than ~49 days.

template ticksPassed*(a, b: untyped): bool = ##  \
  ##  Compare SDL ticks values, and return true if ``a`` has passed ``b``.
  ##
  ##  e.g. if you want to wait 100 ms, you could do this:
  ##
  ##  .. code-block:: nim
  ##    var timeout: uint32 = getTicks() + 100
  ##    while (not ticksPassed(getTicks(), timeout)):
  ##      do work until timeout has elapsed
  ((int32)((b) - (a)) <= 0)

proc getPerformanceCounter*(): uint64 {.
    cdecl, importc: "SDL_GetPerformanceCounter", dynlib: SDL2_LIB.}
  ##  Get the current value of the high resolution counter.

proc getPerformanceFrequency*(): uint64 {.
    cdecl, importc: "SDL_GetPerformanceFrequency", dynlib: SDL2_LIB.}
  ##  Get the count per second of the high resolution counter.

proc delay*(ms: uint32) {.
    cdecl, importc: "SDL_Delay", dynlib: SDL2_LIB.}
  ##  Wait a specified number of milliseconds before returning.

type
  TimerCallback* = proc (interval: uint32; param: pointer): uint32 {.
      cdecl.} ##  \
    ##  Procedure prototype for the timer callback procedure.
    ##
    ##  The callback procedure is passed the current timer interval and returns
    ##  the next timer interval.  If the returned value is the same as the one
    ##  passed in, the periodic alarm continues, otherwise a new alarm is
    ##  scheduled.  If the callback returns `0`, the periodic alarm is
    ##  cancelled.

  TimerID* = cint ## Definition of the timer ID type.

proc addTimer*(
    interval: uint32; callback: TimerCallback; param: pointer): TimerID {.
    cdecl, importc: "SDL_AddTimer", dynlib: SDL2_LIB.}
  ##  Add a new timer to the pool of timers already running.
  ##
  ##  ``Return`` a timer ID, or `0` when an error occurs.

proc removeTimer*(id: TimerID): bool {.cdecl, importc: "SDL_RemoveTimer", 
    dynlib: SDL2_LIB.}
  ##  Remove a timer knowing its ID.
  ##
  ##  ``Return`` a boolean value indicating success or failure.
  ##
  ##  ``Warning:`` It is not safe to remove a timer multiple times.
