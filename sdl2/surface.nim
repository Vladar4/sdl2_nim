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
# Header file for PSurface definition and management functions.
#


# Surface flags
#
# These are the currently supported flags for the PSurface.
#
# Used internally (read-only).
const
  SWSURFACE* = 0 ## Just here for compatibility
  PREALLOC* = 0x00000001 ## Surface uses preallocated memory
  RLEACCEL* = 0x00000002 ## Surface is RLE encoded
  DONTFREE* = 0x00000004 ## Surface is referenced internally


type
  PSurface* = ptr TSurface
  TSurface* = object
    ## A collection of pixels used in software blitting.
    ##
    ## This structure should be treated as read-only, except for ``pixels``,
    ## which, if not nil, contains the raw pixel data for the surface.
    flags*: Uint32 ## Read-only
    format*: ptr TPixelFormat ## Read-only
    w*, h*: int ## Read-only
    pitch*: int ## Read-only
    pixels*: pointer ## Read-write
    userdata*: pointer ## Read-write. Application data associated with the surface
    locked*: int ## Read-only. Information needed for surfaces requiring locks
    lock_data*: pointer ## Read-only. Information needed for surfaces requiring locks
    clip_rect*: TRect ## Read-only. Clipping information
    map: pointer ## Private. Info for fast blit mapping to other surfaces
    refcount*: int ## Read-mostly. Reference count -- used when freeing surface


template mustLock*(s: PSurface): bool =
  ## Evaluates to true if the surface needs to be locked before access.
  ((s.flags & RLEACCEL) != 0)


proc blit*(src: PSurface, srcrect: PRect, dst: PSurface, dstrect: PRect): int {.cdecl, importc: "SDL_Blit", dynlib: LibName.}
  ## The type of function used for surface blitting functions.


proc createRGBSurface*(flags: Uint32 = 0, width, height, depth: int,
  rMask, gMask, bMask, aMask: Uint32): PSurface {.cdecl, importc: "SDL_CreateRGBSurface", dynlib: LibName.}
  ## Allocate an RGB surface.
  ##
  ## If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
  ## If the depth is greater than 8 bits, the pixel format is set using the
  ## flags '[RGB]mask'.
  ##
  ## If the function runs out of memory, it will return nil.
  ##
  ## ``flags`` The ``flags`` are obsolete and should be set to 0.
  ##
  ## ``width`` The width in pixels of the surface to create.
  ##
  ## ``height`` The height in pixels of the surface to create.
  ##
  ## ``depth`` The depth in bits of the surface to create.
  ##
  ## ``rMask`` The red mask of the surface to create.
  ##
  ## ``gMask`` The green mask of the surface to create.
  ##
  ## ``bMask`` The blue mask of the surface to create.
  ##
  ## ``aMask`` The alpha mask of the surface to create.


proc createRGBSurfaceFrom*(pixels: pointer, width, height, depth, pitch: int,
  rMask, gMask, bMask, aMask: Uint32): PSurface {.cdecl, importc: "SDL_CreateRGBSurfaceFrom", dynlib: LibName.}
  ## Allocate an RGB surface.
  ##
  ## If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
  ## If the depth is greater than 8 bits, the pixel format is set using the
  ## flags '[RGB]mask'.
  ##
  ## If the function runs out of memory, it will return nil.
  ##
  ## ``width`` The width in pixels of the surface to create.
  ##
  ## ``height`` The height in pixels of the surface to create.
  ##
  ## ``depth`` The depth in bits of the surface to create.
  ##
  ## ``rMask`` The red mask of the surface to create.
  ##
  ## ``gMask`` The green mask of the surface to create.
  ##
  ## ``bMask`` The blue mask of the surface to create.
  ##
  ## ``aMask`` The alpha mask of the surface to create.


proc freeSurface*(surface: PSurface) {.cdecl, importc: "SDL_FreeSurface", dynlib: LibName.}
  ## Free an RGB surface.


proc setSurfacePalette*(surface: PSurface, palette: ptr TPalette): int {.cdecl, importc: "SDL_SetSurfacePalette", dynlib: LibName.}
  ## Set the palette used by a surface.
  ##
  ## Return 0, or -1 if the surface format doesn't use a palette.
  ##
  ## A single palette can be shared with many surfaces.


proc lockSurface*(surface: PSurface): int {.cdecl, importc: "SDL_LockSurface", dynlib: LibName.}
  ## Sets up a surface for directly accessing the pixels.
  ##
  ## Between calls to lockSurface() / unlockSurface(), you can write
  ## to and read from ``surface.pixels``, using the pixel format stored in
  ## ``surface.format``. Once you are done accessing the surface, you should
  ## use unlockSurface() to release it.
  ##
  ## Not all surfaces require locking.  If mustLock(surface) evaluates
  ## to 0, then you can read and write to the surface at any time, and the
  ## pixel format of the surface will not change.
  ##
  ## No operating system or library calls should be made between lock/unlock
  ## pairs, as critical system locks may be held during this time.
  ##
  ## lockSurface() returns 0, or -1 if the surface couldn't be locked.
  ##
  ## See also: unlockSurface()


proc unlockSurface*(surface: PSurface) {.cdecl, importc: "SDL_UnlockSurface", dynlib: LibName.}
  ## See also: lockSurface()


proc loadBMP_RW*(src: PRWops, freesrc: int): PSurface {.cdecl, importc: "SDL_LoadBMP_RW", dynlib: LibName.}
  ## Load a surface from a seekable SDL data stream (memory or file).
  ##
  ## If ``freesrc`` is non-zero, the stream will be closed after being read.
  ##
  ## The new surface should be freed with freeSurface().
  ##
  ## Return the new surface, or nil if there was an error.


template loadBMP*(file: cstring): PSurface =
  loadBMP_RW(rwFromFile(file, "rb"), 1)
  ## Load a surface from a file.
  ##
  ## Convenience template.


proc saveBMP_RW*(surface: PSurface, dst: PRWops, freedst: int): int {.cdecl, importc: "SDL_SaveBMP_RW", dynlib: LibName.}
  ## Save a surface to a seekable SDL data stream (memory or file).
  ##
  ## If ``freedst`` is non-zero, the stream will be closed after being written.
  ##
  ## Return 0 if successful or -1 if there was an error.


template saveBMP*(surface: PSurface, file: cstring): int =
  saveBMP_RW(surface, rwFromFile(file, "wb"), 1)
  ## Save a surface to a file.
  ##
  ## Convenience template.

proc setSurfaceRLE*(surface: PSurface, flag: int): int {.cdecl, importc: "SDL_SetSurfaceRLE", dynlib: LibName.}
  ## Sets the RLE acceleration hint for a surface.
  ##
  ## Return 0 on success, or -1 if the surface is not valid
  ##
  ## If RLE is enabled, colorkey and alpha blending blits are much faster,
  ## but the surface must be locked before directly accessing the pixels.


proc setColorKey*(surface: PSurface, flag: int, key: Uint32): int {.cdecl, importc: "SDL_SetColorKey", dynlib: LibName.}
  ## Sets the color key (transparent pixel) in a blittable surface.
  ##
  ## ``surface`` The surface to update
  ##
  ## ``flag`` Non-zero to enable colorkey and 0 to disable colorkey
  ##
  ## ``key`` The transparent pixel in the native surface format
  ##
  ## Return 0 on success, or -1 if the surface is not valid
  ##
  ## You can pass RLEACCEL to enable RLE accelerated blits.


proc getColorKey*(surface: PSurface, key: Uint32): int {.cdecl, importc: "SDL_GetColorKey", dynlib: LibName.}
  ## Gets the color key (transparent pixel) in a blittable surface.
  ##
  ## ``surface`` The surface to update
  ##
  ## ``key`` A pointer filled in with the transparent pixel in the native
  ## surface format
  ##
  ## Return 0 on success, or -1 if the surface is not valid or colorkey is not
  ## enabled.


proc setSurfaceColorMod*(surface: PSurface, r, g, b: Uint8): int {.cdecl, importc: "SDL_SetSurfaceColorMod", dynlib: LibName.}
  ## Set an additional color value used in blit operations.
  ##
  ## ``surface`` The surface to update.
  ##
  ## ``r`` The red color value multiplied into blit operations.
  ##
  ## ``g`` The green color value multiplied into blit operations.
  ##
  ## ``b`` The blue color value multiplied into blit operations.
  ##
  ## Return 0 on success, or -1 if the surface is not valid.
  ##
  ## See also: getSurfaceColorMod()


proc getSurfaceColorMod*(surface: PSurface, r, g, b: ptr Uint8): int {.cdecl, importc: "SDL_GetSurfaceColorMod", dynlib: LibName.}
  ## Get the additional color value used in blit operations.
  ##
  ## ``surface`` The surface to query.
  ##
  ## ``r`` A pointer filled in with the current red color value.
  ##
  ## ``g`` A pointer filled in with the current green color value.
  ##
  ## ``b`` A pointer filled in with the current blue color value.
  ##
  ## Return 0 on success, or -1 if the surface is not valid.
  ##
  ## See also: setSurfaceColorMod()


proc setSurfaceAlphaMod*(surface: PSurface, alpha: Uint8): int {.cdecl, importc: "SDL_SetSurfaceAlphaMod", dynlib: LibName.}
  ## Set an additional alpha value used in blit operations.
  ##
  ## ``surface`` The surface to update.
  ##
  ## ``alpha`` The alpha value multiplied into blit operations.
  ##
  ## Return 0 on success, or -1 if the surface is not valid.
  ##
  ## See also: getSurfaceAlphaMod()


proc getSurfaceAlphaMod*(surface: PSurface, alpha: ptr Uint8): int {.cdecl, importc: "SDL_GetSurfaceAlphaMod", dynlib: LibName.}
  ## Get the additional alpha value used in blit operations.
  ##
  ## ``surface`` The surface to query.
  ##
  ## ``alpha`` A pointer filled in with the current alpha value.
  ##
  ## Return 0 on success, or -1 if the surface is not valid.
  ##
  ## See also: setSurfaceAlphaMod()

proc setSurfaceBlendMode*(surface: PSurface, blendMode: TBlendMode): int {.cdecl, importc: "SDL_SetSurfaceBlendMode", dynlib: LibName.}
  ## Set the blend mode used for blit operations.
  ##
  ## ``surface`` The surface to update.
  ##
  ## ``blendMode`` TBlendMode to use for blit blending.
  ##
  ## Return 0 on success, or -1 if the parameters are not valid.
  ##
  ## See also: getSurfaceBlendMode()

proc getSurfaceBlendMode*(surface: PSurface, blendMode: ptr TBlendMode): int {.cdecl, importc: "SDL_GetSurfaceBlendMode", dynlib: LibName.}
  ## Get the blend mode used for blit operations.
  ##
  ## ``surface`` The surface to query.
  ##
  ## ``blendMode`` A pointer filled in with the current blend mode.
  ##
  ## Return 0 on success, or -1 if the surface is not valid.
  ##
  ## See also: setSurfaceBlendMode()


proc setClipRect*(surface: PSurface, rect: PRect): bool {.cdecl, importc: "SDL_SetClipRect", dynlib: LibName.}
  ## Sets the clipping rectangle for the destination surface in a blit.
  ##
  ## If the clip rectangle is nil, clipping will be disabled.
  ##
  ## If the clip rectangle doesn't intersect the surface, the function will
  ## return FALSE and blits will be completely clipped.  Otherwise the
  ## function returns TRUE and blits to the surface will be clipped to
  ## the intersection of the surface area and the clipping rectangle.
  ##
  ## Note that blits are automatically clipped to the edges of the source
  ## and destination surfaces.


proc getClipRect*(surface: PSurface, rect: PRect) {.cdecl, importc: "SDL_GetClipRect", dynlib: LibName.}
  ## Gets the clipping rectangle for the destination surface in a blit.
  ##
  ## ``rect`` must be a pointer to a valid rectangle which will be filled
  ## with the correct values.


proc convertSurface*(src: PSurface, fmt: ptr TPixelFormat, flags: Uint32): PSurface {.cdecl, importc: "SDL_ConvertSurface", dynlib: LibName.}
  ## Creates a new surface of the specified format, and then copies and maps
  ## the given surface to it so the blit of the converted surface will be as
  ## fast as possible.  If this function fails, it returns nil.
  ##
  ## The ``flags`` parameter is passed to createRGBSurface() and has those
  ## semantics.  You can also pass ``RLEACCEL`` in the flags parameter and
  ## SDL will try to RLE accelerate colorkey and alpha blits in the resulting
  ## surface.


proc convertSurfaceFormat*(src: PSurface, pixel_format, flags: Uint32): PSurface {.cdecl, importc: "SDL_ConvertSurfaceFormat", dynlib: LibName.}
  ## Creates a new surface of the specified format, and then copies and maps
  ## the given surface to it so the blit of the converted surface will be as
  ## fast as possible.  If this function fails, it returns nil.
  ##
  ## The ``flags`` parameter is passed to createRGBSurface() and has those
  ## semantics.  You can also pass ``RLEACCEL`` in the flags parameter and
  ## SDL will try to RLE accelerate colorkey and alpha blits in the resulting
  ## surface.


proc convertPixels*(width, height: int,
  src_format: Uint32, src: pointer, src_pitch: int,
  dst_format: Uint32, dst: pointer, dst_pitch: int): int {.cdecl, importc: "SDL_ConvertPixels", dynlib: LibName.}
  ## Copy a block of pixels of one format to another format
  ##
  ## Return 0 on success, or -1 if there was an error


proc fillRect*(dst: PSurface, rect: PRect, color: Uint32): int {.cdecl, importc: "SDL_FillRect", dynlib: LibName.}
  ## Performs a fast fill of the given rectangle with ``color``.
  ##
  ## If ``rect`` is nil, the whole surface will be filled with ``color``.
  ##
  ## The color should be a pixel of the format used by the surface, and
  ## can be generated by the mapRGB() function.
  ##
  ## Return 0 on success, or -1 on error.


proc fillRects*(dst: PSurface, rects: PRect, count: int, color: Uint32): int {.cdecl, importc: "SDL_FillRect", dynlib: LibName.}
  ## Performs a fast fill of the given rectangles with ``color``.
  ##
  ## If ``rect`` is nil, the whole surface will be filled with ``color``.
  ##
  ## The color should be a pixel of the format used by the surface, and
  ## can be generated by the mapRGB() function.
  ##
  ## Return 0 on success, or -1 on error.


proc upperBlit*(src: PSurface, srcrect: PRect,
  dst: PSurface, dstrect: PRect): int {.cdecl, importc: "SDL_UpperBlit", dynlib: LibName.}
  ## This is the public blit function, blitSurface(), and it performs
  ## rectangle validation and clipping before passing it to LowerBlit()


proc lowerBlit*(src: PSurface, srcrect: PRect, dst: PSurface, dstrect: PRect): int {.cdecl, importc: "SDL_LowerBlit", dynlib: LibName.}
  ## This is a semi-private blit function and it performs low-level surface
  ## blitting only.


proc softStretch*(src: PSurface, srcrect: PRect,
  dst: PSurface, dstrect: PRect): int {.cdecl, importc: "SDL_SoftStretch", dynlib: LibName.}
  ## Perform a fast, low quality, stretch blit between two surfaces of the
  ## same pixel format.
  ##
  ## This function uses a static buffer, and is not thread-safe.


template blitScaled*(src: PSurface, srcrect: PRect,
  dst: PSurface, dstrect: PRect): int =
  upperBlitScaled(src, srcrect, dst, dstrect)


proc upperBlitScaled*(src: PSurface, srcrect: PRect,
  dst: PSurface, dstrect: PRect): int {.cdecl, importc: "SDL_UpperBlitScaled", dynlib: LibName.}
  ## This is the public scaled blit function, blitScaled(), and it performs
  ## rectangle validation and clipping before passing it to lowerBlitScaled()


proc lowerBlitScaled*(src: PSurface, srcrect: PRect,
  dst: PSurface, dstrect: PRect): int {.cdecl, importc: "SDL_LowerBlitScaled", dynlib: LibName.}
  ## This is a semi-private blit function and it performs low-level surface
  ## scaled blitting only.


proc blitSurface*(src: PSurface, srcrect: PRect,
  dst: PSurface, dstrect: PRect): int {.inline.} =
  ## Performs a fast blit from the source surface to the destination surface.
  ##
  ## This assumes that the source and destination rectangles are
  ## the same size.  If either ``srcrect`` or ``dstrect`` are nil, the entire
  ## surface (``src`` or ``dst``) is copied.  The final blit rectangles are
  ## saved in ``srcrect`` and ``dstrect`` after all clipping is performed.
  ##
  ## Return 0 if the blit is successful, otherwise return -1.
  ##
  ## The blit function should not be called on a locked surface.
  ##
  ## The blit semantics for surfaces with and without alpha and colorkey
  ## are defined as follows:
  ##
  ##
  ## RGBA->RGB:
  ##
  ##   SRCALPHA set:
  ##
  ##     alpha-blend (using alpha-channel).
  ##
  ##     SRCCOLORKEY ignored.
  ##
  ##   SRCALPHA not set:
  ##
  ##     copy RGB.
  ##
  ##     if SRCCOLORKEY set, only copy the pixels matching the
  ##     RGB values of the source color key, ignoring alpha in the
  ##     comparison.
  ##
  ##
  ## RGB->RGBA:
  ##
  ##   SRCALPHA set:
  ##
  ##     alpha-blend (using the source per-surface alpha value);
  ##     set destination alpha to opaque.
  ##
  ##   SRCALPHA not set:
  ##
  ##     copy RGB, set destination alpha to source per-surface alpha value.
  ##
  ##   both:
  ##
  ##     if SRCCOLORKEY set, only copy the pixels matching the
  ##     source color key.
  ##
  ##
  ## RGBA->RGBA:
  ##
  ##   SRCALPHA set:
  ##
  ##     alpha-blend (using the source alpha channel) the RGB values;
  ##     leave destination alpha untouched. [Note: is this correct?]
  ##     SRCCOLORKEY ignored.
  ##
  ##   SRCALPHA not set:
  ##
  ##     copy all of RGBA to the destination.
  ##     if SRCCOLORKEY set, only copy the pixels matching the
  ##     RGB values of the source color key, ignoring alpha in the
  ##     comparison.
  ##
  ##
  ## RGB->RGB:
  ##
  ##   SRCALPHA set:
  ##
  ##     alpha-blend (using the source per-surface alpha value).
  ##
  ##   SDL_SRCALPHA not set:
  ##
  ##     copy RGB.
  ##
  ##   both:
  ##
  ##     if SRCCOLORKEY set, only copy the pixels matching the
  ##     source color key.
  ##
  ##
  ## You should call blitSurface() unless you know exactly how SDL
  ## blitting works internally and how to use the other blit functions.
  return upperBlit(src, srcrect, dst, dstrect)

