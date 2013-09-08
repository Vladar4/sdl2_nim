#
# SDL_image:  An example image loading library for use with SDL
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
# A simple library to load images of various formats as SDL surfaces
#


import
  sdl, unsigned


# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 0


template version*(x: PVersion) =
  ## This template can be used to fill a version structure with the compile-time
  ## version of the image library.
  x.major = MAJOR_VERSION
  x.minor = MINOR_VERSION
  x.patch = PATCHLEVEL


template version*(x: TVersion) =
  version(addr(x))


proc linkedVersion*(): PVersion {.cdecl, importc: "IMG_Linked_Version", dynlib: LibImgName.}
## This function gets the version of the dynamically linked image library.
## it should NOT be used to fill a version structure, instead you should
## use the version() template.


# ImgInitFlags
const
    INIT_JPG*  = 0x00000001
    INIT_PNG*  = 0x00000002
    INIT_TIF*  = 0x00000004
    INIT_WEBP* = 0x00000008


proc init*(flags: int): int {.cdecl, importc: "IMG_Init", dynlib: LibImgName.}
  ## Loads dynamic libraries and prepares them for use.  Flags should be
  ## one or more flags from ImgInitFlags OR'd together.
  ## It returns the flags successfully initialized, or 0 on failure.


proc quit*() {.cdecl, importc: "IMG_Quit", dynlib: LibImgName.}
  ## Unloads libraries loaded with init


proc loadTypedRW*(src: PRWops, freesrc: int, kind: cstring): PSurface {.cdecl, importc: "IMG_LoadTyped_RW", dynlib: LibImgName.}
  ## Load an image from an SDL data source.
  ## The ``kind`` may be one of: "BMP", "GIF", "PNG", etc.
  ##
  ## If the image format supports a transparent pixel, SDL will set the
  ## colorkey for the surface.  You can enable RLE acceleration on the
  ## surface afterwards by calling:
  ## setColorKey(image, RLEACCEL, image.format.colorkey)


# Convenience functions

proc load*(file: cstring): PSurface {.cdecl, importc: "IMG_Load", dynlib: LibImgName.}


proc loadRW*(src: PRWops, freesrc: int): PSurface {.cdecl, importc: "IMG_Load_RW", dynlib: LibImgName.}


when versionAtLeast(2, 0, 0):
  # Load an image directly into a render texture.

  proc loadTexture*(renderer: PRenderer,
    file: cstring): PTexture {.cdecl, importc: "IMG_LoadTexture", dynlib: LibImgName.}

  proc loadTextureRW*(renderer: PRenderer,
    src: PRWops, freesrc: int): PTexture {.cdecl, importc: "IMG_LoadTexture_RW", dynlib: LibImgName.}
  
  proc loadTextureTypedRW*(renderer: PRenderer,
    src: PRWops, freesrc: int, kind: cstring): PTexture {.cdecl, importc: "IMG_LoadTextureTyped_RW", dynlib: LibImgName.}


# Functions to detect a file type, given a seekable source
#IMG_isICO(SDL_RWops *src): int {.cdecl, importc: "IMG_isICO", dynlib: LibImgName.}
proc isCUR*(src: PRWops): int {.cdecl, importc: "IMG_isCUR", dynlib: LibImgName.}
proc isBMP*(src: PRWops): int {.cdecl, importc: "IMG_isBMP", dynlib: LibImgName.}
proc isGIF*(src: PRWops): int {.cdecl, importc: "IMG_isGIF", dynlib: LibImgName.}
proc isJPG*(src: PRWops): int {.cdecl, importc: "IMG_isJPG", dynlib: LibImgName.}
proc isLBM*(src: PRWops): int {.cdecl, importc: "IMG_isLBM", dynlib: LibImgName.}
proc isPCX*(src: PRWops): int {.cdecl, importc: "IMG_isPCX", dynlib: LibImgName.}
proc isPNG*(src: PRWops): int {.cdecl, importc: "IMG_isPNG", dynlib: LibImgName.}
proc isPNM*(src: PRWops): int {.cdecl, importc: "IMG_isPNM", dynlib: LibImgName.}
proc isTIF*(src: PRWops): int {.cdecl, importc: "IMG_isTIF", dynlib: LibImgName.}
proc isXCF*(src: PRWops): int {.cdecl, importc: "IMG_isXCF", dynlib: LibImgName.}
proc isXPM*(src: PRWops): int {.cdecl, importc: "IMG_isXPM", dynlib: LibImgName.}
proc isXV*(src: PRWops): int {.cdecl, importc: "IMG_isXV", dynlib: LibImgName.}
proc isWEBP*(src: PRWops): int {.cdecl, importc: "IMG_isWEBP", dynlib: LibImgName.}


# Individual loading functions
proc loadICO_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadICO_RW", dynlib: LibImgName.}
proc loadCUR_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadCUR_RW", dynlib: LibImgName.}
proc loadBMP_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadBMP_RW", dynlib: LibImgName.}
proc loadGIF_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadGIF_RW", dynlib: LibImgName.}
proc loadJPG_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadJPG_RW", dynlib: LibImgName.}
proc loadLBM_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadLBM_RW", dynlib: LibImgName.}
proc loadPCX_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadPCX_RW", dynlib: LibImgName.}
proc loadPNG_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadPNG_RW", dynlib: LibImgName.}
proc loadPNM_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadPNM_RW", dynlib: LibImgName.}
proc loadTGA_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadTGA_RW", dynlib: LibImgName.}
proc loadTIF_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadTIF_RW", dynlib: LibImgName.}
proc loadXCF_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadXCF_RW", dynlib: LibImgName.}
proc loadXPM_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadXPM_RW", dynlib: LibImgName.}
proc loadXV_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadXV_RW", dynlib: LibImgName.}
proc loadWEBP_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadWEBP_RW", dynlib: LibImgName.}


proc readXPMFromArray*(xpm: ptr cstring): PSurface {.cdecl, importc: "IMG_ReadXPMFromArray", dynlib: LibImgName.}


# Individual saving functions

proc savePNG*(surface: PSurface, file: cstring): int {.cdecl, importc: "IMG_SavePNG", dynlib: LibImgName.}

proc savePNG_RW*(surface: PSurface, dst: PRWops, freedst: int): int {.cdecl, importc: "IMG_SavePNG_RW", dynlib: LibImgName.}


# We'll use SDL for reporting errors

proc setError*(fmt: cstring): int {.cdecl, importc: "SDL_SetError", varargs, dynlib: LibName.}


proc getError*(): cstring {.cdecl, importc: "SDL_GetError", dynlib: LibName.}

