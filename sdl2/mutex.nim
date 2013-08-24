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
# Functions to provide thread synchronization primitives.
#


const

  MUTEX_TIMEDOUT* = 1 ## Synchronization functions which can time out return this value if they time out.

  MUTEX_MAXWAIT*: Uint32 = 0 ## This is the timeout value which corresponds to never time out. (~(Uint32)0)


# Mutex functions

type
  PMutex* = pointer ## The SDL mutex structure, defined in SDL_mutex.c


proc createMutex*(): PMutex {.cdecl, importc: "SDL_CreateMutex", dynlib: LibName.}
  ## Create a mutex, initialized unlocked.


proc lockMutex*(mutex: PMutex): int {.cdecl, importc: "SDL_LockMutex", dynlib: LibName.}
  ## Lock the mutex.
  ##
  ## Return 0, or -1 on error.


template mutexP*(m: PMutex): int =
  lockMutex(m)


proc tryLockMutex*(mutex: PMutex): int {.cdecl, importc: "SDL_TryLockMutex", dynlib: LibName.}
  ## Try to lock the mutex
  ##
  ## Return 0, MUTEX_TIMEDOUT, or -1 on error


proc unlockMutex*(mutex: PMutex): int {.cdecl, importc: "SDL_UnlockMutex", dynlib: LibName.}
  ## Unlock the mutex.
  ##
  ## Return 0, or -1 on error.
  ##
  ## Warning: It is an error to unlock a mutex that has not been locked by
  ## the current thread, and doing so results in undefined behavior.


template mutexV*(m: PMutex): int =
  unlockMutex(m)



proc destroyMutex*(mutex: PMutex) {.cdecl, importc: "SDL_DestroyMutex", dynlib: LibName.}
  ## Destroy a mutex.


# Semaphore functions


type
  PSem* = pointer ## The SDL semaphore structure, defined in SDL_sem.c


proc createSemaphore*(initial_value: Uint32): PSem {.cdecl, importc: "SDL_CreateSemaphore", dynlib: LibName.}
  ## Create a semaphore, initialized with value, returns nil on failure.


proc destroySemaphore*(sem: PSem) {.cdecl, importc: "SDL_DestroySemaphore", dynlib: LibName.}
  ## Destroy a semaphore.


proc semWait*(sem: PSem): int {.cdecl, importc: "SDL_SemWait", dynlib: LibName.}
  ## This function suspends the calling thread until the semaphore pointed
  ## to by ``sem`` has a positive count. It then atomically decreases the
  ## semaphore count.


proc semTryWait*(sem: PSem): int {.cdecl, importc: "SDL_SemTryWait", dynlib: LibName.}
  ## Non-blocking variant of semWait().
  ##
  ## Return 0 if the wait succeeds, MUTEX_TIMEDOUT if the wait would
  ## block, and -1 on error.


proc semWaitTimeout*(sem: PSem, ms: Uint32): int {.cdecl, importc: "SDL_SemWaitTimeout", dynlib: LibName.}
  ## Variant of semWait() with a timeout in milliseconds.
  ##
  ## Return 0 if the wait succeeds, MUTEX_TIMEDOUT if the wait does not
  ## succeed in the allotted time, and -1 on error.
  ##
  ## Warning: On some platforms this function is implemented by looping with a
  ## delay of 1 ms, and so should be avoided if possible.


proc semPost*(sem: PSem): int {.cdecl, importc: "SDL_SemPost", dynlib: LibName.}
  ## Atomically increases the semaphore's count (not blocking).
  ##
  ## Return 0, or -1 on error.


proc semValue*(sem: PSem): Uint32 {.cdecl, importc: "SDL_SemValue", dynlib: LibName.}
  ## Returns the current count of the semaphore.


# Condition variable functions


type
  PCond* = pointer ## The SDL condition variable structure, defined in SDL_cond.c


proc createCond*(): PCond {.cdecl, importc: "SDL_CreateCond", dynlib: LibName.}
  ## Create a condition variable.
  ##
  ## Typical use of condition variables:
  ##
  ##
  ## Thread A:
  ##
  ## lockMutex(lock)
  ##
  ## while not condition:
  ##
  ##   condWait(cond, lock)
  ##
  ## unlockMutex(lock)
  ##
  ##
  ## Thread B:
  ##
  ## lockMutex(lock)
  ##
  ## ...
  ##
  ## condition = true
  ##
  ## ...
  ##
  ## condSignal(cond)
  ##
  ## unlockMutex(lock)
  ##
  ##
  ## There is some discussion whether to signal the condition variable
  ## with the mutex locked or not.  There is some potential performance
  ## benefit to unlocking first on some platforms, but there are some
  ## potential race conditions depending on how your code is structured.
  ##
  ## In general it's safer to signal the condition variable while the
  ## mutex is locked.


proc destroyCond*(cond: PCond) {.cdecl, importc: "SDL_DestroyCond", dynlib: LibName.}
  ## Destroy a condition variable.


proc condSignal*(cond: PCond): int {.cdecl, importc: "SDL_CondSignal", dynlib: LibName.}
  ## Restart one of the threads that are waiting on the condition variable.
  ##
  ## Return 0 or -1 on error.


proc condBroadcast*(cond: PCond): int {.cdecl, importc: "SDL_CondBroadcast", dynlib: LibName.}
  ## Restart all threads that are waiting on the condition variable.
  ##
  ## Return 0 or -1 on error.

proc condWait*(cond: PCond, mutex: PMutex): int {.cdecl, importc: "SDL_CondWait", dynlib: LibName.}
  ## Wait on the condition variable, unlocking the provided mutex.
  ##
  ## Warning: The mutex must be locked before entering this function!
  ##
  ## The mutex is re-locked once the condition variable is signaled.
  ##
  ## Return 0 when it is signaled, or -1 on error.

proc condWaitTimeout*(cond: PCond, mutex: PMutex, ms: Uint32): int {.cdecl, importc: "SDL_CondWaitTimeout", dynlib: LibName.}
  ## Waits for at most ``ms`` milliseconds, and returns 0 if the condition
  ## variable is signaled, MUTEX_TIMEDOUT if the condition is not
  ## signaled in the allotted time, and -1 on error.
  ##
  ## Warning: On some platforms this function is implemented by looping with a
  ## delay of 1 ms, and so should be avoided if possible.

