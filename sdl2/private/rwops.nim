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

##  rwops.nim
##  =========
##
##  This file provides a general interface for SDL to read and write
##  data streams. It can easily be extended to files, memory, etc.

# RWops Kinds
const
  RWOPS_UNKNOWN*    = 0 ##  Unknown stream type
  RWOPS_WINFILE*    = 1 ##  Win32 file
  RWOPS_STDFILE*    = 2 ##  Stdio file
  RWOPS_JNIFILE*    = 3 ##  Android asset
  RWOPS_MEMORY*     = 4 ##  Memory stream
  RWOPS_MEMORY_RO*  = 5 ##  Read-Only memory stream

type
  RWopsAndroidio* = object
    fileNameRef*: pointer
    inputStreamRef*: pointer
    readableByteChannelRef*: pointer
    readMethod*: pointer
    assetFileDescriptorRef*: pointer
    position*: clong
    size*: clong
    offset*: clong
    fd*: cint

  RWopsWindowsioBuffer* = object
    data*: pointer
    size*: csize
    left*: csize

  RWopsWindowsio* = object
    append*: bool
    h*: pointer
    buffer*: RWopsWindowsioBuffer

  RWopsStdio* = object
    autoclose*: bool
    fp*: File

  RWopsMemio* = object
    base*: ptr uint8
    here*: ptr uint8
    stop*: ptr uint8

  RWopsUnknownio* = object
    data1*: pointer
    data2*: pointer

  RWopsKind* = object {.union.}
      androidio*: RWopsAndroidio
      windowsio*: RWopsWindowsio
      stdio*: RWopsStdio
      mem*: RWopsMemio
      unknown*: RWopsUnknownio

  RWops* = object ##  \
    ##  This is the read/write operation structure -- very basic.

    size*: proc (context: ptr RWops): int64 {.cdecl.} ##  \
      ##  ``Return`` the size of the file in this rwops, or `-1` if unknown

    seek*: proc (context: ptr RWops;
        offset: int64; whence: cint): int64 {.cdecl.} ##  \
      ##  Seek to ``offset`` relative to ``whence``,
      ##  one of stdio's whence values:
      ##
      ##  `RW_SEEK_SET`, `RW_SEEK_CUR`, `RW_SEEK_END`
      ##
      ##  ``Return`` the final offset in the data stream, or `-1` on error.

    read*: proc (context: ptr RWops;
        p: pointer; size: csize; maxnum: csize): csize {.cdecl.} ##  \
      ##  Read up to ``maxnum`` objects each of size ``size`` from the data
      ##  stream to the area pointed at by ``ptr``.
      ##
      ##  ``Return`` the number of objects read, or `0` at error or end of file.

    write*: proc (context: ptr RWops;
        p: pointer; size: csize; num: csize): csize {.cdecl.} ##  \
      ##  Write exactly ``num`` objects each of size ``size`` from the area
      ##  pointed at by ``ptr`` to data stream.
      ##
      ##  ``Return`` the number of objects written,
      ##  or `0` at error or end of file.

    close*: proc (context: ptr RWops): cint {.cdecl.} ##  \
      ##  Close and free an allocated RWops object.
      ##
      ##  ``Return`` `0` if successful,
      ##  or `-1` on write error when flushing data.

    kind*: uint32
    mem*: RWopsKind


#   RWFrom procedures
#
#   Procedures to create RWopsObj objects from various data streams.

proc rwFromFile*(file: cstring; mode: cstring): ptr RWops {.
    cdecl, importc: "SDL_RWFromFile", dynlib: SDL2_LIB.}

proc rwFromFP*(fp: File; autoclose: bool): ptr RWops {.
    cdecl, importc: "SDL_RWFromFP", dynlib: SDL2_LIB.}

# #ifndef HAVE_STDIO_H
# proc rwFromFP*(fp: pointer; autoclose: bool): ptr RWops {.
#     cdecl, importc: "SDL_RWFromFP", dynlib: SDL2_LIB.}

proc rwFromMem*(mem: pointer; size: cint): ptr RWops {.
    cdecl, importc: "SDL_RWFromMem", dynlib: SDL2_LIB.}

proc rwFromConstMem*(mem: pointer; size: cint): ptr RWops {.
    cdecl, importc: "SDL_RWFromConstMem", dynlib: SDL2_LIB.}


# RWFrom procedures

proc allocRW*(): ptr RWops {.
    cdecl, importc: "SDL_AllocRW", dynlib: SDL2_LIB.}

proc freeRW*(area: ptr RWops) {.
    cdecl, importc: "SDL_FreeRW", dynlib: SDL2_LIB.}


const
  RW_SEEK_SET* = 0 ## Seek from the beginning of data
  RW_SEEK_CUR* = 1 ## Seek relative to current read point
  RW_SEEK_END* = 2 ## Seek relative to the end of data


#   Read/write macros
#
#   Macros to easily read and write from an RWopsObj object.

template rwSize*(ctx: untyped): untyped =
  (ctx).size(ctx)

template rwSeek*(ctx, offset, whence: untyped): untyped =
  (ctx).seek(ctx, offset, whence)

template rwTell*(ctx: untyped): untyped =
  (ctx).seek(ctx, 0, RW_SEEK_CUR)

template rwRead*(ctx, p, size, n: untyped): untyped =
  (ctx).read(ctx, p, size, n)

template rwWrite*(ctx, p, size, n: untyped): untyped =
  (ctx).write(ctx, p, size, n)

template rwClose*(ctx: untyped): untyped =
  (ctx).close(ctx)


# Read/write macros

#   Read endian procedures
#
#   Read an item of the specified endianness and return in native format.
proc readU8*(src: ptr RWops): uint8 {.
    cdecl, importc: "SDL_ReadU8", dynlib: SDL2_LIB.}

proc readLE16*(src: ptr RWops): uint16 {.
    cdecl, importc: "SDL_ReadLE16", dynlib: SDL2_LIB.}

proc readBE16*(src: ptr RWops): uint16 {.
    cdecl, importc: "SDL_ReadBE16", dynlib: SDL2_LIB.}

proc readLE32*(src: ptr RWops): uint32 {.
    cdecl, importc: "SDL_ReadLE32", dynlib: SDL2_LIB.}

proc readBE32*(src: ptr RWops): uint32 {.
    cdecl, importc: "SDL_ReadBE32", dynlib: SDL2_LIB.}

proc readLE64*(src: ptr RWops): uint64 {.
    cdecl, importc: "SDL_ReadLE64", dynlib: SDL2_LIB.}

proc readBE64*(src: ptr RWops): uint64 {.
    cdecl, importc: "SDL_ReadBE64", dynlib: SDL2_LIB.}


#   Write endian procedures
#
#   Write an item of native format to the specified endianness.

proc writeU8*(dst: ptr RWops; value: uint8): csize {.
    cdecl, importc: "SDL_WriteU8", dynlib: SDL2_LIB.}

proc writeLE16*(dst: ptr RWops; value: uint16): csize {.
    cdecl, importc: "SDL_WriteLE16", dynlib: SDL2_LIB.}

proc writeBE16*(dst: ptr RWops; value: uint16): csize {.
    cdecl, importc: "SDL_WriteBE16", dynlib: SDL2_LIB.}

proc writeLE32*(dst: ptr RWops; value: uint32): csize {.
    cdecl, importc: "SDL_WriteLE32", dynlib: SDL2_LIB.}

proc writeBE32*(dst: ptr RWops; value: uint32): csize {.
    cdecl, importc: "SDL_WriteBE32", dynlib: SDL2_LIB.}

proc writeLE64*(dst: ptr RWops; value: uint64): csize {.
    cdecl, importc: "SDL_WriteLE64", dynlib: SDL2_LIB.}

proc writeBE64*(dst: ptr RWops; value: uint64): csize {.
    cdecl, importc: "SDL_WriteBE64", dynlib: SDL2_LIB.}
