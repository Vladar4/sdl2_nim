#
#  SDL_ttf:  A companion library to SDL for working with TrueType (tm) fonts
#  Copyright (C) 2001-2013 Sam Lantinga <slouken@libsdl.org>
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
# This library is a wrapper around the excellent FreeType 2.0 library,
#   available at:
#    http://www.freetype.org/
#

##  sdl_ttf.nim
##  ===========
##
##  TrueType font rendering library.

##  ``Note:``
##  In many places, SDL_ttf will say "glyph" when it means "code point."
##  Unicode is hard, we learn as we go, and we apologize for adding to the
##  confusion.

import
  sdl

# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 14

proc linkedVersion*(): ptr Version {.
    cdecl, importc: "TTF_Linked_Version", dynlib: SDL2_TTF_LIB.}
  ##  This procedure gets the version of the dynamically linked SDL_ttf library.
  ##  It should NOT be used to fill a version structure, instead you should
  ##  use the ``version()`` template.

# ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark) 
const
  UNICODE_BOM_NATIVE* = 0x0000FEFF
  UNICODE_BOM_SWAPPED* = 0x0000FFFE

proc byteSwappedUNICODE*(swapped: cint) {.
    cdecl, importc: "TTF_ByteSwappedUNICODE", dynlib: SDL2_TTF_LIB.}
  ##  This procedure tells the library whether UNICODE text is generally
  ##  byteswapped.  A UNICODE BOM character in a string will override
  ##  this setting for the remainder of that string.

type
  Font* = pointer ##  The internal structure containing font information

proc init*(): cint {.
    cdecl, importc: "TTF_Init", dynlib: SDL2_TTF_LIB.}
  ##  Initialize the TTF engine.
  ##
  ##  ``Return`` `0` if successful, `-1` on error.

proc openFont*(file: cstring; ptsize: cint): Font {.
    cdecl, importc: "TTF_OpenFont", dynlib: SDL2_TTF_LIB.}
  ##  Open a font file and create a font of the specified point size.
  ##  Some .fon fonts will have several sizes embedded in the file, so the
  ##  point size becomes the index of choosing which size.  If the value
  ##  is too high, the last indexed size will be the default.
  ##
  ##  See also:
  ##
  ##  ``openFontIndex()``
  ##
  ##  ``openFontRW()``
  ##
  ##  ``openFontIndexRW()``

proc openFontIndex*(file: cstring; ptsize: cint; index: clong): Font {.
    cdecl, importc: "TTF_OpenFontIndex", dynlib: SDL2_TTF_LIB.}

proc openFontRW*(src: ptr RWops; freesrc: cint; ptsize: cint): Font {.
    cdecl, importc: "TTF_OpenFontRW", dynlib: SDL2_TTF_LIB.}

proc openFontIndexRW*(
    src: ptr RWops; freesrc: cint; ptsize: cint; index: clong): Font {.
      cdecl, importc: "TTF_OpenFontIndexRW", dynlib: SDL2_TTF_LIB.}

# Set and retrieve the font style

const
  STYLE_NORMAL* = 0x00000000
  STYLE_BOLD* = 0x00000001
  STYLE_ITALIC* = 0x00000002
  STYLE_UNDERLINE* = 0x00000004
  STYLE_STRIKETHROUGH* = 0x00000008

proc getFontStyle*(font: Font): cint {.
    cdecl, importc: "TTF_GetFontStyle", dynlib: SDL2_TTF_LIB.}

proc setFontStyle*(font: Font; style: cint) {.
    cdecl, importc: "TTF_SetFontStyle", dynlib: SDL2_TTF_LIB.}

proc getFontOutline*(font: Font): cint {.
    cdecl, importc: "TTF_GetFontOutline", dynlib: SDL2_TTF_LIB.}

proc setFontOutline*(font: Font; outline: cint) {.
    cdecl, importc: "TTF_SetFontOutline", dynlib: SDL2_TTF_LIB.}

# Set and retrieve FreeType hinter settings

const
  HINTING_NORMAL* = 0
  HINTING_LIGHT* = 1
  HINTING_MONO* = 2
  HINTING_NONE* = 3

proc getFontHinting*(font: Font): cint {.
    cdecl, importc: "TTF_GetFontHinting", dynlib: SDL2_TTF_LIB.}

proc setFontHinting*(font: Font; hinting: cint) {.
    cdecl, importc: "TTF_SetFontHinting", dynlib: SDL2_TTF_LIB.}

proc fontHeight*(font: Font): cint {.
    cdecl, importc: "TTF_FontHeight", dynlib: SDL2_TTF_LIB.}
  ##  Get the total height of the font - usually equal to point size.


proc fontAscent*(font: Font): cint {.
    cdecl, importc: "TTF_FontAscent", dynlib: SDL2_TTF_LIB.}
  ##  Get the offset from the baseline to the top of the font.
  ##
  ##  This is a positive value, relative to the baseline.

proc fontDescent*(font: Font): cint {.
    cdecl, importc: "TTF_FontDescent", dynlib: SDL2_TTF_LIB.}
  ##  Get the offset from the baseline to the bottom of the font.
  ##
  ##  This is a negative value, relative to the baseline.

proc fontLineSkip*(font: Font): cint {.
    cdecl, importc: "TTF_FontLineSkip", dynlib: SDL2_TTF_LIB.}
  ##  Get the recommended spacing between lines of text for this font.

proc getFontKerning*(font: Font): cint {.
    cdecl, importc: "TTF_GetFontKerning", dynlib: SDL2_TTF_LIB.}
  ##  Get whether or not kerning is allowed for this font.

proc setFontKerning*(font: Font; allowed: cint) {.
    cdecl, importc: "TTF_SetFontKerning", dynlib: SDL2_TTF_LIB.}
  ##  Set whether or not kerning is allowed for this font.

proc fontFaces*(font: Font): clong {.
    cdecl, importc: "TTF_FontFaces", dynlib: SDL2_TTF_LIB.}
  ##  Get the number of faces of the font.

proc fontFaceIsFixedWidth*(font: Font): cint {.
    cdecl, importc: "TTF_FontFaceIsFixedWidth", dynlib: SDL2_TTF_LIB.}
  ##  Get the font face attributes, if any.

proc fontFaceFamilyName*(font: Font): cstring {.
    cdecl, importc: "TTF_FontFaceFamilyName", dynlib: SDL2_TTF_LIB.}

proc fontFaceStyleName*(font: Font): cstring {.
    cdecl, importc: "TTF_FontFaceStyleName", dynlib: SDL2_TTF_LIB.}

proc glyphIsProvided*(font: Font; ch: uint16): cint {.
    cdecl, importc: "TTF_GlyphIsProvided", dynlib: SDL2_TTF_LIB.}
  ##  Check wether a glyph is provided by the font or not.

proc glyphMetrics*(
    font: Font; ch: uint16;
    minx: ptr cint; maxx: ptr cint;
    miny: ptr cint; maxy: ptr cint;
    advance: ptr cint): cint {.
      cdecl, importc: "TTF_GlyphMetrics", dynlib: SDL2_TTF_LIB.}
  ##  Get the metrics (dimensions) of a glyph.
  ##
  ##  To understand what these metrics mean, here is a useful link:
  ##
  ##  http://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html

proc sizeText*(
    font: Font; text: cstring; w: ptr cint; h: ptr cint): cint {.
      cdecl, importc: "TTF_SizeText", dynlib: SDL2_TTF_LIB.}
  ##  Get the dimensions of a rendered string of text.
  ##
  ##  See also:
  ##
  ##  ``sizeUTF8()``
  ##
  ##  ``sizeUNICODE()``

proc sizeUTF8*(
    font: Font; text: cstring; w: ptr cint; h: ptr cint): cint {.
      cdecl, importc: "TTF_SizeUTF8", dynlib: SDL2_TTF_LIB.}

proc sizeUNICODE*(
    font: Font; text: ptr uint16; w: ptr cint; h: ptr cint): cint {.
      cdecl, importc: "TTF_SizeUNICODE", dynlib: SDL2_TTF_LIB.}

proc renderText_Solid*(
    font: Font; text: cstring; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderText_Solid", dynlib: SDL2_TTF_LIB.}
  ##  Create an 8-bit palettized surface and render the given text at
  ##  fast quality with the given font and color.  The 0 pixel is the
  ##  colorkey, giving a transparent background, and the 1 pixel is set
  ##  to the text color.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.
  ##
  ##  See also:
  ##
  ##  ``renderUTF8_Solid()``
  ##
  ##  ``renderUNICODE_Solid()``

proc renderUTF8_Solid*(
    font: Font; text: cstring; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderUTF8_Solid", dynlib: SDL2_TTF_LIB.}

proc renderUNICODE_Solid*(
    font: Font; text: ptr uint16; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderUNICODE_Solid", dynlib: SDL2_TTF_LIB.}

proc renderGlyph_Solid*(
    font: Font; ch: uint16; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderGlyph_Solid", dynlib: SDL2_TTF_LIB.}
  ##  Create an 8-bit palettized surface and render the given glyph at
  ##  fast quality with the given font and color.  The 0 pixel is the
  ##  colorkey, giving a transparent background, and the 1 pixel is set
  ##  to the text color.
  ##
  ##  The glyph is rendered without any padding or centering in the X
  ##  direction, and aligned normally in the Y direction.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.

proc renderText_Shaded*(
    font: Font; text: cstring; fg: Color; bg: Color): Surface {.
      cdecl, importc: "TTF_RenderText_Shaded", dynlib: SDL2_TTF_LIB.}
  ##  Create an 8-bit palettized surface and render the given text at
  ##  high quality with the given font and colors. The 0 pixel is background,
  ##  while other pixels have varying degrees of the foreground color.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.
  ##
  ##  See also:
  ##
  ##  ``renderUTF8_Shaded()``
  ##
  ##  ``renderUNICODE_Shaded()``

proc renderUTF8_Shaded*(
    font: Font; text: cstring; fg: Color; bg: Color): Surface {.
      cdecl, importc: "TTF_RenderUTF8_Shaded", dynlib: SDL2_TTF_LIB.}

proc renderUNICODE_Shaded*(
    font: Font; text: ptr uint16; fg: Color; bg: Color): Surface {.
      cdecl, importc: "TTF_RenderUNICODE_Shaded", dynlib: SDL2_TTF_LIB.}

proc renderGlyph_Shaded*(
    font: Font; ch: uint16; fg: Color; bg: Color): Surface {.
      cdecl, importc: "TTF_RenderGlyph_Shaded", dynlib: SDL2_TTF_LIB.}
  ##  Create an 8-bit palettized surface and render the given glyph at
  ##  high quality with the given font and colors.  The 0 pixel is background,
  ##  while other pixels have varying degrees of the foreground color.
  ##
  ##  The glyph is rendered without any padding or centering in the X
  ##  direction, and aligned normally in the Y direction.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.

proc renderText_Blended*(
    font: Font; text: cstring; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderText_Blended", dynlib: SDL2_TTF_LIB.}
  ##  Create a 32-bit ARGB surface and render the given text at high quality,
  ##  using alpha blending to dither the font with the given color.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.
  ##
  ##  See also:
  ##
  ##  ``renderUTF8_Blended()``
  ##
  ##  ``renderUNICODE_Blended()``

proc renderUTF8_Blended*(
    font: Font; text: cstring; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderUTF8_Blended", dynlib: SDL2_TTF_LIB.}

proc renderUNICODE_Blended*(
    font: Font; text: ptr uint16; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderUNICODE_Blended", dynlib: SDL2_TTF_LIB.}

proc renderText_Blended_Wrapped*(
    font: Font; text: cstring; fg: Color;
    wrapLength: uint32): Surface {.
      cdecl, importc: "TTF_RenderText_Blended_Wrapped", dynlib: SDL2_TTF_LIB.}
  ##  Create a 32-bit ARGB surface and render the given text at high quality,
  ##  using alpha blending to dither the font with the given color.
  ##  Text is wrapped to multiple lines on line endings and on word boundaries
  ##  if it extends beyond wrapLength in pixels.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.
  ##
  ##  See also:
  ##
  ##  ``renderUTF8_Blended_Wrapped()``
  ##
  ##  ``renderUNICODE_Blended_Wrapped()``

proc renderUTF8_Blended_Wrapped*(
    font: Font; text: cstring; fg: Color;
    wrapLength: uint32): Surface {.
      cdecl, importc: "TTF_RenderUTF8_Blended_Wrapped", dynlib: SDL2_TTF_LIB.}

proc renderUNICODE_Blended_Wrapped*(
    font: Font; text: ptr uint16; fg: Color;
    wrapLength: uint32): Surface {.
    cdecl, importc: "TTF_RenderUNICODE_Blended_Wrapped", dynlib: SDL2_TTF_LIB.}

proc renderGlyph_Blended*(
    font: Font; ch: uint16; fg: Color): Surface {.
      cdecl, importc: "TTF_RenderGlyph_Blended", dynlib: SDL2_TTF_LIB.}
  ##  Create a 32-bit ARGB surface and render the given glyph at high quality,
  ##  using alpha blending to dither the font with the given color.
  ##  The glyph is rendered without any padding or centering in the X
  ##  direction, and aligned normally in the Y direction.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.

# For compatibility with previous versions, here are the old procedures

template renderText*(font, text, fg, bg: untyped): untyped =
  renderText_Shaded(font, text, fg, bg)

template renderUTF8*(font, text, fg, bg: untyped): untyped =
  renderUTF8_Shaded(font, text, fg, bg)

template renderUNICODE*(font, text, fg, bg: untyped): untyped =
  renderUNICODE_Shaded(font, text, fg, bg)


proc closeFont*(font: Font) {.
    cdecl, importc: "TTF_CloseFont", dynlib: SDL2_TTF_LIB.}
  ##  Close an opened font file.

proc quit*() {.
    cdecl, importc: "TTF_Quit", dynlib: SDL2_TTF_LIB.}
  ##  De-initialize the TTF engine.

proc wasInit*(): cint {.
    cdecl, importc: "TTF_WasInit", dynlib: SDL2_TTF_LIB.}
  ##  Check if the TTF engine is initialized.

proc getFontKerningSize*(font: Font; prev_index: cint, index: cint): cint {.
    cdecl, importc: "TTF_GetFontKerningSize", dynlib: SDL2_TTF_LIB, deprecated.}
  ##  Get the kerning size of two glyphs indices.
  ##
  ##  ``DEPRECATED:`` this function requires FreeType font indexes, not glyphs,
  ##  by accident, which we don't expose through this API, so it could give
  ##  wildly incorrect results, especially with non-ASCII values.
  ##  Going forward, please use ``getFontKerningSizeGlyphs()`` instead, which
  ##  does what you probably expected this function to do.

proc getFontKerningSizeGlyphs*(
    font: Font; previous_ch: uint16; ch: uint16): cint {.
      cdecl, importc: "TTF_GetFontKerningSizeGlyphs", dynlib: SDL2_TTF_LIB.}
  ##  Get the kerning size of two glyphs.

template setError*(fmt: untyped): cint =
  sdl.setError(fmt)

template getError*(): cstring =
  sdl.getError()
