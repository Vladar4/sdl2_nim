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


# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  IMAGE_MAJOR_VERSION* = 2
  IMAGE_MINOR_VERSION* = 0
  IMAGE_PATCHLEVEL* = 0


template imageVersion*(x: PVersion) =
  ## This template can be used to fill a version structure with the compile-time
  ## version of the image library.
  x.major = IMAGE_MAJOR_VERSION
  x.minor = IMAGE_MINOR_VERSION
  x.patch = IMAGE_PATCHLEVEL


template imageVersion*(x: TVersion) =
  imageVersion(addr(x))


proc imgLinkedVersion*(): PVersion {.cdecl, importc: "IMG_Linked_Version", dynlib: LibImgName.}
## This function gets the version of the dynamically linked image library.
## it should NOT be used to fill a version structure, instead you should
## use the imageVersion() template.


type
  TImgInitFlags* = enum
    IMG_INIT_JPG = 0x00000001
    IMG_INIT_PNG = 0x00000002
    IMG_INIT_TIF = 0x00000004
    IMG_INIT_WEBP = 0x00000008


proc imgInit*(flags: int): int {.cdecl, importc: "IMG_Init", dynlib: LibImgName.}
  ## Loads dynamic libraries and prepares them for use.  Flags should be
  ## one or more flags from TImgInitFlags OR'd together.
  ## It returns the flags successfully initialized, or 0 on failure.


proc imgQuit*() {.cdecl, importc: "IMG_Quit", dynlib: LibImgName.}
  ## Unloads libraries loaded with imgInit


proc imgLoadTypedRW*(src: PRWops, freesrc: int, kind: cstring): PSurface {.cdecl, importc: "IMG_LoadTyped_RW", dynlib: LibImgName.}
  ## Load an image from an SDL data source.
  ## The ``kind`` may be one of: "BMP", "GIF", "PNG", etc.
  ##
  ## If the image format supports a transparent pixel, SDL will set the
  ## colorkey for the surface.  You can enable RLE acceleration on the
  ## surface afterwards by calling:
  ## setColorKey(image, RLEACCEL, image.format.colorkey)


# Convenience functions

proc imgLoad*(file: cstring): PSurface {.cdecl, importc: "IMG_Load", dynlib: LibImgName.}


proc imgLoadRW*(src: PRWops, freesrc: int): PSurface {.cdecl, importc: "IMG_Load_RW", dynlib: LibImgName.}


when versionAtLeast(2, 0, 0):
  # Load an image directly into a render texture.

  proc imgLoadTexture*(renderer: PRenderer,
    file: cstring): PTexture {.cdecl, importc: "IMG_LoadTexture", dynlib: LibImgName.}

  proc imgLoadTextureRW*(renderer: PRenderer,
    src: PRWops, freesrc: int): PTexture {.cdecl, importc: "IMG_LoadTexture_RW", dynlib: LibImgName.}
  
  proc imgLoadTextureTypedRW*(renderer: PRenderer,
    src: PRWops, freesrc: int, kind: cstring): PTexture {.cdecl, importc: "IMG_LoadTextureTyped_RW", dynlib: LibImgName.}


# Functions to detect a file type, given a seekable source
#IMG_isICO(SDL_RWops *src): int {.cdecl, importc: "IMG_isICO", dynlib: LibImgName.}
proc imgIsCUR*(src: PRWops): int {.cdecl, importc: "IMG_isCUR", dynlib: LibImgName.}
proc imgIsBMP*(src: PRWops): int {.cdecl, importc: "IMG_isBMP", dynlib: LibImgName.}
proc imgIsGIF*(src: PRWops): int {.cdecl, importc: "IMG_isGIF", dynlib: LibImgName.}
proc imgIsJPG*(src: PRWops): int {.cdecl, importc: "IMG_isJPG", dynlib: LibImgName.}
proc imgIsLBM*(src: PRWops): int {.cdecl, importc: "IMG_isLBM", dynlib: LibImgName.}
proc imgIsPCX*(src: PRWops): int {.cdecl, importc: "IMG_isPCX", dynlib: LibImgName.}
proc imgIsPNG*(src: PRWops): int {.cdecl, importc: "IMG_isPNG", dynlib: LibImgName.}
proc imgIsPNM*(src: PRWops): int {.cdecl, importc: "IMG_isPNM", dynlib: LibImgName.}
proc imgIsTIF*(src: PRWops): int {.cdecl, importc: "IMG_isTIF", dynlib: LibImgName.}
proc imgIsXCF*(src: PRWops): int {.cdecl, importc: "IMG_isXCF", dynlib: LibImgName.}
proc imgIsXPM*(src: PRWops): int {.cdecl, importc: "IMG_isXPM", dynlib: LibImgName.}
proc imgIsXV*(src: PRWops): int {.cdecl, importc: "IMG_isXV", dynlib: LibImgName.}
proc imgIsWEBP*(src: PRWops): int {.cdecl, importc: "IMG_isWEBP", dynlib: LibImgName.}


# Individual loading functions
proc imgLoadICO_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadICO_RW", dynlib: LibImgName.}
proc imgLoadCUR_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadCUR_RW", dynlib: LibImgName.}
proc imgLoadBMP_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadBMP_RW", dynlib: LibImgName.}
proc imgLoadGIF_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadGIF_RW", dynlib: LibImgName.}
proc imgLoadJPG_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadJPG_RW", dynlib: LibImgName.}
proc imgLoadLBM_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadLBM_RW", dynlib: LibImgName.}
proc imgLoadPCX_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadPCX_RW", dynlib: LibImgName.}
proc imgLoadPNG_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadPNG_RW", dynlib: LibImgName.}
proc imgLoadPNM_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadPNM_RW", dynlib: LibImgName.}
proc imgLoadTGA_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadTGA_RW", dynlib: LibImgName.}
proc imgLoadTIF_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadTIF_RW", dynlib: LibImgName.}
proc imgLoadXCF_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadXCF_RW", dynlib: LibImgName.}
proc imgLoadXPM_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadXPM_RW", dynlib: LibImgName.}
proc imgLoadXV_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadXV_RW", dynlib: LibImgName.}
proc imgLoadWEBP_RW*(src: PRWops): PSurface {.cdecl, importc: "IMG_LoadWEBP_RW", dynlib: LibImgName.}


proc imgReadXPMFromArray*(xpm: ptr cstring): PSurface {.cdecl, importc: "IMG_ReadXPMFromArray", dynlib: LibImgName.}


# Individual saving functions

proc imgSavePNG*(surface: PSurface, file: cstring): int {.cdecl, importc: "IMG_SavePNG", dynlib: LibImgName.}

proc imgSavePNG_RW*(surface: PSurface, dst: PRWops, freedst: int): int {.cdecl, importc: "IMG_SavePNG_RW", dynlib: LibImgName.}


# We'll use SDL for reporting errors

proc imgSetError*(fmt: cstring): int {.cdecl, importc: "SDL_SetError", varargs, dynlib: LibName.}


proc imgGetError*(): cstring {.cdecl, importc: "SDL_GetError", dynlib: LibName.}

