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

##  surface.nim
##  ===========
##
##  Header file for Surface definition and management procedures.

# Surface flags
# These are the currently supported flags for the Surface.
#
# Used internally (read-only).
const
  SWSURFACE* = 0
  PREALLOC* = 0x00000001
  RLEACCEL* = 0x00000002
  DONTFREE* = 0x00000004

template mustLock*(s: untyped): untyped = ##  \
  ##  Evaluates to `true` if the surface needs t o be locked before access.
  (((s).flags and RLEACCEL) != 0)

# 
type
  Surface* = ptr SurfaceObj
  SurfaceObj* = object ##  \
    ##  A collection of pixels used in software blitting.
    ##
    ##  ``Note:`` This object should be treated as read-only, except for
    ##  ``pixels``, which, if not `nil`, contains the raw pixel data
    ##  for the surface.
    flags*: uint32          ## Read-only 
    format*: ptr PixelFormat ## Read-only 
    w*: cint
    h*: cint                ## Read-only
    pitch*: cint            ## Read-only
    pixels*: pointer        ## Read-write
                            ## Application data associated with the surface 
    userdata*: pointer      ## Read-write \
                            ## information needed for surfaces requiring locks 
    locked*: cint           ## Read-only
    lock_data*: pointer     ## Read-only \
                            ## clipping information
    clip_rect*: Rect        ## Read-only \
                            ## info for fast blit mapping to other surfaces
    map*: pointer           ## Private \
                            ## Reference count -- used when freeing surface
    refcount*: cint         ## Read-mostly

type
  blit* = proc (
      src: Surface; srcrect: ptr Rect;
      dst: Surface; dstrect: ptr Rect): cint {.cdecl.} ##  \
    ##  The type of procedure used for surface blitting procedures.

proc createRGBSurface*(
    flags: uint32; width: cint; height: cint; depth: cint;
    rMask: uint32; gMask: uint32; bMask: uint32; aMask: uint32): Surface {.
      cdecl, importc: "SDL_CreateRGBSurface", dynlib: SDL2_LIB.}
  ##  Allocate and free an RGB surface.
  ##
  ##  If the depth is 4 or 8 bits, an empty palette is allocated for the surface.
  ##  If the depth is greater than 8 bits, the pixel format is set using the
  ##  flags ``[rgb]Mask``.
  ##
  ##  If the procedure runs out of memory, it will return `nil`.
  ##
  ##  ``flags`` The ``flags`` are obsolete and should be set to `0`.
  ##
  ##  ``width`` The width in pixels of the surface to create.
  ##
  ##  ``height`` The height in pixels of the surface to create.
  ##
  ##  ``depth`` The depth in bits of the surface to create.
  ##
  ##  ``rMask`` The red mask of the surface to create.
  ##
  ##  ``gMask`` The green mask of the surface to create.
  ##
  ##  ``bMask`` The blue mask of the surface to create.
  ##
  ##  ``aMask`` The alpha mask of the surface to create.

proc createRGBSurfaceWithFormat*(
    flags: uint32; width: cint; height: cint; depth: cint;
    format: uint32): Surface {.
      cdecl, importc: "SDL_CreateRGBSurfaceWithFormat", dynlib: SDL2_LIB.}

proc createRGBSurfaceFrom*(
    pixels: pointer; width: cint; height: cint; depth: cint; pitch: cint;
    rMask: uint32; gMask: uint32; bMask: uint32; aMask: uint32): Surface {.
      cdecl, importc: "SDL_CreateRGBSurfaceFrom", dynlib: SDL2_LIB.}

proc createRGBSurfaceWithFormatFrom*(
    pixels: pointer; width: cint; height: cint; depth: cint; pitch: cint;
    format: uint32): Surface {.
      cdecl, importc: "SDL_CreateRGBSurfaceWithFormatFrom", dynlib: SDL2_LIB.}

proc freeSurface*(surface: Surface) {.
    cdecl, importc: "SDL_FreeSurface", dynlib: SDL2_LIB.}

proc setSurfacePalette*(surface: Surface; palette: ptr Palette): cint {.
    cdecl, importc: "SDL_SetSurfacePalette", dynlib: SDL2_LIB.}
  ##  Set the palette used by a surface.
  ##
  ##  ``Return`` `0`, or `-1` if the surface format doesn't use a palette.
  ##
  ##  ``Note:`` A single palette can be shared with many surfaces.

proc lockSurface*(surface: Surface): cint {.
    cdecl, importc: "SDL_LockSurface", dynlib: SDL2_LIB.}
  ##  Sets up a surface for directly accessing the pixels.
  ##
  ##  Between calls to ``lockSurface()`` / ``unlockSurface()``, you can write
  ##  to and read from ``surface->pixels``, using the pixel format stored in
  ##  ``surface->format``.  Once you are done accessing the surface, you should
  ##  use ``unlockSurface()`` to release it.
  ##
  ##  Not all surfaces require locking.  If ``mustLock(surface)`` evaluates
  ##  to `0`, then you can read and write to the surface at any time, and the
  ##  pixel format of the surface will not change.
  ##
  ##  No operating system or library calls should be made between lock/unlock
  ##  pairs, as critical system locks may be held during this time.
  ##
  ##  ``lockSurface()`` returns `0`, or `-1` if the surface couldn't be locked.
  ##
  ##  See also:
  ##
  ##  ``unlockSurface()``

proc unlockSurface*(surface: Surface) {.
    cdecl, importc: "SDL_UnlockSurface", dynlib: SDL2_LIB.}
  ## See also:
  ##
  ## ``lockSurface()``

proc loadBMP_RW*(src: ptr RWops; freesrc: cint): Surface {.
    cdecl, importc: "SDL_LoadBMP_RW", dynlib: SDL2_LIB.}
  ##  Load a surface from a seekable SDL data stream (memory or file).
  ##
  ##  If ``freesrc`` is non-zero, the stream will be closed after being read.
  ##
  ##  The new surface should be freed with ``freeSurface()``.
  ##
  ##  ``Return`` the new surface, or `nil` if there was an error.

template loadBMP*(file: untyped): untyped = ##  \
  ##  Load a surface from a file.
  ##
  ##  Convenience macro.
  loadBMP_RW(rwFromFile(file, "rb"), 1)

proc saveBMP_RW*(surface: Surface; dst: ptr RWops; freedst: cint): cint {.
    cdecl, importc: "SDL_SaveBMP_RW", dynlib: SDL2_LIB.}
  ##  Save a surface to a seekable SDL data stream (memory or file).
  ##
  ##  Surfaces with a 24-bit, 32-bit and paletted 8-bit format get saved in the
  ##  BMP directly. Other RGB formats with 8-bit or higher get converted to a
  ##  24-bit surface or, if they have an alpha mask or a colorkey, to a 32-bit
  ##  surface before they are saved. YUV and paletted 1-bit and 4-bit formats
  ##  are not supported.
  ##
  ##  If ``freedst`` is non-zero, the stream will be closed after being written.
  ##
  ##  ``Return`` `0` if successful or `-1` if there was an error.

template saveBMP*(surface, file: untyped): untyped = ##  \
  ##  Save a surface to a file.
  ##
  ##  Convenience macro.
  saveBMP_RW(surface, rwFromFile(file, "wb"), 1)

proc setSurfaceRLE*(surface: Surface; flag: cint): cint {.
    cdecl, importc: "SDL_SetSurfaceRLE", dynlib: SDL2_LIB.}
  ##  Sets the RLE acceleration hint for a surface.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  ``Note:`` If RLE is enabled, colorkey and alpha blending blits are
  ##  much faster, but the surface must be locked before directly
  ##  accessing the pixels.

proc setColorKey*(surface: Surface; flag: cint; key: uint32): cint {.
    cdecl, importc: "SDL_SetColorKey", dynlib: SDL2_LIB.}
  ##  Sets the color key (transparent pixel) in a blittable surface.
  ##
  ##  ``surface`` The surface to update.
  ##
  ##  ``flag`` Non-zero to enable colorkey and `0` to disable colorkey.
  ##
  ##  ``key`` The transparent pixel in the native surface format.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  You can pass `RLEACCEL` to enable RLE accelerated blits.

proc getColorKey*(surface: Surface; key: ptr uint32): cint {.
    cdecl, importc: "SDL_GetColorKey", dynlib: SDL2_LIB.}
  ##  Gets the color key (transparent pixel) in a blittable surface.
  ##
  ##  ``surface`` The surface to update.
  ##
  ##  ``key`` A pointer filled in with the transparent pixel
  ##  in the native surface format.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid or
  ##  colorkey is not enabled.

proc setSurfaceColorMod*(
    surface: Surface; r: uint8; g: uint8; b: uint8): cint {.
      cdecl, importc: "SDL_SetSurfaceColorMod", dynlib: SDL2_LIB.}
  ##  Set an additional color value used in blit operations.
  ##
  ##  ``surface`` The surface to update.
  ##
  ##  ``r`` The red color value multiplied into blit operations.
  ##
  ##  ``g`` The green color value multiplied into blit operations.
  ##
  ##  ``b`` The blue color value multiplied into blit operations.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  See also:
  ##
  ##  ``getSurfaceColorMod()``

proc getSurfaceColorMod*(
    surface: Surface; r: ptr uint8; g: ptr uint8; b: ptr uint8): cint {.
      cdecl, importc: "SDL_GetSurfaceColorMod", dynlib: SDL2_LIB.}
  ##  Get the additional color value used in blit operations.
  ##
  ##  ``surface`` The surface to query.
  ##
  ##  ``r`` A pointer filled in with the current red color value.
  ##
  ##  ``g`` A pointer filled in with the current green color value.
  ##
  ##  ``b`` A pointer filled in with the current blue color value.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  See also:
  ##
  ##  ``setSurfaceColorMod()``

proc setSurfaceAlphaMod*(surface: Surface; alpha: uint8): cint {.
    cdecl, importc: "SDL_SetSurfaceAlphaMod", dynlib: SDL2_LIB.}
  ##  Set an additional alpha value used in blit operations.
  ##
  ##  ``surface`` The surface to update.
  ##
  ##  ``alpha`` The alpha value multiplied into blit operations.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  See also:
  ##
  ##  ``getSurfaceAlphaMod()``

proc getSurfaceAlphaMod*(surface: Surface; alpha: ptr uint8): cint {.
    cdecl, importc: "SDL_GetSurfaceAlphaMod", dynlib: SDL2_LIB.}
  ##  Get the additional alpha value used in blit operations.
  ##
  ##  ``surface`` The surface to query.
  ##
  ##  ``alpha`` A pointer filled in with the current alpha value.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  See also:
  ##
  ##  ``setSurfaceAlphaMod()``

proc setSurfaceBlendMode*(
    surface: Surface; blendMode: BlendMode): cint {.
      cdecl, importc: "SDL_SetSurfaceBlendMode", dynlib: SDL2_LIB.}
  ##  Set the blend mode used for blit operations.
  ##
  ##  ``surface`` The surface to update.
  ##
  ##  ``blendMode`` BlendMode to use for blit blending.
  ##
  ##  ``Return`` `0` on success, or `-1` if the parameters are not valid.
  ##
  ##  See also:
  ##
  ##  ``getSurfaceBlendMode()``

proc getSurfaceBlendMode*(
    surface: Surface; blendMode: ptr BlendMode): cint {.
      cdecl, importc: "SDL_GetSurfaceBlendMode", dynlib: SDL2_LIB.}
  ##  Get the blend mode used for blit operations.
  ##
  ##  ``surface``   The surface to query.
  ##
  ##  ``blendMode`` A pointer filled in with the current blend mode.
  ##
  ##  ``Return`` `0` on success, or `-1` if the surface is not valid.
  ##
  ##  See also:
  ##
  ##  ``setSurfaceBlendMode()``

proc setClipRect*(surface: Surface; rect: ptr Rect): bool {.
    cdecl, importc: "SDL_SetClipRect", dynlib: SDL2_LIB.}
  ##  Sets the clipping rectangle for the destination surface in a blit.
  ##
  ##  If the clip rectangle is `nil`, clipping will be disabled.
  ##
  ##  If the clip rectangle doesn't intersect the surface, the procedure will
  ##  return `false` and blits will be completely clipped.  Otherwise the
  ##  procedure returns `true` and blits to the surface will be clipped to
  ##  the intersection of the surface area and the clipping rectangle.
  ##
  ##  Note that blits are automatically clipped to the edges of the source
  ##  and destination surfaces.

proc getClipRect*(surface: Surface; rect: ptr Rect) {.
    cdecl, importc: "SDL_GetClipRect", dynlib: SDL2_LIB.}
  ##  Gets the clipping rectangle for the destination surface in a blit.
  ##
  ##  ``rect`` must be a pointer to a valid rectangle which will be filled
  ##  with the correct values.

proc convertSurface*(
    src: Surface; fmt: ptr PixelFormat; flags: uint32): Surface {.
      cdecl, importc: "SDL_ConvertSurface", dynlib: SDL2_LIB.}
  ##  Creates a new surface of the specified format, and then copies and maps
  ##  the given surface to it so the blit of the converted surface will be as
  ##  fast as possible.  If this procedure fails, it returns `nil`.
  ##
  ##  The `flags` parameter is passed to ``createRGBSurface()`` and has those
  ##  semantics.  You can also pass `RLEACCEL` in the flags parameter and
  ##  SDL will try to RLE accelerate colorkey and alpha blits in the resulting
  ##  surface.

proc convertSurfaceFormat*(
    src: Surface; pixel_format: uint32; flags: uint32): Surface {.
      cdecl, importc: "SDL_ConvertSurfaceFormat", dynlib: SDL2_LIB.}

proc convertPixels*(
    width: cint; height: cint;
    src_format: uint32; src: pointer; src_pitch: cint;
    dst_format: uint32; dst: pointer; dst_pitch: cint): cint {.
      cdecl, importc: "SDL_ConvertPixels", dynlib: SDL2_LIB.}
  ##  Copy a block of pixels of one format to another format.
  ##
  ##  ``Return`` `0` on success, or `-1` if there was an error.

proc fillRect*(
    dst: Surface; rect: ptr Rect; color: uint32): cint {.
      cdecl, importc: "SDL_FillRect", dynlib: SDL2_LIB.}
  ##  Performs a fast fill of the given rectangle with ``color``.
  ##
  ##  If ``rect`` is `nil`, the whole surface will be filled with ``color``.
  ##
  ##  The color should be a pixel of the format used by the surface, and
  ##  can be generated by the ``mapRGB()`` procedure.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc fillRects*(
    dst: Surface; rects: ptr Rect; count: cint; color: uint32): cint {.
      cdecl, importc: "SDL_FillRects", dynlib: SDL2_LIB.}

template blitSurface*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint = ##  \
  ##  Performs a fast blit from the source surface to the destination surface.
  ##
  ##  This assumes that the source and destination rectangles are
  ##  the same size.  If either ``srcrect`` or ``dstrect`` are `nil`,
  ##  the entire surface (``src`` or ``dst``) is copied.
  ##  The final blit rectangles are saved in ``srcrect`` and ``dstrect``
  ##  after all clipping is performed.
  ##
  ##  ``Return`` If the blit is successful, it returns `0`,
  ##  otherwise it returns `-1`.
  ##
  ##  The blit procedure should not be called on a locked surface.
  ##
  ##  The blit semantics for surfaces with and without blending and colorkey
  ##  are defined as follows:
  ##
  ##   ``RGBA->RGB``:
  ##
  ##     Source surface blend mode set to `BLENDMODE_BLEND`:
  ##
  ##       alpha-blend (using the source alpha-channel and per-surface alpha)
  ##       `SRCCOLORKEY` ignored.
  ##
  ##     Source surface blend mode set to `BLENDMODE_NONE`:
  ##
  ##       copy RGB.
  ##
  ##       if `SRCCOLORKEY` set, only copy the pixels matching the RGB values
  ##       of the source color key, ignoring alpha in the comparison.
  ##
  ##   ``RGB->RGBA``:
  ##
  ##     Source surface blend mode set to `BLENDMODE_BLEND`:
  ##
  ##       alpha-blend (using the source per-surface alpha)
  ##
  ##     Source surface blend mode set to `BLENDMODE_NONE`:
  ##
  ##       copy RGB, set destination alpha to source per-surface alpha value.
  ##
  ##     both:
  ##
  ##       if `SRCCOLORKEY` set, only copy the pixels matching the
  ##       source color key.
  ##
  ##   ``RGBA->RGBA``:
  ##
  ##     Source surface blend mode set to `BLENDMODE_BLEND`:
  ##
  ##       alpha-blend (using the source alpha-channel and per-surface alpha)
  ##       `SRCCOLORKEY` ignored.
  ##
  ##     Source surface blend mode set to `BLENDMODE_NONE`:
  ##
  ##       copy all of RGBA to the destination.
  ##
  ##       if `SRCCOLORKEY` set, only copy the pixels matching the RGB values
  ##       of the source color key, ignoring alpha in the comparison.
  ##
  ##   ``RGB->RGB``:
  ##
  ##     Source surface blend mode set to `BLENDMODE_BLEND`:
  ##
  ##       alpha-blend (using the source per-surface alpha)
  ##
  ##     Source surface blend mode set to `BLENDMODE_NONE`:
  ##
  ##       copy RGB.
  ##
  ##     both:
  ##
  ##       if `SRCCOLORKEY` set, only copy the pixels matching the
  ##       source color key.
  ##
  ##  You should call ``blitSurface()`` unless you know exactly how SDL
  ##  blitting works internally and how to use the other blit procedures.
  upperBlit(src, srcrect, dst, dstrect)

proc upperBlit*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint {.
      cdecl, importc: "SDL_UpperBlit", dynlib: SDL2_LIB.}
  ##  This is the public blit procedure, ``blitSurface()``, and it performs
  ##  rectangle validation and clipping before passing it to ``lowerBlit()``.

proc lowerBlit*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint {.
      cdecl, importc: "SDL_LowerBlit", dynlib: SDL2_LIB.}
  ##  This is a semi-private blit procedure and it performs low-level surface
  ##  blitting only.

proc softStretch*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint {.
      cdecl, importc: "SDL_SoftStretch", dynlib: SDL2_LIB.}
  ##  Perform a fast, low quality, stretch blit between two surfaces of the
  ##  same pixel format.
  ##
  ##  ``Note:`` This procedure uses a static buffer, and is not thread-safe.

template blitScaled*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint =
  upperBlitScaled(src, srcrect, dst, dstrect)

proc upperBlitScaled*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint {.
      cdecl, importc: "SDL_UpperBlitScaled", dynlib: SDL2_LIB.}
  ##  This is the public scaled blit procedure, ``blitScaled()``,
  ##  and it performs rectangle validation and clipping before
  ##  passing it to ``lowerBlitScaled()``.

proc lowerBlitScaled*(
    src: Surface; srcrect: ptr Rect;
    dst: Surface; dstrect: ptr Rect): cint {.
      cdecl, importc: "SDL_LowerBlitScaled", dynlib: SDL2_LIB.}
  ##  This is a semi-private blit procedure and it performs low-level surface
  ##  scaled blitting only.
