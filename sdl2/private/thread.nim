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

##  thread.nim
##  ==========
##

type
  Thread* = pointer ##  The SDL thread structure, defined in SDL_thread.c

type
  ThreadID* = culong ##  The SDL thread ID

type
  TLSID* = cuint ##  Thread local storage ID, `0` is the invalid ID

type
  ThreadPriority* {.size: sizeof(cint).} = enum ##  \
    ##  The SDL thread priority.
    ##
    ##  ``Note`` On many systems you require special privileges
    ##  to set high priority.
    THREAD_PRIORITY_LOW,
    THREAD_PRIORITY_NORMAL,
    THREAD_PRIORITY_HIGH

type
  ThreadFunction* = proc (data: pointer): cint {.cdecl.} ##  \
    ##  The procedure passed to ``createThread()``.
    ##  It is passed a ``pointer`` user context parameter
    ##  and returns an ``int``.

proc createThread*(
    fn: ThreadFunction; name: cstring; data: pointer): Thread {.
      cdecl, importc: "SDL_CreateThread", dynlib: SDL2_LIB.}
  ##  Create a thread.
  ##
  ##  Thread naming is a little complicated: Most systems have very small
  ##  limits for the string length (Haiku has 32 bytes, Linux currently has
  ##  16, Visual C++ 6.0 has nine!), and possibly other arbitrary rules.
  ##  You'll have to see what happens with your system's debugger.
  ##  The name should be UTF-8 (but using the naming limits of C identifiers
  ##  is a better bet). There are no requirements for thread naming
  ##  conventions, so long as the string is null-terminated UTF-8, but these
  ##  guidelines are helpful in choosing a name:
  ##
  ##  http://stackoverflow.com/questions/149932/naming-conventions-for-threads
  ##
  ##  If a system imposes requirements, SDL will try to munge the string for
  ##  it (truncate, etc), but the original string contents will be available
  ##  from ``getThreadName()``.

proc getThreadName*(thread: Thread): cstring {.
    cdecl, importc: "SDL_GetThreadName", dynlib: SDL2_LIB.}
  ##  Get the thread name, as it was specified in ``createThread()``.
  ##  This procedure returns a pointer to a UTF-8 string that names the
  ##  specified thread, or `nil` if it doesn't have a name. This is internal
  ##  memory, not to be ``free()``'d by the caller, and remains valid until the
  ##  specified thread is cleaned up by ``waitThread()``.

proc threadID*(): ThreadID {.
    cdecl, importc: "SDL_ThreadID", dynlib: SDL2_LIB.}
  ##  Get the thread identifier for the current thread.

proc getThreadID*(thread: Thread): ThreadID {.
    cdecl, importc: "SDL_GetThreadID", dynlib: SDL2_LIB.}
  ##  Get the thread identifier for the specified thread.
  ##
  ##  Equivalent to ``threadID()`` if the specified thread is `nil`.

proc setThreadPriority*(priority: ThreadPriority): cint {.
    cdecl, importc: "SDL_SetThreadPriority", dynlib: SDL2_LIB.}
  ##  Set the priority for the current thread.

proc waitThread*(thread: Thread; status: ptr cint) {.
    cdecl, importc: "SDL_WaitThread", dynlib: SDL2_LIB.}
  ##  Wait for a thread to finish. Threads that haven't been detached will
  ##  remain (as a "zombie") until this procedure cleans them up. Not doing so
  ##  is a resource leak.
  ##
  ##  Once a thread has been cleaned up through this procedure, the ``Thread``
  ##  that references it becomes invalid and should not be referenced again.
  ##  As such, only one thread may call ``WaitThread()`` on another.
  ##
  ##  The return code for the thread procedure is placed in the area
  ##  pointed to by ``status``, if ``status`` is not `nil`.
  ##
  ##  You may not wait on a thread that has been used in a call to
  ##  ``detachThread()``. Use either that procedure or this one, but not
  ##  both, or behavior is undefined.
  ##
  ##  It is safe to pass `nil` to this procedure; it is a no-op.

proc detachThread*(thread: Thread) {.
    cdecl, importc: "SDL_DetachThread", dynlib: SDL2_LIB.}
  ##  A thread may be "detached" to signify that it should not remain until
  ##  another thread has called ``waitThread()`` on it. Detaching a thread
  ##  is useful for long-running threads that nothing needs to synchronize
  ##  with or further manage. When a detached thread is done, it simply
  ##  goes away.
  ##
  ##  There is no way to recover the return code of a detached thread. If you
  ##  need this, don't detach the thread and instead use ``waitThread()``.
  ##
  ##  Once a thread is detached, you should usually assume the ``Thread`` isn't
  ##  safe to reference again, as it will become invalid immediately upon
  ##  the detached thread's exit, instead of remaining until someone has called
  ##  ``waitThread()`` to finally clean it up. As such, don't detach the same
  ##  thread more than once.
  ##
  ##  If a thread has already exited when passed to ``detachThread()``, it will
  ##  stop waiting for a call to ``waitThread()`` and clean up immediately.
  ##  It is not safe to detach a thread that might be used with
  ##  ``waitThread()``.
  ##
  ##  You may not call ``waitThread()`` on a thread that has been detached.
  ##  Use either that procedure or this one, but not both, or behavior is
  ##  undefined.
  ##
  ##  It is safe to pass `nil` to this procedure; it is a no-op.

proc tlsCreate*(): TLSID {.
    cdecl, importc: "SDL_TLSCreate", dynlib: SDL2_LIB.}
  ##  Create an identifier that is globally visible to all threads but refers
  ##  to data that is thread-specific.
  ##
  ##  ``Return`` The newly created thread local storage identifier,
  ##  or `0` on error.
  ##
  ##  .. code-block:: nim
  ##    var
  ##      tls_lock: SpinLock
  ##      thread_local_storage: SDL_TLSID
  ##
  ##    proc setMyThreadData(value: pointer) =
  ##      if not thread_local_storage:
  ##        atomicLock(addr(tls_lock))
  ##          if not thread_local_storage:
  ##            thread_local_storage = tlsCreate()
  ##          atomicUnlock(addr(tls_lock))
  ##      tlsSet(thread_local_storage, value, 0)
  ##
  ##    proc getMyThreadData(): pointer =
  ##      return tlsGet(thread_local_storage)
  ##
  ##  See also:
  ##
  ##    ``tlsGet()``
  ##
  ##    ``tlsSet()``

proc tlsGet*(id: TLSID): pointer {.
    cdecl, importc: "SDL_TLSGet", dynlib: SDL2_LIB.}
  ##  Get the value associated with a thread local storage ID
  ##  for the current thread.
  ##
  ##  ``id`` The thread local storage ID.
  ##
  ##  ``Return`` The value associated with the ID for the current thread,
  ##  or `nil` if no value has been set.
  ##
  ##  See also:
  ##
  ##  ``tlsCreate()``
  ##
  ##  ``tlsSet()``

proc tlsSet*(
    id: TLSID; value: pointer;
    destructor: proc (a2: pointer) {.cdecl.}): cint {.
      cdecl, importc: "SDL_TLSSet", dynlib: SDL2_LIB.}
  ##  Set the value associated with a thread local storage ID
  ##  for the current thread.
  ##
  ##  ``id`` The thread local storage ID.
  ##
  ##  ``value`` The value to associate with the ID for the current thread
  ##  ``destructor`` A procedure called when the thread exits, to free the value.
  ##
  ##  ``Return`` `0` on success, `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``tlsCreate()``
  ##
  ##  ``tlsGet()``
