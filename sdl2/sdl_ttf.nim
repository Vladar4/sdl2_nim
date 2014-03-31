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
# available at:
# http://www.freetype.org/


import
  sdl, unsigned, widecstring


# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 12


template version*(x: PVersion) =
  ## This template can be used to fill a version structure with the compile-time
  ## version of the SDL_ttf library.
  x.major = MAJOR_VERSION
  x.minor = MINOR_VERSION
  x.patch = PATCHLEVEL


template version*(x: TVersion) =
  version(addr(x))


proc linkedVersion*(): PVersion {.cdecl, importc: "TTF_Linked_Version", dynlib: LibTtfName.}
  ## This function gets the version of the dynamically linked SDL_ttf library.
  ##
  ## It should NOT be used to fill a version structure, instead you should
  ## use the version() template.


# ZERO WIDTH NO-BREAKSPACE (Unicode byte order mark)
const
  UNICODE_BOM_NATIVE* = 0xFEFF
  UNICODE_BOM_SWAPPED* = 0xFFFE


proc byteSwappedUnicode*(swapped: int) {.cdecl, importc: "TTF_ByteSwappedUNICODE", dynlib: LibTtfName.}
  ## This function tells the library whether UNICODE text is generally
  ## byteswapped.  A UNICODE BOM character in a string will override
  ## this setting for the remainder of that string.


type
  PTTFFont* = pointer ## The internal structure containing font information


proc init*(): int {.cdecl, importc: "TTF_Init", dynlib: LibTtfName.}
  ## Initialize the TTF engine - returns 0 if successful, -1 on error


proc openFont*(file: cstring, ptsize: int): PTTFFont {.cdecl, importc: "TTF_OpenFont", dynlib: LibTtfName.}
  ## Open a font file and create a font of the specified point size.
  ##
  ## Some .fon fonts will have several sizes embedded in the file, so the
  ## point size becomes the index of choosing which size.  If the value
  ## is too high, the last indexed size will be the default.


proc openFontIndex*(file: cstring, ptsize: int, index: clong): PTTFFont {.cdecl, importc: "TTF_OpenFontIndex", dynlib: LibTtfName.}
  ## Open a font file and create a font of the specified point size.
  ##
  ## Some .fon fonts will have several sizes embedded in the file, so the
  ## point size becomes the index of choosing which size.  If the value
  ## is too high, the last indexed size will be the default.


proc openFontRW*(src: PRWops, freesrc, ptsize: int): PTTFFont {.cdecl, importc: "TTF_OpenFontRW", dynlib: LibTtfName.}
  ## Open a font file and create a font of the specified point size.
  ##
  ## Some .fon fonts will have several sizes embedded in the file, so the
  ## point size becomes the index of choosing which size.  If the value
  ## is too high, the last indexed size will be the default.


proc openFontIndexRW*(src: PRWops, freesrc, ptsize: int, index: clong): PTTFFont {.cdecl, importc: "TTF_OpenFontIndexRW", dynlib: LibTtfName.}
  ## Open a font file and create a font of the specified point size.
  ##
  ## Some .fon fonts will have several sizes embedded in the file, so the
  ## point size becomes the index of choosing which size.  If the value
  ## is too high, the last indexed size will be the default.


# Set and retrieve the font style
const
  STYLE_NORMAL* = 0x00
  STYLE_BOLD* = 0x01
  STYLE_ITALIC* = 0x02
  STYLE_UNDERLINE* = 0x04
  STYLE_STRIKETHROUGH* = 0x08


proc getFontStyle*(font: PTTFFont): int {.cdecl, importc: "TTF_GetFontStyle", dynlib: LibTtfName.}


proc setFontStyle*(font: PTTFFont, style: int) {.cdecl, importc: "TTF_SetFontStyle", dynlib: LibTtfName.}


proc getFontOutline*(font: PTTFFont): int {.cdecl, importc: "TTF_GetFontOutline", dynlib: LibTtfName.}


proc setFontOutline*(font: PTTFFont, outline: int) {.cdecl, importc: "TTF_SetFontOutline", dynlib: LibTtfName.}


# Set and retrieve FreeType hinter settings
const
  HINTING_NORMAL* = 0
  HINTING_LIGHT* = 1
  HINTING_MONO* = 2
  HINTING_NONE* = 3


proc getFontHinting*(font: PTTFFont): int {.cdecl, importc: "TTF_GetFontHinting", dynlib: LibTtfName.}


proc setFontHinting*(font: PTTFFont, hinting: int) {.cdecl, importc: "TTF_SetFontHinting", dynlib: LibTtfName.}


proc fontHeight*(font: PTTFFont): int {.cdecl, importc: "TTF_FontHeight", dynlib: LibTtfName.}
  ## Get the total height of the font - usually equal to point size


proc fontAscent*(font: PTTFFont): int {.cdecl, importc: "TTF_FontAscent", dynlib: LibTtfName.}
  ## Get the offset from the baseline to the top of the font
  ##
  ## This is a positive value, relative to the baseline.


proc fontDescent*(font: PTTFFont): int {.cdecl, importc: "TTF_FontDescent", dynlib: LibTtfName.}
  ## Get the offset from the baseline to the bottom of the font
  ##
  ## This is a negative value, relative to the baseline.


proc fontLineSkip*(font: PTTFFont): int {.cdecl, importc: "TTF_FontLineSkip", dynlib: LibTtfName.}
  ## Get the recommended spacing between lines of text for this font


proc getFontKerning*(font: PTTFFont): int {.cdecl, importc: "TTF_GetFontKerning", dynlib: LibTtfName.}
  ## Get whether or not kerning is allowed for this font


proc setFontKerning*(font: PTTFFont, allowed: int) {.cdecl, importc: "TTF_SetFontKerning", dynlib: LibTtfName.}
  ## Set whether or not kerning is allowed for this font


proc fontFaces*(font: PTTFFont): clong {.cdecl, importc: "TTF_FontFaces", dynlib: LibTtfName.}
  ## Get the number of faces of the font


proc fontFaceIsFixedWidth*(font: PTTFFont): int {.cdecl, importc: "TTF_FontFaceIsFixedWidth", dynlib: LibTtfName.}
  ## Get the font face attributes, if any


proc fontFaceFamilyName*(font: PTTFFont): cstring {.cdecl, importc: "TTF_FontFaceFamilyName", dynlib: LibTtfName.}
  ## Get the font face attributes, if any


proc fontFaceStyleName*(font: PTTFFont): cstring {.cdecl, importc: "TTF_FontFaceStyleName", dynlib: LibTtfName.}
  ## Get the font face attributes, if any


proc glyphIsProvided*(font: PTTFFont, ch: Uint16): int {.cdecl, importc: "TTF_GlyphIsProvided", dynlib: LibTtfName.}
  # Check wether a glyph is provided by the font or not


proc glyphMetrics*(font: PTTFFont, ch: Uint16,
  minx, maxx, miny, maxy,
  advance: ptr int): int {.cdecl, importc: "TTF_GlyphMetrics", dynlib: LibTtfName.}
  ## Get the metrics (dimensions) of a glyph
  ##
  ## To understand what these metrics mean, here is a useful link:
  ##
  ## http://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html


proc sizeText*(font: PTTFFont, text: cstring, w, h: ptr int): int {.cdecl, importc: "TTF_SizeText", dynlib: LibTtfName.}
  ## Get the dimensions of a rendered string of text


proc sizeUTF8*(font: PTTFFont, text: cstring, w, h: ptr int): int {.cdecl, importc: "TTF_SizeUTF8", dynlib: LibTtfName.}
  ## Get the dimensions of a rendered string of text


proc sizeUnicode*(font: PTTFFont, text: WideCString, w, h: ptr int): int {.cdecl, importc: "TTF_SizeUNICODE", dynlib: LibTtfName.}
  ## Get the dimensions of a rendered string of text


proc renderTextSolid*(font: PTTFFont,
  text: cstring, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderText_Solid", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given text at
  ## fast quality with the given font and color.  The 0 pixel is the
  ## colorkey, giving a transparent background, and the 1 pixel is set
  ## to the text color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUTF8Solid*(font: PTTFFont,
  text: cstring, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderUTF8_Solid", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given text at
  ## fast quality with the given font and color.  The 0 pixel is the
  ## colorkey, giving a transparent background, and the 1 pixel is set
  ## to the text color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUnicodeSolid*(font: PTTFFont,
  text: WideCString, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderUNICODE_Solid", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given text at
  ## fast quality with the given font and color.  The 0 pixel is the
  ## colorkey, giving a transparent background, and the 1 pixel is set
  ## to the text color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderGlyphSolid*(font: PTTFFont,
  ch: Uint16, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderGlyph_Solid", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given glyph at
  ## fast quality with the given font and color.  The 0 pixel is the
  ## colorkey, giving a transparent background, and the 1 pixel is set
  ## to the text color.  The glyph is rendered without any padding or
  ## centering in the X direction, and aligned normally in the Y direction.
  #
  ## This function returns the new surface, or nil if there was an error.


proc renderTextShaded*(font: PTTFFont,
  text: cstring, fg, bg: TColor): PSurface {.cdecl, importc: "TTF_RenderText_Shaded", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given text at
  ## high quality with the given font and colors.  The 0 pixel is background,
  ## while other pixels have varying degrees of the foreground color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUTF8Shaded*(font: PTTFFont,
  text: cstring, fg, bg: TColor): PSurface {.cdecl, importc: "TTF_RenderUTF8_Shaded", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given text at
  ## high quality with the given font and colors.  The 0 pixel is background,
  ## while other pixels have varying degrees of the foreground color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUnicodeShaded*(font: PTTFFont,
  text: WideCString, fg, bg: TColor): PSurface {.cdecl, importc: "TTF_RenderUNICODE_Shaded", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given text at
  ## high quality with the given font and colors.  The 0 pixel is background,
  ## while other pixels have varying degrees of the foreground color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderGlyphShaded*(font: PTTFFont,
  ch: Uint16, fg, bg: TColor): PSurface {.cdecl, importc: "TTF_RenderGlyph_Shaded", dynlib: LibTtfName.}
  ## Create an 8-bit palettized surface and render the given glyph at
  ## high quality with the given font and colors.  The 0 pixel is background,
  ## while other pixels have varying degrees of the foreground color.
  ## The glyph is rendered without any padding or centering in the X
  ## direction, and aligned normally in the Y direction.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderTextBlended*(font: PTTFFont,
  text: cstring, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderText_Blended", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given text at high quality,
  ## using alpha blending to dither the font with the given color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUTF8Blended*(font: PTTFFont,
  text: cstring, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderUTF8_Blended", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given text at high quality,
  ## using alpha blending to dither the font with the given color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUnicodeBlended*(font: PTTFFont,
  text: WideCString, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderUNICODE_Blended", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given text at high quality,
  ## using alpha blending to dither the font with the given color.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderTextBlendedWrapped*(font: PTTFFont,
  text: cstring, fg: TColor, wrapLength: Uint32): PSurface {.cdecl, importc: "TTF_RenderText_Blended_Wrapped", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given text at high quality,
  ## using alpha blending to dither the font with the given color.
  ## Text is wrapped to multiple lines on line endings and on word boundaries
  ## if it extends beyond wrapLength in pixels.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUTF8BlendedWrapped*(font: PTTFFont,
  text: cstring, fg: TColor, wrapLength: Uint32): PSurface {.cdecl, importc: "TTF_RenderUTF8_Blended_Wrapped", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given text at high quality,
  ## using alpha blending to dither the font with the given color.
  ## Text is wrapped to multiple lines on line endings and on word boundaries
  ## if it extends beyond wrapLength in pixels.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderUnicodeBlendedWrapped*(font: PTTFFont,
  text: WideCString, fg: TColor, wrapLength: Uint32): PSurface {.cdecl, importc: "TTF_RenderUNICODE_Blended_Wrapped", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given text at high quality,
  ## using alpha blending to dither the font with the given color.
  ## Text is wrapped to multiple lines on line endings and on word boundaries
  ## if it extends beyond wrapLength in pixels.
  ##
  ## This function returns the new surface, or nil if there was an error.


proc renderGlyphBlended*(font: PTTFFont,
 ch: Uint16, fg: TColor): PSurface {.cdecl, importc: "TTF_RenderGlyph_Blended", dynlib: LibTtfName.}
  ## Create a 32-bit ARGB surface and render the given glyph at high quality,
  ## using alpha blending to dither the font with the given color.
  ## The glyph is rendered without any padding or centering in the X
  ## direction, and aligned normally in the Y direction.
  ##
  ## This function returns the new surface, or nil if there was an error.


## For compatibility with previous versions, here are the old functions

template RenderText*(font, text, fg, bg: expr): PSurface =
    renderTextShaded(font, text, fg, bg)

template renderUTF8*(font, text, fg, bg: expr): PSurface =
    renderUTF8_Shaded(font, text, fg, bg)

template renderUnicode*(font, text, fg, bg: expr): PSurface =
    renderUnicodeShaded(font, text, fg, bg)


proc closeFont*(font: PTTFFont) {.cdecl, importc: "TTF_CloseFont", dynlib: LibTtfName.}
  ## Close an opened font file


proc quit*() {.cdecl, importc: "TTF_Quit", dynlib: LibTtfName.}
  ## De-initialize the TTF engine


proc wasInit*(): int {.cdecl, importc: "TTF_WasInit", dynlib: LibTtfName.}
  ## Check if the TTF engine is initialized


proc getFontKerningSize*(font: PTTFFont, prev_index, index: int): int {.cdecl, importc: "TTF_GetFontKerningSize", dynlib: LibTtfName.}
  ## Get the kerning size of two glyphs

