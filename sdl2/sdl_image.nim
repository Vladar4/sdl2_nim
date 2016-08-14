#
#  SDL_image:  An example image loading library for use with SDL
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

##  sdl_image.nim
##  =============
##
##  A simple library to load images of various formats as SDL surfaces.

import
  sdl

# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 1

proc linkedVersion*(): ptr Version {.
    cdecl, importc: "IMG_Linked_Version", dynlib: SDL2_IMG_LIB.}
  ##  This procedure gets the version of the dynamically linked SDL_image
  ##  library. It should NOT be used to fill a version structure, instead you
  ##  should use the ``version()`` template.

#type
#  InitFlags* {.size: sizeof(cint).} = enum
#    INIT_JPG = 0x00000001,
#    INIT_PNG = 0x00000002,
#    INIT_TIF = 0x00000004,
#    INIT_WEBP = 0x00000008

# InitFlags
const
  INIT_JPG* = 0x00000001
  INIT_PNG* = 0x00000002
  INIT_TIF* = 0x00000004
  INIT_WEBP* = 0x00000008

proc init*(flags: cint): cint {.
    cdecl, importc: "IMG_Init", dynlib: SDL2_IMG_LIB.}
  ##  Loads dynamic libraries and prepares them for use.
  ##
  ##  ``flags`` should be one or more flags from InitFlags OR'd together.
  ##
  ##  ``Return`` the flags successfully initialized, or `0` on failure.

proc quit*() {.
    cdecl, importc: "IMG_Quit", dynlib: SDL2_IMG_LIB.}
  ##  Unloads libraries loaded with ``init()``.

proc loadTyped_RW*(
    src: ptr RWops; freesrc: cint; kind: cstring): Surface {.
      cdecl, importc: "IMG_LoadTyped_RW", dynlib: SDL2_IMG_LIB.}
  ##  Load an image from an SDL data source.
  ##
  ##  ``kind`` may be one of: "BMP", "GIF", "PNG", etc.
  ##
  ##  If the image format supports a transparent pixel, SDL will set the
  ##  colorkey for the surface.  You can enable RLE acceleration on the
  ##  surface afterwards by calling:
  ##
  ##  .. code-block:: nim
  ##    setColorKey(image, RLEACCEL, image.format.colorkey)

# Convenience procedures

proc load*(file: cstring): Surface {.
    cdecl, importc: "IMG_Load", dynlib: SDL2_IMG_LIB.}

proc load_RW*(src: ptr RWops; freesrc: cint): Surface {.
    cdecl, importc: "IMG_Load_RW", dynlib: SDL2_IMG_LIB.}

when versionAtLeast(2, 0, 0):

  # Load an image directly into a render texture.

  proc loadTexture*(renderer: Renderer; file: cstring): ptr Texture {.
      cdecl, importc: "IMG_LoadTexture", dynlib: SDL2_IMG_LIB.}

  proc loadTexture_RW*(
      renderer: Renderer; src: ptr RWops; freesrc: cint): Texture {.
        cdecl, importc: "IMG_LoadTexture_RW", dynlib: SDL2_IMG_LIB.}

  proc loadTextureTyped_RW*(
      renderer: Renderer; src: ptr RWops; freesrc: cint;
      kind: cstring): Texture {.
        cdecl, importc: "IMG_LoadTextureTyped_RW", dynlib: SDL2_IMG_LIB.}

# Procedures to detect a file type, given a seekable source 

proc isICO*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isICO", dynlib: SDL2_IMG_LIB.}

proc isCUR*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isCUR", dynlib: SDL2_IMG_LIB.}

proc isBMP*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isBMP", dynlib: SDL2_IMG_LIB.}

proc isGIF*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isGIF", dynlib: SDL2_IMG_LIB.}

proc isJPG*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isJPG", dynlib: SDL2_IMG_LIB.}

proc isLBM*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isLBM", dynlib: SDL2_IMG_LIB.}

proc isPCX*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isPCX", dynlib: SDL2_IMG_LIB.}

proc isPNG*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isPNG", dynlib: SDL2_IMG_LIB.}

proc isPNM*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isPNM", dynlib: SDL2_IMG_LIB.}

proc isTIF*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isTIF", dynlib: SDL2_IMG_LIB.}

proc isXCF*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isXCF", dynlib: SDL2_IMG_LIB.}

proc isXPM*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isXPM", dynlib: SDL2_IMG_LIB.}

proc isXV*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isXV", dynlib: SDL2_IMG_LIB.}

proc isWEBP*(src: ptr RWops): cint {.
    cdecl, importc: "IMG_isWEBP", dynlib: SDL2_IMG_LIB.}

# Individual loading procedures

proc loadICO_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadICO_RW", dynlib: SDL2_IMG_LIB.}

proc loadCUR_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadCUR_RW", dynlib: SDL2_IMG_LIB.}

proc loadBMP_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadBMP_RW", dynlib: SDL2_IMG_LIB.}

proc loadGIF_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadGIF_RW", dynlib: SDL2_IMG_LIB.}

proc loadJPG_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadJPG_RW", dynlib: SDL2_IMG_LIB.}

proc loadLBM_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadLBM_RW", dynlib: SDL2_IMG_LIB.}

proc loadPCX_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadPCX_RW", dynlib: SDL2_IMG_LIB.}

proc loadPNG_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadPNG_RW", dynlib: SDL2_IMG_LIB.}

proc loadPNM_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadPNM_RW", dynlib: SDL2_IMG_LIB.}

proc loadTGA_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadTGA_RW", dynlib: SDL2_IMG_LIB.}

proc loadTIF_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadTIF_RW", dynlib: SDL2_IMG_LIB.}

proc loadXCF_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadXCF_RW", dynlib: SDL2_IMG_LIB.}

proc loadXPM_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadXPM_RW", dynlib: SDL2_IMG_LIB.}

proc loadXV_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadXV_RW", dynlib: SDL2_IMG_LIB.}

proc loadWEBP_RW*(src: ptr RWops): Surface {.
    cdecl, importc: "IMG_LoadWEBP_RW", dynlib: SDL2_IMG_LIB.}

proc readXPMFromArray*(xpm: cstringArray): Surface {.
    cdecl, importc: "IMG_ReadXPMFromArray", dynlib: SDL2_IMG_LIB.}

# Individual saving procedures

proc savePNG*(surface: Surface; file: cstring): cint {.
    cdecl, importc: "IMG_SavePNG", dynlib: SDL2_IMG_LIB.}

proc savePNG_RW*(surface: Surface; dst: ptr RWops; freedst: cint): cint {.
    cdecl, importc: "IMG_SavePNG_RW", dynlib: SDL2_IMG_LIB.}

template setError*(fmt: untyped): cint =
  sdl.setError(fmt)

template getError*(): cstring =
  sdl.getError()
