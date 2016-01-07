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

proc getSystemRAM*(): cint {.
    cdecl, importc: "SDL_GetSystemRAM", dynlib: SDL2_LIB.}
  ##  This procedure returns the amount of RAM configured in the system, in MB.
