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
# Header for the SDL time management routines.
#


proc getTicks*(): Uint32 {.cdecl, importc: "SDL_GetTicks", dynlib: LibName.}
  ## Get the number of milliseconds since the SDL library initialization.
  ##
  ## This value wraps if the program runs for more than ~49 days.


proc getPerformanceCounter*(): Uint64 {.cdecl, importc: "SDL_GetPerformanceCounter", dynlib: LibName.}
  ## Get the current value of the high resolution counter


proc getPerformanceFrequency*(): Uint64 {.cdecl, importc: "SDL_GetPerformanceFrequency", dynlib: LibName.}
  ## Get the count per second of the high resolution counter

proc delay*(ms: Uint32) {.cdecl, importc: "SDL_Delay", dynlib: LibName.}
  ## Wait a specified number of milliseconds before returning.

type
  PTimerCallback* = proc(interval: Uint32, param: pointer): Uint32 {.cdecl.}
    ## Function prototype for the timer callback function.
    ##
    ## The callback function is passed the current timer interval and returns
    ## the next timer interval.  If the returned value is the same as the one
    ## passed in, the periodic alarm continues, otherwise a new alarm is
    ## scheduled.  If the callback returns 0, the periodic alarm is cancelled.
  TTimerID* = int ## Definition of the timer ID type.

proc addTimer*(interval: Uint32,
    callback: PTimerCallback, param: pointer): TTimerID {.cdecl, importc: "SDL_AddTimer", dynlib: LibName.}
  ## Add a new timer to the pool of timers already running.
  ##
  ## Return A timer ID, or nil when an error occurs.


proc removeTimer*(id: TTimerID): bool {.cdecl, importc: "SDL_RemoveTimer", dynlib: LibName.}
  ## Remove a timer knowing its ID.
  ##
  ## Return A boolean value indicating success or failure.
  ##
  ## Warning: It is not safe to remove a timer multiple times.

