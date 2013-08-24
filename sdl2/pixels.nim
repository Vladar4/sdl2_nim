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
# Header for the enumerated pixel format definitions.
#


#
# Transparency definitions
#
# These define alpha as the opacity of a surface.
#
const
  ALPHA_OPAQUE* = 255
  ALPHA_TRANSPARENT* = 0


type
  TPixelType* = enum ## Pixel type
    PIXELTYPE_UNKNOWN,
    PIXELTYPE_INDEX1,
    PIXELTYPE_INDEX4,
    PIXELTYPE_INDEX8,
    PIXELTYPE_PACKED8,
    PIXELTYPE_PACKED16,
    PIXELTYPE_PACKED32,
    PIXELTYPE_ARRAYU8,
    PIXELTYPE_ARRAYU16,
    PIXELTYPE_ARRAYU32,
    PIXELTYPE_ARRAYF16,
    PIXELTYPE_ARRAYF32


  TBitmapOrder* = enum ## Bitmap pixel order, high bit -> low bit.
    BITMAPORDER_NONE,
    BITMAPORDER_4321,
    BITMAPORDER_1234


  TPackedOrder* = enum ## Packed component order, high bit -> low bit.
    PACKEDORDER_NONE,
    PACKEDORDER_XRGB,
    PACKEDORDER_RGBX,
    PACKEDORDER_ARGB,
    PACKEDORDER_RGBA,
    PACKEDORDER_XBGR,
    PACKEDORDER_BGRX,
    PACKEDORDER_ABGR,
    PACKEDORDER_BGRA


  TArrayOrder* = enum ## Array component order, low byte -> high byte.
    ARRAYORDER_NONE,
    ARRAYORDER_RGB,
    ARRAYORDER_RGBA,
    ARRAYORDER_ARGB,
    ARRAYORDER_BGR,
    ARRAYORDER_BGRA,
    ARRAYORDER_ABGR


  TPackedLayout* = enum ## Packed component layout.
    PACKEDLAYOUT_NONE,
    PACKEDLAYOUT_332,
    PACKEDLAYOUT_4444,
    PACKEDLAYOUT_1555,
    PACKEDLAYOUT_5551,
    PACKEDLAYOUT_565,
    PACKEDLAYOUT_8888,
    PACKEDLAYOUT_2101010,
    PACKEDLAYOUT_1010102


template definePixelFourCC*(a, b, c, d: Uint8): Uint32 =
  fourCC(a, b, c, d)


template definePixelFourCC*(a, b, c, d: char): Uint32 =
  fourCC(ord(a), ord(b), ord(c), ord(d))


template definePixelFormat*(kind, order, layout, bits, bytes: Uint8): Uint32 =
  ((Uint32(1) shl 28) or
   (Uint32(kind) shl 24) or
   (Uint32(order) shl 20) or
   (Uint32(layout) shl 16) or
   (Uint32(bits) shl 8) or
   (Uint32(bytes) shl 0))


template definePixelFormat*(kind: TPixelType,
                            order: TPackedOrder,
                            layout: TPackedLayout,
                            bits, bytes: Uint8): Uint32 =
  definePixelFormat(Uint8(kind), Uint8(order), Uint8(layout), bits, bytes)


template definePixelFormat*(kind: TPixelType,
                            order: TBitmapOrder,
                            layout: TPackedLayout,
                            bits, bytes: Uint8): Uint32 =
  definePixelFormat(Uint8(kind), Uint8(order), Uint8(layout), bits, bytes)


template definePixelFormat*(kind: TPixelType,
                            order: TBitmapOrder,
                            layout, bits, bytes: Uint8): Uint32 =
  definePixelFormat(Uint8(kind), Uint8(order), layout, bits, bytes)


template definePixelFormat*(kind: TPixelType,
                            order: TArrayOrder,
                            layout, bits, bytes: Uint8): Uint32 =
  definePixelFormat(Uint8(kind), Uint8(order), layout, bits, bytes)


template definePixelFormat*(kind: TPixelType,
                            order, layout, bits, bytes: Uint8): Uint32 =
  definePixelFormat(Uint8(kind), order, layout, bits, bytes)


template pixelFlag*(x: Uint32): Uint8 =
  ((x shr 28) and 0x0F)


template pixelType*(x: Uint32): Uint8 =
  ((x shr 24) and 0x0F)


template pixelOrder*(x: Uint32): Uint8 =
  ((x shr 20) and 0x0F)


template pixelLayout*(x: Uint32): Uint8 =
  ((x shr 16) and 0x0F)


template bitsPerPixel*(x: Uint32): Uint8 =
  ((x shr 8) and 0xFF)


# Note: If you modify this list, update SDL_GetPixelFormatName()
const
  PIXELFORMAT_UNKNOWN* = 0
  PIXELFORMAT_INDEX1LSB* = definePixelFormat(PIXELTYPE_INDEX1, BITMAPORDER_4321, 0, 1, 0)
  PIXELFORMAT_INDEX1MSB* = definePixelFormat(PIXELTYPE_INDEX1, BITMAPORDER_1234, 0, 1, 0)
  PIXELFORMAT_INDEX4LSB* = definePixelFormat(PIXELTYPE_INDEX4, BITMAPORDER_4321, 0, 4, 0)
  PIXELFORMAT_INDEX4MSB* = definePixelFormat(PIXELTYPE_INDEX4, BITMAPORDER_1234, 0, 4, 0)
  PIXELFORMAT_INDEX8* = definePixelFormat(PIXELTYPE_INDEX8, 0, 0, 8, 1)
  PIXELFORMAT_RGB332* = definePixelFormat(PIXELTYPE_PACKED8, PACKEDORDER_XRGB, PACKEDLAYOUT_332, 8, 1)
  PIXELFORMAT_RGB444* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_4444, 12, 2)
  PIXELFORMAT_RGB555* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_1555, 15, 2)
  PIXELFORMAT_BGR555* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_1555, 15, 2)
  PIXELFORMAT_ARGB4444* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_ARGB, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_RGBA4444* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_RGBA, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_ABGR4444* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_ABGR, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_BGRA4444* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_BGRA, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_ARGB1555* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_ARGB, PACKEDLAYOUT_1555, 16, 2)
  PIXELFORMAT_RGBA5551* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_RGBA, PACKEDLAYOUT_5551, 16, 2)
  PIXELFORMAT_ABGR1555* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_ABGR, PACKEDLAYOUT_1555, 16, 2)
  PIXELFORMAT_BGRA5551* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_BGRA, PACKEDLAYOUT_5551, 16, 2)
  PIXELFORMAT_RGB565* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_XRGB, PACKEDLAYOUT_565, 16, 2)
  PIXELFORMAT_BGR565* = definePixelFormat(PIXELTYPE_PACKED16, PACKEDORDER_XBGR, PACKEDLAYOUT_565, 16, 2)
  PIXELFORMAT_RGB24* = definePixelFormat(PIXELTYPE_ARRAYU8, ARRAYORDER_RGB, 0, 24, 3)
  PIXELFORMAT_BGR24* = definePixelFormat(PIXELTYPE_ARRAYU8, ARRAYORDER_BGR, 0, 24, 3)
  PIXELFORMAT_RGB888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_XRGB, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_RGBX8888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_RGBX, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_BGR888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_XBGR, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_BGRX8888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_BGRX, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_ARGB8888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_ARGB, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_RGBA8888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_RGBA, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_ABGR8888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_ABGR, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_BGRA8888* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_BGRA, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_ARGB2101010* = definePixelFormat(PIXELTYPE_PACKED32, PACKEDORDER_ARGB, PACKEDLAYOUT_2101010, 32, 4)
  PIXELFORMAT_YV12* = definePixelFourCC('Y', 'V', '1', '2') ## Planar mode: Y + V + U  (3 planes)
  PIXELFORMAT_IYUV* = definePixelFourCC('I', 'Y', 'U', 'V') ## Planar mode: Y + U + V  (3 planes)
  PIXELFORMAT_YUY2* = definePixelFourCC('Y', 'U', 'Y', '2') ## Packed mode: Y0+U0+Y1+V0 (1 plane)
  PIXELFORMAT_UYVY* = definePixelFourCC('U', 'Y', 'V', 'Y') ## Packed mode: U0+Y0+V0+Y1 (1 plane)
  PIXELFORMAT_YVYU* = definePixelFourCC('Y', 'V', 'Y', 'U')  ## Packed mode: Y0+V0+Y1+U0 (1 plane)


template isPixelFormatFourCC*(format: Uint32): bool =
  ## The flag is set to 1 because 0x1? is not in the printable ASCII range
  ((format != 0) and (pixelFlag(format) != 1))


template isPixelFormatIndexed*(format: Uint32): bool =
  (not isPixelFormatFourCC(format) and
    ((pixelType(format) == PIXELTYPE_INDEX1) or
     (pixelType(format) == PIXELTYPE_INDEX4) or
     (pixelType(format) == PIXELTYPE_INDEX8)))


template isPixelFormatAlpha*(format: Uint32): bool =
  (not SDL_ISPIXELFORMAT_FOURCC(format) and
   ((pixelOrder(format) == PACKEDORDER_ARGB) or
    (pixelOrder(format) == PACKEDORDER_RGBA) or
    (pixelOrder(format) == PACKEDORDER_ABGR) or
    (pixelOrder(format) == PACKEDORDER_BGRA)))


proc bytesPerPixel*(x: Uint32): Uint8 {.inline.} =
  if isPixelFormatFourCC(x):
    if (x == PIXELFORMAT_YUY2) or (x == PIXELFORMAT_UYVY) or (x == PIXELFORMAT_YVYU):
      return 2
    else:
      return 1
  else:
    return ((x shr 0) and 0xFF)


type
  PColour* = ptr TColor
  PColor* = ptr TColor
  TColour* = TColor
  TColor*{.bycopy.} = object
    r*, g*, b*, a*: Uint8


  PPalette* = ptr TPalette
  TPalette*{.bycopy.} = object
    ncolors*: int
    colors*: ptr TColor
    version*: Uint32
    refcount*: int


  PPixelFormat* = ptr TPixelFormat
  TPixelFormat*{.bycopy.} = object
    ## Everything in the pixel format structure is read-only.
    format*: Uint32
    palette*: ptr TPalette
    bitsPerPixel*, bytesPerPixel*: Uint8
    padding*: array [0..1, Uint8]
    rMask*, gMask*, bMask*, aMask*: Uint32
    rLoss*, gLoss*, bLoss*, Aloss*: Uint8
    rShift*, gShift*, bShift*, aShift*: Uint8
    refcount*: int
    next*: pointer


proc getPixelFormatName*(format: Uint32): cstring {.cdecl, importc: "SDL_GetPixelFormatName", dynlib: LibName.}
  ## Get the human readable name of a pixel format

proc pixelFormatEnumToMasks*(format: Uint32, bpp: ptr int,
  rMask, gMask, bMask, aMask: ptr Uint32): bool {.cdecl, importc: "SDL_PixelFormatEnumToMasks", dynlib: LibName.}
  ## Convert one of the enumerated pixel formats to a bpp and RGBA masks.
  ##
  ## Return TRUE, or FALSE if the conversion wasn't possible.
  ##
  ## See also: masksToPixelFormatEnum()


proc masksToPixelFormatEnum*(bpp: int, rMask, gMask, bMask, aMask: Uint32): Uint32 {.cdecl, importc: "SDL_MasksToPixelFormatEnum", dynlib: LibName.}
  ## Convert a bpp and RGBA masks to an enumerated pixel format.
  ##
  ## Return the pixel format, or PIXELFORMAT_UNKNOWN if the conversion
  ## wasn't possible.
  ##
  ## See also: pixelFormatEnumToMasks()


proc allocFormat*(pixel_format: Uint32): PPixelFormat {.cdecl, importc: "SDL_AllocFormat", dynlib: LibName.}
  ## Create an PPixelFormat structure from a pixel format enum.


proc freeFormat*(format: PPixelFormat) {.cdecl, importc: "SDL_FreeFormat", dynlib: LibName.}
  ## Free an PPixelFormat structure.


proc allocPalette*(ncolors: int): PPalette {.cdecl, importc: "SDL_AllocPalette", dynlib: LibName.}
  ## Create a palette structure with the specified number of color entries.
  ##
  ## Return A new palette, or nil if there wasn't enough memory.
  ##
  ## The palette entries are initialized to white.
  ##
  ## See also: freePalette()


proc setPixelFormatPalette*(format: PPixelFormat, palette: PPalette): int {.cdecl, importc: "SDL_SetPixelFormatPalette", dynlib: LibName.}
  ## Set the palette for a pixel format structure.


proc setPaletteColors*(palette: PPalette, colors: PColor, firstcolor, ncolors: int): int {.cdecl, importc: "SDL_SetPaletteColors", dynlib: LibName.}
  ## Set a range of colors in a palette.
  ##
  ## ``palette`` The palette to modify.
  ##
  ## ``colors`` An array of colors to copy into the palette.
  ##
  ## ``firstcolor`` The index of the first palette entry to modify.
  ##
  ## ``ncolors`` The number of entries to modify.
  ##
  ## Return 0 on success, or -1 if not all of the colors could be set.


proc freePalette*(palette: PPalette) {.cdecl, importc: "SDL_FreePalette", dynlib: LibName.}
  ## Free a palette created with allocPalette().
  ##
  ## allocPalette()


proc mapRGB*(format: PPixelFormat, r, g, b: Uint8): Uint32 {.cdecl, importc: "SDL_MapRGB", dynlib: LibName.}
  ## Maps an RGB triple to an opaque pixel value for a given pixel format.
  ##
  ## See also: mapRGBA


proc mapRGBA*(format: PPixelFormat, r, g, b, a: Uint8): Uint32 {.cdecl, importc: "SDL_MapRGBA", dynlib: LibName.}
  ## Maps an RGBA quadruple to a pixel value for a given pixel format.
  ##
  ## See also: mapRGB


proc getRGB*(pixel: Uint32, format: PPixelFormat, r, g , b: ptr Uint8) {.cdecl, importc: "SDL_GetRGB", dynlib: LibName.}
  ## Get the RGB components from a pixel of the specified format.
  ##
  ## See also: getRGBA


proc getRGBA*(pixel: Uint32, format: PPixelFormat, r, g, b, a: ptr Uint8) {.cdecl, importc: "SDL_GetRGBA", dynlib: LibName.}
  ## Get the RGBA components from a pixel of the specified format.
  ##
  ## See also: getRGB

proc calculateGammaRamp*(gamma: float, ramp: ptr Uint16) {.cdecl, importc: "SDL_CalculateGammaPamp", dynlib: LibName.}
  ## Calculate a 256 entry gamma ramp for a gamma value.

