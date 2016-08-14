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

##  mutex.nim
##  =========
##

const
  MUTEX_TIMEDOUT* = 1 ##  \
    ##  Synchronization procedures which can time out return this value
    ##  if they time out.

const
  MUTEX_MAXWAIT* = (not uint32(0))
    ##  This is the timeout value which corresponds to never time out.

# Mutex procedures

type
  Mutex* = pointer  ##  The SDL mutex structure, defined in SDL_sysmutex.c

proc createMutex*(): Mutex {.
    cdecl, importc: "SDL_CreateMutex", dynlib: SDL2_LIB.}
  ##  Create a mutex, initialized unlocked.

template mutexP*(m: untyped): untyped =
  lockMutex(m)

proc lockMutex*(mutex: Mutex): cint {.
    cdecl, importc: "SDL_LockMutex", dynlib: SDL2_LIB.}
  ##  Lock the mutex.
  ##
  ##  ``Return`` `0`, or `-1` on error.

proc tryLockMutex*(mutex: Mutex): cint {.
    cdecl, importc: "SDL_TryLockMutex", dynlib: SDL2_LIB.}
  ##  Try to lock the mutex
  ##
  ##  ``Return`` `0`, `MUTEX_TIMEDOUT`, or `-1` on error.

template mutexV*(m: untyped): untyped =
  unlockMutex(m)

proc unlockMutex*(mutex: Mutex): cint {.
    cdecl, importc: "SDL_UnlockMutex", dynlib: SDL2_LIB.}
  ##  Unlock the mutex.
  ##
  ##  ``Return`` `0`, or `-1` on error.
  ##
  ##  ``Warning:`` It is an error to unlock a mutex that has not been locked
  ##  by the current thread, and doing so results in undefined behavior.

proc destroyMutex*(mutex: Mutex) {.
    cdecl, importc: "SDL_DestroyMutex", dynlib: SDL2_LIB.}
  ##  Destroy a mutex.

# Semaphore procedures

type
  Semaphore* = pointer ##  The SDL semaphore structure, defined in SDL_syssem.c

type
  Sem* = Semaphore

proc createSemaphore*(initial_value: uint32): Sem {.
    cdecl, importc: "SDL_CreateSemaphore", dynlib: SDL2_LIB.}
  ##  Create a semaphore, initialized with value, returns `nil` on failure.

proc destroySemaphore*(sem: Sem) {.
    cdecl, importc: "SDL_DestroySemaphore", dynlib: SDL2_LIB.}
  ##  Destroy a semaphore.

proc semWait*(sem: Sem): cint {.
    cdecl, importc: "SDL_SemWait", dynlib: SDL2_LIB.}
  ##  This procedure suspends the calling thread until the semaphore pointed
  ##  to by ``sem`` has a positive count. It then atomically decreases the
  ##  semaphore count.

proc semTryWait*(sem: Sem): cint {.
    cdecl, importc: "SDL_SemTryWait", dynlib: SDL2_LIB.}
  ##  Non-blocking variant of ``semWait()``.
  ##
  ##  ``Return`` `0` if the wait succeeds,
  ##  `MUTEX_TIMEDOUT` if the wait would block, and `-1` on error.

proc semWaitTimeout*(sem: Sem; ms: uint32): cint {.
    cdecl, importc: "SDL_SemWaitTimeout", dynlib: SDL2_LIB.}
  ##  Variant of ``semWait()`` with a timeout in milliseconds.
  ##
  ##  ``Return`` `0` if the wait succeeds,
  ##  `MUTEX_TIMEDOUT` if the wait does not succeed in the allotted time,
  ##  and `-1` on error.
  ##
  ##  ``Warning:`` On some platforms this procedure is implemented by looping
  ##  with a delay of 1 ms, and so should be avoided if possible.

proc semPost*(sem: Sem): cint {.
    cdecl, importc: "SDL_SemPost", dynlib: SDL2_LIB.}
  ##  Atomically increases the semaphore's count (not blocking).
  ##
  ##  ``Return`` `0`, or `-1` on error.

proc semValue*(sem: Sem): uint32 {.
    cdecl, importc: "SDL_SemValue", dynlib: SDL2_LIB.}
  ##  Returns the current count of the semaphore.

type
  Cond* = pointer ##  \
    ## The SDL condition variable structure, defined in SDL_syscond.c

proc createCond*(): Cond {.
    cdecl, importc: "SDL_CreateCond", dynlib: SDL2_LIB.}
  ##  Create a condition variable.
  ##
  ##  Typical use of condition variables:
  ##
  ##  Thread A:
  ##
  ##  .. code-block::nim
  ##    lockMutex(lock)
  ##
  ##    while (not condition):
  ##
  ##      condWait(cond, lock)
  ##
  ##    unlockMutex(lock)
  ##
  ##  Thread B:
  ##
  ##  .. code-block:: nim
  ##    lockMutex(lock)
  ##    ...
  ##    condition = true
  ##    ...
  ##    condSignal(cond)
  ##    unlockMutex(lock)
  ##
  ##  There is some discussion whether to signal the condition variable
  ##  with the mutex locked or not. There is some potential performance
  ##  benefit to unlocking first on some platforms, but there are some
  ##  potential race conditions depending on how your code is structured.
  ##
  ##  In general it's safer to signal the condition variable while the
  ##  mutex is locked.

proc destroyCond*(cond: Cond) {.
    cdecl, importc: "SDL_DestroyCond", dynlib: SDL2_LIB.}
  ##  Destroy a condition variable.

proc condSignal*(cond: Cond): cint {.
    cdecl, importc: "SDL_CondSignal", dynlib: SDL2_LIB.}
  ##  Restart one of the threads that are waiting on the condition variable.
  ##
  ##  ``Return`` `0` or `-1` on error.

proc condBroadcast*(cond: Cond): cint {.
    cdecl, importc: "SDL_CondBroadcast", dynlib: SDL2_LIB.}
  ##  Restart all threads that are waiting on the condition variable.
  ##
  ##  ``Return`` `0` or `-1` on error.

proc condWait*(cond: Cond; mutex: Mutex): cint {.
    cdecl, importc: "SDL_CondWait", dynlib: SDL2_LIB.}
  ##  Wait on the condition variable, unlocking the provided mutex.
  ##
  ##  ``Warning:`` The mutex must be locked before entering this procedure!
  ##
  ##  The mutex is re-locked once the condition variable is signaled.
  ##
  ##  ``Return`` `0` when it is signaled, or `-1` on error.

proc condWaitTimeout*(cond: Cond; mutex: Mutex; ms: uint32): cint {.
    cdecl, importc: "SDL_CondWaitTimeout", dynlib: SDL2_LIB.}
  ##  Waits for at most ``ms`` milliseconds, and returns `0` if the condition
  ##  variable is signaled, `MUTEX_TIMEDOUT` if the condition is not signaled
  ##  in the allotted time, and `-1` on error.
  ##
  ##  ``Warning:`` On some platforms this procedure is implemented by looping
  ##  with a delay of 1 ms, and so should be avoided if possible.
