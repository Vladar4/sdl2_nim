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

##  atomics.nim
##  ===========
##
##  Atomic operations.
##
##  IMPORTANT:
##  ----------
##
##  If you are not an expert in concurrent lockless programming, you should
##  only be using the atomic lock and reference counting procedures in this
##  file.  In all other cases you should be protecting your data structures
##  with full mutexes.
##
##  The list of "safe" procedures to use are:
##  * ``atomicLock()``
##  * ``atomicUnlock()``
##  * ``atomicIncRef()``
##  * ``atomicDecRef()``
##
##  ``Seriously, here be dragons!``
##
##  You can find out a little more about lockless programming and the
##  subtle issues that can arise here:
##
##  http://msdn.microsoft.com/en-us/library/ee418650%28v=vs.85%29.aspx
##
##  There's also lots of good information here:
##
##  http://www.1024cores.net/home/lock-free-algorithms
##
##  http://preshing.com
##
##  These operations may or may not actually be implemented using
##  processor specific atomic operations. When possible they are
##  implemented as true processor specific atomic operations. When that
##  is not possible the are implemented using locks that *do* use the
##  available atomic operations.
##
##  All of the atomic operations that modify memory are full memory barriers.

##  AtomicLock
##  ----------
##
##  The atomic locks are efficient spinlocks using CPU instructions,
##  but are vulnerable to starvation and can spin forever if a thread
##  holding a lock has been terminated.  For this reason you should
##  minimize the code executed inside an atomic lock and never do
##  expensive things like API or system calls while holding them.
##
##  The atomic locks are not safe to lock recursively.
##
##  ``Porting Note:``
##  The spin lock procedures and type are required and can not be
##  emulated because they are used in the atomic emulation code.

type
  SpinLock* = cint

proc atomicTryLock*(lock: ptr SpinLock): bool {.
    cdecl, importc: "SDL_AtomicTryLock", dynlib: SDL2_LIB.}
  ##  Try to lock a spin lock by setting it to a non-zero value.
  ##
  ##  ``lock`` Points to the lock.
  ##
  ##  ``Return`` `true` if the lock succeeded,
  ##  `false` if the lock is already held.

proc atomicLock*(lock: ptr SpinLock) {.
    cdecl, importc: "SDL_AtomicLock", dynlib: SDL2_LIB.}
  ##  Lock a spin lock by setting it to a non-zero value.
  ##
  ##  ``lock`` Points to the lock.

proc atomicUnlock*(lock: ptr SpinLock) {.
    cdecl, importc: "SDL_AtomicUnlock", dynlib: SDL2_LIB.}
  ##  Unlock a spin lock by setting it to `0`. Always returns immediately.
  ##
  ##  ``lock`` Points to the lock.

type
  Atomic_t* = object ##  \
    ##  A type representing an atomic integer value.  It is a object
    ##  so people don't accidentally use numeric operations on it.
    value*: cint

proc atomicCAS*(a: ptr Atomic_t; oldval: cint; newval: cint): bool {.
    cdecl, importc: "SDL_AtomicCAS", dynlib: SDL2_LIB.}
  ##  Set an atomic variable to a new value if it is currently an old value.
  ##
  ##  ``Return`` `true` if the atomic variable was set, `false` otherwise.
  ##
  ##  ``Note`` If you don't know what this procedure is for,
  ##  you shouldn't use it!

proc atomicSet*(a: ptr Atomic_t; v: cint): cint {.
    cdecl, importc: "SDL_AtomicSet", dynlib: SDL2_LIB.}
  ##  Set an atomic variable to a value.
  ##
  ##  ``Return`` The previous value of the atomic variable.

proc atomicGet*(a: ptr Atomic_t): cint {.
    cdecl, importc: "SDL_AtomicGet", dynlib: SDL2_LIB.}
  ##  Get the value of an atomic variable

proc atomicAdd*(a: ptr Atomic_t; v: cint): cint {.
    cdecl, importc: "SDL_AtomicAdd", dynlib: SDL2_LIB.}
  ##  Add to an atomic variable.
  ##
  ##  ``Return`` The previous value of the atomic variable.
  ##
  ##  ``Note`` This same style can be used for any number operation.

when not declared(atomicIncRef):
  template atomicIncRef*(a: untyped): untyped = ##  \
    ##  Increment an atomic variable used as a reference count.
    atomicAdd(a, 1)

when not declared(atomicDecRef):
  template atomicDecRef*(a: untyped): untyped = ##  \
    ##  Decrement an atomic variable used as a reference count.
    ##
    ##  ``Return`` `true` if the variable reached zero after decrementing,
    ##  ``false`` otherwise.
    (atomicAdd(a, - 1) == 1)

proc atomicCASPtr*(a: ptr pointer; oldval: pointer; newval: pointer): bool {.
    cdecl, importc: "SDL_AtomicCASPtr", dynlib: SDL2_LIB.}
  ##  Set a pointer to a new value if it is currently an old value.
  ##
  ##  ``Return`` `true` if the pointer was set, `false` otherwise.
  ##
  ##  ``Note`` If you don't know what this procedure is for,
  ##  you shouldn't use it!

proc atomicSetPtr*(a: ptr pointer; v: pointer): pointer {.
    cdecl, importc: "SDL_AtomicSetPtr", dynlib: SDL2_LIB.}
  ##  Set a pointer to a value atomically.
  ##
  ##  ``Return`` The previous value of the pointer.

proc atomicGetPtr*(a: ptr pointer): pointer {.
    cdecl, importc: "SDL_AtomicGetPtr", dynlib: SDL2_LIB.}
  ##  Get the value of a pointer atomically.
