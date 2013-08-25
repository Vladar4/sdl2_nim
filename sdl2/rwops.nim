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
# This file provides a general interface for SDL to read and write
# data streams.  It can easily be extended to files, memory, etc.
#


# RWops Types
const
  RWOPS_UNKNOWN* = 0 ## Unknown stream type
  RWOPS_WINFILE* = 1 ## Win32 file
  RWOPS_STDFILE* = 2 ## Stdio file
  RWOPS_JNIFILE* = 3 ## Android asset
  RWOPS_MEMORY* = 4 ## Memory stream
  RWOPS_MEMORY_RO* = 5 ## Read-Only memory stream


type
  PRWops* = ptr TRWops
  TRWops* = object
    ## This is the read/write operation structure -- very basic.
    size*: proc(context: PRWops): int64 ## Return the size of the file in this rwops, or -1 if unknown
    seek*: proc(context: PRWops, offset: int64, whence: int): int64 ## Seek to ``offset`` relative to ``whence``, one of stdio's whence values: RW_SEEK_SET, RW_SEEK_CUR, RW_SEEK_END. Return the final offset in the data stream, or -1 on error.
    read*: proc(context: PRWops, pntr: pointer, size, maxnum: csize): csize ## Read up to ``maxnum`` objects each of size ``size`` from the data stream to the area pointed at by ``pntr``. Return the number of objects read, or 0 at error or end of file.
    write*: proc(context: PRWops, pntr: pointer, size, num: csize): csize ## Write exactly ``num`` objects each of size ``size`` from the area pointed at by ``ptr`` to data stream. Return the number of objects written, or 0 at error or end of file.
    close*: proc(context: PRWops): int ## Close and free an allocated PRWops structure. Return 0 if successful or -1 on write error when flushing data.
    kind*: Uint32
    mem*: TMem

  TMem* = object
    base*: ptr byte
    here*: ptr byte
    stop*: ptr byte

#
# RWFrom functions
#
# Functions to create PRWops structures from various data streams.
#

proc rwFromFile*(file, mode: cstring): PRWops {.cdecl, importc: "SDL_RWFromFile", dynlib: LibName.}


proc rwFromFP*(fp: pointer, autoclose: bool): PRWops {.cdecl, importc: "SDL_RWFromFP", dynlib: LibName.}


proc rwFromMem*(mem: pointer, size: int): PRWops {.cdecl, importc: "SDL_RWFromMem", dynlib: LibName.}


proc rwFromConstMem*(mem: pointer, size: int): PRWops {.cdecl, importc: "SDL_RWFromConstMem", dynlib: LibName.}


proc allocRW*(): PRWops {.cdecl, importc: "SDL_AllocRW", dynlib: LibName.}


proc freeRW*(area: PRWops) {.cdecl, importc: "SDL_FreeRW", dynlib: LibName.}


const
  RW_SEEK_SET* = 0 ## Seek from the beginning of data
  RW_SEEK_CUR* = 1 ## Seek relative to current read point
  RW_SEEK_END* = 2 ## Seek relative to the end of data


#
# Read/write templates
#
# Templates to easily read and write from an PRWops structure.
#

template rwSize*(ctx: PRWops): int64 =
  size(ctx)


template rwSeek*(ctx: PRWops, offset: int64, whence: int): int64 =
  seek(ctx, offset, whence)


template rwTell*(ctx: PRWops): int64 =
  seek(ctx, 0, RW_SEEK_CUR)


template rwRead*(ctx: PRWops, pntr: pointer, size, n: csize): csize =
  read(ctx, pntr, size, n)


template rwWrite*(ctx: PRWops, pntr: pointer, size, n: csize): csize =
  write(ctx, pntr, size, n)


template rwClose*(ctx: PRWops): int =
  close(ctx)


#
# Read endian functions
#
# Read an item of the specified endianness and return in native format.
#

proc readU8*(src: PRWops): Uint8 {.cdecl, importc: "SDL_ReadU8", dynlib: LibName.}


proc readLE16*(src: PRWops): Uint16 {.cdecl, importc: "SDL_ReadLE16", dynlib: LibName.}


proc readBE16*(src: PRWops): Uint16 {.cdecl, importc: "SDL_ReadBE16", dynlib: LibName.}


proc readLE32*(src: PRWops): Uint32 {.cdecl, importc: "SDL_ReadLE32", dynlib: LibName.}


proc readBE32*(src: PRWops): Uint32 {.cdecl, importc: "SDL_ReadBE32", dynlib: LibName.}


proc readLE64*(src: PRWops): Uint64 {.cdecl, importc: "SDL_ReadLE64", dynlib: LibName.}


proc readBE64*(src: PRWops): Uint64 {.cdecl, importc: "SDL_ReadBE64", dynlib: LibName.}

#
# Write endian functions
#
# Write an item of native format to the specified endianness.
#

proc writeU8*(dst: PRWops, value: Uint8): csize {.cdecl, importc: "SDL_WriteU8", dynlib: LibName.}


proc writeLE16*(dst: PRWops, value: Uint16): csize {.cdecl, importc: "SDL_WriteLE16", dynlib: LibName.}


proc writeBE16*(dst: PRWops, value: Uint16): csize {.cdecl, importc: "SDL_WriteBE16", dynlib: LibName.}


proc writeLE32*(dst: PRWops, value: Uint32): csize {.cdecl, importc: "SDL_WriteLE32", dynlib: LibName.}


proc writeBE32*(dst: PRWops, value: Uint32): csize {.cdecl, importc: "SDL_WriteBE32", dynlib: LibName.}


proc writeLE64*(dst: PRWops, value: Uint64): csize {.cdecl, importc: "SDL_WriteLE64", dynlib: LibName.}


proc writeBE64*(dst: PRWops, value: Uint64): csize {.cdecl, importc: "SDL_WriteBE64", dynlib: LibName.}

