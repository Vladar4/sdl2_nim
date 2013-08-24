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
# Header for the SDL thread management routines.
#


type

  PThread* = pointer ## The SDL thread structure, defined in SDL_thread.c


  TThreadID* = clong ## The SDL thread ID


  TThreadPriority* = enum ## The SDL thread priority. Note: On many systems you require special privileges to set high priority.
    THREAD_PRIORITY_LOW,
    THREAD_PRIORITY_NORMAL,
    THREAD_PRIORITY_HIGH


  PThreadFunction* = proc(data: pointer): int {.cdecl.}
    ## The function passed to createThread()
    ## It is passed a ``pointer`` user context parameter and returns an int.


proc createThread*(fn: PThreadFunction, name: cstring, data: pointer): PThread {.cdecl, importc: "SDL_CreateThread", dynlib: LibName.}
  ## Create a thread.
  ##
  ## Thread naming is a little complicated: Most systems have very small
  ## limits for the string length (BeOS has 32 bytes, Linux currently has 16,
  ## Visual C++ 6.0 has nine!), and possibly other arbitrary rules. You'll
  ## have to see what happens with your system's debugger. The name should be
  ## UTF-8 (but using the naming limits of C identifiers is a better bet).
  ## There are no requirements for thread naming conventions, so long as the
  ## string is null-terminated UTF-8, but these guidelines are helpful in
  ## choosing a name:
  ##
  ## http://stackoverflow.com/questions/149932/naming-conventions-for-threads
  ##
  ## If a system imposes requirements, SDL will try to munge the string for
  ## it (truncate, etc), but the original string contents will be available
  ## from getThreadName().


proc getThreadName*(thread: PThread): cstring {.cdecl, importc: "SDL_GetThreadName", dynlib: LibName.}
  ## Get the thread name, as it was specified in createThread().
  ## This function returns a pointer to a UTF-8 string that names the
  ## specified thread, or nil if it doesn't have a name. This is internal
  ## memory, not to be free()'d by the caller, and remains valid until the
  ## specified thread is cleaned up by waitThread().


proc threadID*(): TThreadID {.cdecl, importc: "SDL_ThreadID", dynlib: LibName.}
  ## Get the thread identifier for the current thread.


proc getThreadID*(thread: PThread): TThreadID {.cdecl, importc: "SDL_GetThreadID", dynlib: LibName.}
  ## Get the thread identifier for the specified thread.
  ##
  ## Equivalent to threadID() if the specified thread is nil.


proc setThreadPriority*(priority: TThreadPriority): int {.cdecl, importc: "SDL_SetThreadPriority", dynlib: LibName.}
  ## Set the priority for the current thread


proc waitThread*(thread: PThread, status: ptr int) {.cdecl, importc: "SDL_WaitThread", dynlib: LibName.}
  ## Wait for a thread to finish.
  ##
  ## The return code for the thread function is placed in the area
  ## pointed to by ``status``, if ``status`` is not nil.

