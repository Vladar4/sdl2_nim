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

##  cpuinfo.nim
##  ===========
##
##  CPU feature detection for SDL.

const
  CACHELINE_SIZE* = 128 ##  \
    ##  This is a guess for the cacheline size used for padding.
    ##  Most x86 processors have a 64 byte cache line.
    ##  The 64-bit PowerPC processors have a 128 byte cache line.
    ##  We'll use the larger value to be generally safe.

proc getCPUCount*(): cint {.
    cdecl, importc: "SDL_GetCPUCount",  dynlib: SDL2_LIB.}
  ##  This procedure returns the number of CPU cores available.

proc getCPUCacheLineSize*(): cint {.
    cdecl, importc: "SDL_GetCPUCacheLineSize", dynlib: SDL2_LIB.}
  ##  This procedure returns the L1 cache line size of the CPU
  ##
  ##  This is useful for determining multi-threaded structure padding
  ##  or SIMD prefetch sizes.

proc hasRDTSC*(): bool {.
    cdecl, importc: "SDL_HasRDTSC", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has the RDTSC instruction.

proc hasAltiVec*(): bool {.
    cdecl, importc: "SDL_HasAltiVec", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has AltiVec features.

proc hasMMX*(): bool {.
    cdecl, importc: "SDL_HasMMX", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has MMX features.

proc has3DNow*(): bool {.
    cdecl, importc: "SDL_Has3DNow", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has 3DNow! features.

proc hasSSE*(): bool {.
    cdecl, importc: "SDL_HasSSE", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has SSE features.

proc hasSSE2*(): bool {.
    cdecl, importc: "SDL_HasSSE2", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has SSE2 features.

proc hasSSE3*(): bool {.
    cdecl, importc: "SDL_HasSSE3", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has SSE3 features.

proc hasSSE41*(): bool {.
    cdecl, importc: "SDL_HasSSE41", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has SSE4.1 features.

proc hasSSE42*(): bool {.
    cdecl, importc: "SDL_HasSSE42", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has SSE4.2 features.

proc hasAVX*(): bool {.
    cdecl, importc: "SDL_HasAVX", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has AVX features.

proc hasAVX2*(): bool {.
    cdecl, importc: "SDL_HasAVX2", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has AVX2 features.

proc hasAVX512F*(): bool {.
    cdecl, importc: "SDL_HasAVX512F", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has AVX-512F (foundation) features.

proc hasARMSIMD*(): bool {.
    cdecl, importc: "SDL_HasARMSIMD", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has ARM SIMD (ARMv6) features.

proc hasNEON*(): bool {.
    cdecl, importc: "SDL_HasNEON", dynlib: SDL2_LIB.}
  ##  This procedure returns true if the CPU has NEON (ARM SIMD) features.

proc getSystemRAM*(): cint {.
    cdecl, importc: "SDL_GetSystemRAM", dynlib: SDL2_LIB.}
  ##  This procedure returns the amount of RAM configured in the system, in MB.

proc simdGetAlignment*(): csize_t {.
    cdecl, importc: "SDL_SIMDGetAlignment", dynlib: SDL2_LIB.}
  ##  Report the alignment this system needs for SIMD allocations.
  ##
  ##  This will return the minimum number of bytes to which a pointer must be
  ##  aligned to be compatible with SIMD instructions on the current machine.
  ##  For example, if the machine supports SSE only, it will return 16, but if
  ##  it supports AVX-512F, it'll return 64 (etc). This only reports values
  ##  for instruction sets SDL knows about, so if your SDL build doesn't have
  ##  ``sdl.hasAVX512F()``, then it might return 16 for the SSE support it
  ##  sees and not 64 for the AVX-512 instructions that exist but SDL doesn't
  ##  know about. Plan accordingly.

proc simdAlloc*(len: csize_t): pointer {.
    cdecl, importc: "SDL_SIMDAlloc", dynlib: SDL2_LIB.}
  ##  Allocate memory in a SIMD-friendly way.
  ##
  ##  This will allocate a block of memory that is suitable for use with SIMD
  ##  instructions. Specifically, it will be properly aligned and padded for
  ##  the system's supported vector instructions.
  ##
  ##  The memory returned will be padded such that it is safe to read or write
  ##  an incomplete vector at the end of the memory block. This can be useful
  ##  so you don't have to drop back to a scalar fallback at the end of your
  ##  SIMD processing loop to deal with the final elements without overflowing
  ##  the allocated buffer.
  ##
  ##  You must free this memory with ``sdl.freeSIMD()``, not ``free()`` or
  ##  ``sdl.free()`` etc.
  ##
  ##  Note that SDL will only deal with SIMD instruction sets it is aware of;
  ##  for example, SDL 2.0.8 knows that SSE wants 16-byte vectors
  ##  (``sdl.hasSSE()``), and AVX2 wants 32 bytes (``sdl.hasAVX2()``),
  ##  but doesn't know that AVX-512 wants 64. To be clear: if you can't decide
  ##  to use an instruction set with an ``sdl.has...()`` procedure, don't use
  ##  that instruction set with memory allocated through here.
  ##
  ##  ``sdl.allocSIMD(0)`` will return a non-`nil` pointer, assuming
  ##  the system isn't out of memory.
  ##
  ##  ``len`` The length, in bytes, of the block to allocated.
  ##  The actual allocated block might be larger due to padding, etc.
  ##
  ##  ``Return`` pointer to newly-allocated block, `nil` if out of memory.
  ##
  ##  See also:
  ##
  ##  ``sdl.simdAlignment()``
  ##
  ##  ``sdl.simdRealloc()``
  ##
  ##  ``sdl.simdFree()``

proc simdRealloc*(mem: pointer, len: csize_t): pointer {.
    cdecl, importc: "SDL_SIMDRealloc", dynlib: SDL2_LIB.}
  ##  Reallocate memory obtained from ``sdl.simdAlloc()``
  ##
  ##  It is not valid to use this procedure on a pointer from anything but
  ##  ``sdl.simdAlloc()``. It can't be used on pointers from ``malloc()``,
  ##  ``realloc()``,  ``sdl.malloc()``, ``memalign()``, ``new``, etc.
  ##
  ##  ``mem`` The pointer obtained from ``sdl.simdAlloc()``. This procedure also
  ##  accepts `nil`, at which point this procedure is the same as
  ##  calling ``sdl.realloc()`` with a `nil` pointer.
  ##
  ##  ``len`` The length, in bytes, of the block to allocated. The actual
  ##  allocated block might be larger due to padding, etc. Passing `0` will
  ##  return a non-`nil` pointer, assuming the system isn't out of memory.
  ##
  ##  ``Return`` pointer to newly-reallocated block, `nil` if out of memory.
  ##
  ##  See also:
  ##
  ##  ``sdl.simdAlignment()``
  ##
  ##  ``sdl.simdAlloc()``
  ##
  ##  ``sdl.simdFree()``

proc simdFree*(p: pointer) {.
    cdecl, importc: "SDL_SIMDFree", dynlib: SDL2_LIB.}
  ##  Deallocate memory obtained from ``sdl.simdAlloc()``.
  ##
  ##  It is not valid to use this procedure on a pointer from anything but
  ##  ``sdl.simdAlloc()``. It can't be used on pointers from malloc, realloc,
  ##  ``sdl.malloc()``, memalign, new[], etc.
  ##
  ##  However, ``sdl.simdFree(nil)`` is a legal no-op.
  ##
  ##  See also:
  ##
  ##  ``sdl.simdAlloc()``
  ##
  ##  ``sdl.simdRealloc()``

