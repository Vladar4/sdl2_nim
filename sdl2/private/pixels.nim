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

##  pixels.nim
##  ==========
##
##  Header for the enumerated pixel format definitions.

# Transparency definitions
#
# These define alpha as the opacity of a surface.
const
  ALPHA_OPAQUE* = 255
  ALPHA_TRANSPARENT* = 0

# Pixel kind
const
  PIXELTYPE_UNKNOWN* = 0
  PIXELTYPE_INDEX1* = 1
  PIXELTYPE_INDEX4* = 2
  PIXELTYPE_INDEX8* = 3
  PIXELTYPE_PACKED8* = 4
  PIXELTYPE_PACKED16* = 5
  PIXELTYPE_PACKED32* = 6
  PIXELTYPE_ARRAYU8* = 7
  PIXELTYPE_ARRAYU16* = 8
  PIXELTYPE_ARRAYU32* = 9
  PIXELTYPE_ARRAYF16* = 10
  PIXELTYPE_ARRAYF32* = 11

# Bitmap pixel order, high bit -> low bit.
const
  BITMAPORDER_NONE* = 0
  BITMAPORDER_4321* = 1
  BITMAPORDER_1234* = 2

# Packed component order, high bit -> low bit.
const
  PACKEDORDER_NONE* = 0
  PACKEDORDER_XRGB* = 1
  PACKEDORDER_RGBX* = 2
  PACKEDORDER_ARGB* = 3
  PACKEDORDER_RGBA* = 4
  PACKEDORDER_XBGR* = 5
  PACKEDORDER_BGRX* = 6
  PACKEDORDER_ABGR* = 7
  PACKEDORDER_BGRA* = 8

# Array component order, low byte -> high byte.
# !!! FIXME: in 2.1, make these not overlap differently with
# !!! FIXME:  PACKEDORDER_*, so we can simplify ISPIXELFORMAT_ALPHA
const
  ARRAYORDER_NONE* = 0
  ARRAYORDER_RGB* = 1
  ARRAYORDER_RGBA* = 2
  ARRAYORDER_ARGB* = 3
  ARRAYORDER_BGR* = 4
  ARRAYORDER_BGRA* = 5
  ARRAYORDER_ABGR* = 6

# Packed component layout.
const
  PACKEDLAYOUT_NONE* = 0
  PACKEDLAYOUT_332* = 1
  PACKEDLAYOUT_4444* = 2
  PACKEDLAYOUT_1555* = 3
  PACKEDLAYOUT_5551* = 4
  PACKEDLAYOUT_565* = 5
  PACKEDLAYOUT_8888* = 6
  PACKEDLAYOUT_2101010* = 7
  PACKEDLAYOUT_1010102* = 8

template definePixelFourCC*(a, b, c, d: untyped): untyped =
  fourCC(ord(a), ord(b), ord(c), ord(d))

template definePixelFormat*(kind, order, layout, bits, bytes: untyped): untyped =
  ((1 shl 28) or ((kind) shl 24) or ((order) shl 20) or
    ((layout) shl 16) or ((bits) shl 8) or ((bytes) shl 0))

template pixelFlag*(x: untyped): untyped =
  (((x) shr 28) and 0x0000000F)

template pixelType*(x: untyped): untyped =
  (((x) shr 24) and 0x0000000F)

template pixelOrder*(x: untyped): untyped =
  (((x) shr 20) and 0x0000000F)

template pixelLayout*(x: untyped): untyped =
  (((x) shr 16) and 0x0000000F)

template bitsPerPixel*(x: untyped): untyped =
  (((x) shr 8) and 0x000000FF)

template bytesPerPixel*(x: untyped): untyped =
  if isPixelFormatFourCC(x):
    if (((x) == PIXELFORMAT_YUY2) or
        ((x) == PIXELFORMAT_UYVY) or
        ((x) == PIXELFORMAT_YVYU)):
      2
    else:
      1
  else:
    (((x) shr 0) and 0x000000FF)

template isPixelFormatIndexed*(format: untyped): untyped =
  (not isPixelFormatFourCC(format) and
    ((pixelType(format) == PIXELTYPE_INDEX1) or
     (pixelType(format) == PIXELTYPE_INDEX4) or
     (pixelType(format) == PIXELTYPE_INDEX8)))

template isPixelFormatPacked*(format: untyped): untyped =
  (not isPixelFormatFourCC(format) and
    ((pixelType(format) == PIXELTYPE_PACKED8) or
     (pixelType(format) == PIXELTYPE_PACKED16) or
     (pixelType(format) == PIXELTYPE_PACKED32)))

template isPixelFormatArray*(format: untyped): untyped =
  (not isPixelFormatFourCC(format) and
    ((pixelType(format) == PIXELTYPE_ARRAYU8) or
     (pixelType(format) == PIXELTYPE_ARRAYU16) or
     (pixelType(format) == PIXELTYPE_ARRAYU32) or
     (pixelType(format) == PIXELTYPE_ARRAYF16) or
     (pixelType(format) == PIXELTYPE_ARRAYF32)))

template isPixelFormatAlpha*(format: untyped): untyped =
  ((isPixelFormatPacked(format) and
    ((pixelOrder(format) == PACKEDORDER_ARGB) or
     (pixelOrder(format) == PACKEDORDER_RGBA) or
     (pixelOrder(format) == PACKEDORDER_ABGR) or
     (pixelOrder(format) == PACKEDORDER_BGRA))) or
    (isPixelFormatArray(format) and
      ((pixelOrder(format) == ARRAYORDER_ARGB) or
       (pixelOrder(format) == ARRAYORDER_RGBA) or
       (pixelOrder(format) == ARRAYORDER_ABGR) or
       (pixelOrder(format) == ARRAYORDER_BGRA))))

template isPixelFormatFourCC*(format: untyped): untyped = ##  \
  ##  The flag is set to `1` because 0x1? is not in the printable ASCII range.
  ((format) and (pixelFlag(format) != 1))

# Note: If you modify this list, update getPixelFormatName()
const
  PIXELFORMAT_UNKNOWN* = 0
  PIXELFORMAT_INDEX1LSB* = definePixelFormat(PIXELTYPE_INDEX1,
      BITMAPORDER_4321, 0, 1, 0)
  PIXELFORMAT_INDEX1MSB* = definePixelFormat(PIXELTYPE_INDEX1,
      BITMAPORDER_1234, 0, 1, 0)
  PIXELFORMAT_INDEX4LSB* = definePixelFormat(PIXELTYPE_INDEX4,
      BITMAPORDER_4321, 0, 4, 0)
  PIXELFORMAT_INDEX4MSB* = definePixelFormat(PIXELTYPE_INDEX4,
      BITMAPORDER_1234, 0, 4, 0)
  PIXELFORMAT_INDEX8* = definePixelFormat(PIXELTYPE_INDEX8,
      0, 0, 8, 1)
  PIXELFORMAT_RGB332* = definePixelFormat(PIXELTYPE_PACKED8,
      PACKEDORDER_XRGB, PACKEDLAYOUT_332, 8, 1)
  PIXELFORMAT_RGB444* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_XRGB, PACKEDLAYOUT_4444, 12, 2)
  PIXELFORMAT_RGB555* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_XRGB, PACKEDLAYOUT_1555, 15, 2)
  PIXELFORMAT_BGR555* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_XBGR, PACKEDLAYOUT_1555, 15, 2)
  PIXELFORMAT_ARGB4444* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_ARGB, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_RGBA4444* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_RGBA, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_ABGR4444* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_ABGR, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_BGRA4444* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_BGRA, PACKEDLAYOUT_4444, 16, 2)
  PIXELFORMAT_ARGB1555* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_ARGB, PACKEDLAYOUT_1555, 16, 2)
  PIXELFORMAT_RGBA5551* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_RGBA, PACKEDLAYOUT_5551, 16, 2)
  PIXELFORMAT_ABGR1555* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_ABGR, PACKEDLAYOUT_1555, 16, 2)
  PIXELFORMAT_BGRA5551* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_BGRA, PACKEDLAYOUT_5551, 16, 2)
  PIXELFORMAT_RGB565* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_XRGB, PACKEDLAYOUT_565, 16, 2)
  PIXELFORMAT_BGR565* = definePixelFormat(PIXELTYPE_PACKED16,
      PACKEDORDER_XBGR, PACKEDLAYOUT_565, 16, 2)
  PIXELFORMAT_RGB24* = definePixelFormat(PIXELTYPE_ARRAYU8,
      ARRAYORDER_RGB, 0, 24, 3)
  PIXELFORMAT_BGR24* = definePixelFormat(PIXELTYPE_ARRAYU8,
      ARRAYORDER_BGR, 0, 24, 3)
  PIXELFORMAT_RGB888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_XRGB, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_RGBX8888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_RGBX, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_BGR888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_XBGR, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_BGRX8888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_BGRX, PACKEDLAYOUT_8888, 24, 4)
  PIXELFORMAT_ARGB8888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_ARGB, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_RGBA8888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_RGBA, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_ABGR8888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_ABGR, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_BGRA8888* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_BGRA, PACKEDLAYOUT_8888, 32, 4)
  PIXELFORMAT_ARGB2101010* = definePixelFormat(PIXELTYPE_PACKED32,
      PACKEDORDER_ARGB, PACKEDLAYOUT_2101010, 32, 4)
  PIXELFORMAT_YV12* = definePixelFourCC('Y', 'V', '1', '2') ##  \
    ##  Planar mode: Y + V + U  (3 planes)
  PIXELFORMAT_IYUV* = definePixelFourCC('I', 'Y', 'U', 'V') ##  \
    ##  Planar mode: Y + U + V  (3 planes)
  PIXELFORMAT_YUY2* = definePixelFourCC('Y', 'U', 'Y', '2') ##  \
    ##  Packed mode: Y0+U0+Y1+V0 (1 plane)
  PIXELFORMAT_UYVY* = definePixelFourCC('U', 'Y', 'V', 'Y') ##  \
    ##  Packed mode: U0+Y0+V0+Y1 (1 plane)
  PIXELFORMAT_YVYU* = definePixelFourCC('Y', 'V', 'Y', 'U') ##  \
    ##  Packed mode: Y0+V0+Y1+U0 (1 plane)
  PIXELFORMAT_NV12* = definePixelFourCC('N', 'V', '1', '2') ##  \
    ##  Planar mode: Y + U/V interleaved (2 planes)
  PIXELFORMAT_NV21* = definePixelFourCC('N', 'V', '2', '1') ##  \
    ##  Planar mode: Y + V/U interleaved (2 planes)

# Aliases for RGBA byte arrays of color data, for the current platform.
when cpuEndian == bigEndian:
  const
    PIXELFORMAT_RGBA32* = PIXELFORMAT_RGBA8888
    PIXELFORMAT_ARGB32* = PIXELFORMAT_ARGB8888
    PIXELFORMAT_BGRA32* = PIXELFORMAT_BGRA8888
    PIXELFORMAT_ABGR32* = PIXELFORMAT_ABGR8888
else:
  const
    PIXELFORMAT_RGBA32* = PIXELFORMAT_ABGR8888
    PIXELFORMAT_ARGB32* = PIXELFORMAT_BGRA8888
    PIXELFORMAT_BGRA32* = PIXELFORMAT_ARGB8888
    PIXELFORMAT_ABGR32* = PIXELFORMAT_RGBA8888

type
  Color* = object
    r*: uint8
    g*: uint8
    b*: uint8
    a*: uint8

  Colour* = Color

type
  Palette* = object
    ncolors*: cint
    colors*: ptr Color
    version*: uint32
    refcount*: cint

type
  PixelFormat* = object ##  \
    ##  ``Note:`` Everything in the pixel format object is read-only.
    format*: uint32
    palette*: ptr Palette
    BitsPerPixel*: uint8
    BytesPerPixel*: uint8
    padding*: array[2, uint8]
    Rmask*: uint32
    Gmask*: uint32
    Bmask*: uint32
    Amask*: uint32
    Rloss*: uint8
    Gloss*: uint8
    Bloss*: uint8
    Aloss*: uint8
    Rshift*: uint8
    Gshift*: uint8
    Bshift*: uint8
    Ashift*: uint8
    refcount*: cint
    next*: ptr PixelFormat

proc getPixelFormatName*(format: uint32): cstring {.
    cdecl, importc: "SDL_GetPixelFormatName", dynlib: SDL2_LIB.}
  ##  Get the human readable name of a pixel format.

proc pixelFormatEnumToMasks*(
    format: uint32; bpp: ptr cint;
    rMask: ptr uint32; gMask: ptr uint32;
    bMask: ptr uint32; aMask: ptr uint32): bool {.
      cdecl, importc: "SDL_PixelFormatEnumToMasks", dynlib: SDL2_LIB.}
  ##  Convert one of the enumerated pixel formats to a bpp and RGBA masks.
  ##
  ##  ``Return`` `true`, or `false` if the conversion wasn't possible.
  ##
  ##  See also:
  ##
  ##  ``masksToPixelFormatEnum()``

proc masksToPixelFormatEnum*(bpp: cint;
    rMask: uint32; gMask: uint32; bMask: uint32; aMask: uint32): uint32 {.
      cdecl, importc: "SDL_MasksToPixelFormatEnum", dynlib: SDL2_LIB.}
  ##  Convert a bpp and RGBA masks to an enumerated pixel format.
  ##
  ##  ``Return`` the pixel format, or PIXELFORMAT_UNKNOWN if the conversion
  ##  wasn't possible.
  ##
  ##  See also:
  ##
  ##  ``pixelFormatEnumToMasks()``

proc allocFormat*(pixel_format: uint32): ptr PixelFormat {.
    cdecl, importc: "SDL_AllocFormat", dynlib: SDL2_LIB.}
  ##  Create an PixelFormat object from a pixel format enum.

proc freeFormat*(format: ptr PixelFormat) {.
    cdecl, importc: "SDL_FreeFormat", dynlib: SDL2_LIB.}
  ##  Free an PixelFormat object.

proc allocPalette*(ncolors: cint): ptr Palette {.
    cdecl, importc: "SDL_AllocPalette", dynlib: SDL2_LIB.}
  ##  Create a palette structure with the specified number of color entries.
  ##
  ##  ``Return`` a new palette, or `nil` if there wasn't enough memory.
  ##
  ##  ``Note:`` The palette entries are initialized to white.
  ##
  ##  See also:
  ##
  ##  ``freePalette()``

proc setPixelFormatPalette*(
    format: ptr PixelFormat; palette: ptr Palette): cint {.
      cdecl, importc: "SDL_SetPixelFormatPalette", dynlib: SDL2_LIB.}
  ##  Set the palette for a pixel format object.

proc setPaletteColors*(
    palette: ptr Palette; colors: ptr Color;
    firstcolor: cint; ncolors: cint): cint {.
      cdecl, importc: "SDL_SetPaletteColors", dynlib: SDL2_LIB.}
  ##  Set a range of colors in a palette.
  ##
  ##  ``palette``    The palette to modify.
  ##  ``colors``     An array of colors to copy into the palette.
  ##  ``firstcolor`` The index of the first palette entry to modify.
  ##  ``ncolors``    The number of entries to modify.
  ##
  ##  ``Return`` `0` on success, or `-1` if not all of the colors could be set.

proc freePalette*(palette: ptr Palette) {.
    cdecl, importc: "SDL_FreePalette", dynlib: SDL2_LIB.}
  ##  Free a palette created with allocPalette().
  ##
  ##  See also:
  ##
  ##  ``allocPalette()``

proc mapRGB*(format: ptr PixelFormat;
    r: uint8; g: uint8; b: uint8): uint32 {.
      cdecl, importc: "SDL_MapRGB", dynlib: SDL2_LIB.}
  ##  Maps an RGB triple to an opaque pixel value for a given pixel format.
  ##
  ##  See also:
  ##
  ##  ``mapRGBA()``

proc mapRGB*(format: ptr PixelFormat, color: Color): uint32 {.inline.} =
  return mapRGB(format, color.r, color.g, color.b)

proc mapRGBA*(format: ptr PixelFormat;
    r: uint8; g: uint8; b: uint8; a: uint8): uint32 {.
      cdecl, importc: "SDL_MapRGBA", dynlib: SDL2_LIB.}
  ##  Maps an RGBA quadruple to a pixel value for a given pixel format.
  ##
  ##  See also:
  ##
  ##  ``mapRGB()``

proc mapRGBA*(format: ptr PixelFormat, color: Color): uint32 {.inline.} =
  return mapRGBA(format, color.r, color.g, color.b, color.a)

proc getRGB*(pixel: uint32; format: ptr PixelFormat;
    r: ptr uint8; g: ptr uint8; b: ptr uint8) {.
      cdecl, importc: "SDL_GetRGB", dynlib: SDL2_LIB.}
  ##  Get the RGB components from a pixel of the specified format.
  ##
  ##  See also:
  ##
  ##  ``getRGBA()``

proc getRGB*(pixel: uint32, format: ptr PixelFormat): Color {.inline.} =
  getRGB(pixel, format,
    addr(result.r), addr(result.g), addr(result.b))

proc getRGBA*(pixel: uint32; format: ptr PixelFormat;
    r: ptr uint8; g: ptr uint8; b: ptr uint8; a: ptr uint8) {.
      cdecl, importc: "SDL_GetRGBA", dynlib: SDL2_LIB.}
  ##  Get the RGBA components from a pixel of the specified format.
  ##
  ##  See also:
  ##
  ##  ``getRGB()``

proc getRGBA*(pixel: uint32, format: ptr PixelFormat): Color {.inline.} =
  getRGBA(pixel, format,
    addr(result.r), addr(result.g), addr(result.b), addr(result.a))

proc calculateGammaRamp*(gamma: cfloat; ramp: ptr uint16) {.
    cdecl, importc: "SDL_CalculateGammaRamp", dynlib: SDL2_LIB.}
  ##  Calculate a 256 entry gamma ramp for a gamma value.
