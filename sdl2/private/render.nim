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

##  render.nim
##  ==========
##
##  Header file for SDL 2D rendering procedures.

##  This API supports the following features:
##  * single pixel points
##  * single pixel lines
##  * filled rectangles
##  * texture images
##
##  The primitives may be drawn in opaque, blended, or additive modes.
##
##  The texture images may be drawn in opaque, blended, or additive modes.
##  They can have an additional color tint or alpha modulation applied to
##  them, and may also be stretched with linear interpolation.
##
##  This API is designed to accelerate simple 2D operations. You may
##  want more functionality such as polygons and particle effects and
##  in that case you should use SDL's OpenGL/Direct3D support or one
##  of the many good 3D engines.
##
##  These procedures must be called from the main thread.
##  See this bug for details: http://bugzilla.libsdl.org/show_bug.cgi?id=1995

#type
#  RendererFlags* {.size: sizeof(cint).} = enum ##  \
#    ##  Flags used when creating a rendering context
#    RENDERER_SOFTWARE = 0x00000001, ##  \
#      ##  The renderer is a software fallback
#    RENDERER_ACCELERATED = 0x00000002, ##  \
#      ##  The renderer uses hardware acceleration
#    RENDERER_PRESENTVSYNC = 0x00000004, ##  \
#      ##  Present is synchronized with the refresh rate
#    RENDERER_TARGETTEXTURE = 0x00000008 ##  \
#      ##  Ther render supports rendering to texture

# RendererFlags
# Flags used when creating a rendering context
const
  RENDERER_SOFTWARE* = 0x00000001 ##  \
    ##  The renderer is a software fallback
  RENDERER_ACCELERATED* = 0x00000002  ##  \
    ##  The renderer uses hardware acceleration
  RENDERER_PRESENTVSYNC* = 0x00000004 ##  \
    ##  Present is synchronized with the refresh rate
  RENDERER_TARGETTEXTURE* = 0x00000008  ##  \
    ##  Ther render supports rendering to texture

type
  RendererInfo* = object ##  \
    ##  Information on the capabilities of a render driver or context
    name*: cstring                ## The name of the renderer
    flags*: uint32                ## Supported ``RendererFlags``
    num_texture_formats*: uint32  ## The number of available texture formats
    texture_formats*: array[16, uint32] ## The available texture formats
    max_texture_width*: cint      ## The maximum texture width
    max_texture_height*: cint     ## The maximum texture height

#type
#  TextureAccess* {.size: sizeof(cint).} = enum ##  \
#    ##  The access pattern allowed for a texture
#    TEXTUREACCESS_STATIC,    ## Changes rarely, not lockable
#    TEXTUREACCESS_STREAMING, ## Changes frequently, lockable
#    TEXTUREACCESS_TARGET     ## Texture can be used as a render target

# TextureAccess
# The access pattern allowed for a texture
type
  TextureAccess* {.size: sizeof(cint).} = enum ##  \
    ##  The access pattern allowed for a texture
    TEXTUREACCESS_STATIC = 0x00000000 ## Changes rarely, not lockable
    TEXTUREACCESS_STREAMING = 0x00000001 ## Changes frequently, lockable
    TEXTUREACCESS_TARGET = 0x00000002 ## Texture can be used as a render target

type
  TextureModulate* {.size: sizeof(cint).} = enum ##  \
    ##  The texture channel modulation used in ``renderCopy()``
    TEXTUREMODULATE_NONE  = 0x00000000, ## No modulation
    TEXTUREMODULATE_COLOR = 0x00000001, ## srcC = srcC * color
    TEXTUREMODULATE_ALPHA = 0x00000002  ## srcA = srcA * alpha

type
  RendererFlip* {.size: sizeof(cint).} = enum ##  \
    ##  Flip constants for ``renderCopyEx()``
    FLIP_NONE       = 0x00000000, ## Do not flip
    FLIP_HORIZONTAL = 0x00000001, ## flip horizontally
    FLIP_VERTICAL   = 0x00000002, ## flip vertically
    FLIP_BOTH       = 0x00000003  ## flip horizontally and vertically

type
  Renderer* = pointer ##  \
    ##  An object representing rendering state

type
  Texture* = pointer ##  \
    ##  An efficient driver-specific representation of pixel data

# Procedures

proc getNumRenderDrivers*(): cint {.
    cdecl, importc: "SDL_GetNumRenderDrivers", dynlib: SDL2_LIB.}
  ##  Get the number of 2D rendering drivers available for the current display.
  ##
  ##  A render driver is a set of code that handles rendering and texture
  ##  management on a particular display.  Normally there is only one, but
  ##  some drivers may have several available with different capabilities.
  ##
  ##  See also:
  ##
  ##  ``getRenderDriverInfo()``
  ##
  ##  ``createRenderer()``

proc getRenderDriverInfo*(index: cint; info: ptr RendererInfo): cint {.
    cdecl, importc: "SDL_GetRenderDriverInfo", dynlib: SDL2_LIB.}
  ##  Get information about a specific 2D rendering driver
  ##  for the current display.
  ##
  ##  ``index`` The index of the driver to query information about.
  ##
  ##  ``info`` A pointer to an RendererInfo struct to be filled with
  ##  information on the rendering driver.
  ##
  ##  ``Return`` `0` on success, `-1` if the index was out of range.
  ##
  ##  See also:
  ##
  ##  ``ceateRenderer()``

proc createWindowAndRenderer*(
    width: cint; height: cint; window_flags: uint32;
    window: ptr Window; renderer: ptr Renderer): cint {.
      cdecl, importc: "SDL_CreateWindowAndRenderer", dynlib: SDL2_LIB.}
  ##  Create a window and default renderer.
  ##
  ##  ``width`` The width of the window.
  ##
  ##  ``height`` The height of the window.
  ##
  ##  ``window_flags`` The flags used to create the window.
  ##
  ##  ``window`` A pointer filled with the window, or `nil` on error.
  ##
  ##  ``renderer`` A pointer filled with the renderer, or `nil` on error.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc createRenderer*(window: Window; index: cint; flags: uint32): Renderer {.
    cdecl, importc: "SDL_CreateRenderer", dynlib: SDL2_LIB.}
  ##  Create a 2D rendering context for a window.
  ##
  ##  ``window`` The window where rendering is displayed.
  ##
  ##  ``index`` The index of the rendering driver to initialize,
  ##  or `-1` to initialize the first one supporting the requested flags.
  ##
  ##  ``flags`` ``RendererFlags``.
  ##
  ##  ``Return`` a valid rendering context or `nil` if there was an error.
  ##
  ##  See also:
  ##
  ##  ``createSoftwareRenderer()``
  ##
  ##  ``getRendererInfo()``
  ##
  ##  ``destroyRenderer()``

proc createSoftwareRenderer*(surface: Surface): Renderer {.
    cdecl, importc: "SDL_CreateSoftwareRenderer", dynlib: SDL2_LIB.}
  ##  Create a 2D software rendering context for a surface.
  ##
  ##  ``surface`` The surface where rendering is done.
  ##
  ##  ``Return`` a valid rendering context or `nil` if there was an error.
  ##
  ##  See also:
  ##
  ##  ``createRenderer()``
  ##
  ##  ``destroyRenderer()``

proc getRenderer*(window: Window): Renderer {.
    cdecl, importc: "SDL_GetRenderer", dynlib: SDL2_LIB.}
  ##  Get the renderer associated with a window.

proc getRendererInfo*(renderer: Renderer; info: ptr RendererInfo): cint {.
    cdecl, importc: "SDL_GetRendererInfo", dynlib: SDL2_LIB.}
  ##  Get information about a rendering context.

proc getRendererOutputSize*(
    renderer: Renderer; w: ptr cint; h: ptr cint): cint {.
      cdecl, importc: "SDL_GetRendererOutputSize", dynlib: SDL2_LIB.}
  ##  Get the output size in pixels of a rendering context.

proc createTexture*(renderer: Renderer;
    format: uint32; access: TextureAccess; w: cint; h: cint): Texture {.
      cdecl, importc: "SDL_CreateTexture", dynlib: SDL2_LIB.}
  ##  Create a texture for a rendering context.
  ##
  ##  ``renderer`` The renderer.
  ##
  ##  ``format`` The format of the texture.
  ##
  ##  ``access`` One of the enumerated values in ``TextureAccess``.
  ##
  ##  ``w`` The width of the texture in pixels.
  ##
  ##  ``h`` The height of the texture in pixels.
  ##
  ##  ``Return`` The created texture is returned, or `nil` if no rendering
  ##  context was active, the format was unsupported, or the width or height
  ##  were out of range.
  ##
  ##  See also:
  ##
  ##  ``queryTexture()``
  ##
  ##  ``updateTexture()``
  ##
  ##  ``destroyTexture()``

proc createTextureFromSurface*(
    renderer: Renderer; surface: Surface): Texture {.
      cdecl, importc: "SDL_CreateTextureFromSurface", dynlib: SDL2_LIB.}
  ##  Create a texture from an existing surface.
  ##
  ##  ``renderer`` The renderer.
  ##
  ##  ``surface`` The surface containing pixel data used to fill the texture.
  ##
  ##  ``Return`` The created texture is returned, or `nil` on error.
  ##
  ##  ``Note:`` The surface is not modified or freed by this procedure.
  ##
  ##  See also:
  ##
  ##  ``queryTexture()``
  ##
  ##  ``destroyTexture()``

proc queryTexture*(texture: Texture;
    format: ptr uint32; access: ptr TextureAccess;
      w: ptr cint; h: ptr cint): cint {.
      cdecl, importc: "SDL_QueryTexture", dynlib: SDL2_LIB.}
  ##  Query the attributes of a texture.
  ##
  ##  ``texture`` A texture to be queried.
  ##
  ##  ``format``  A pointer filled in with the raw format of the texture.
  ##  The actual format may differ, but pixel transfers will use this format.
  ##
  ##  ``access`` A pointer filled in with the actual access to the texture.
  ##
  ##  ``w`` A pointer filled in with the width of the texture in pixels.
  ##
  ##  ``h`` A pointer filled in with the height of the texture in pixels.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid.

proc setTextureColorMod*(
    texture: Texture; r: uint8; g: uint8; b: uint8): cint {.
      cdecl, importc: "SDL_SetTextureColorMod", dynlib: SDL2_LIB.}
  ##  Set an additional color value used in render copy operations.
  ##
  ##  ``texture`` The texture to update.
  ##
  ##  ``r`` The red color value multiplied into copy operations.
  ##
  ##  ``g`` The green color value multiplied into copy operations.
  ##
  ##  ``b`` The blue color value multiplied into copy operations.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid or
  ##  color modulation is not supported.
  ##
  ##  See also:
  ##
  ##  ``getTextureColorMod()``

template setTextureColorMod*(texture: Texture; color: Color): untyped =
  setTextureColorMod(texture, color.r, color.g, color.b)

proc getTextureColorMod*(
    texture: Texture; r: ptr uint8; g: ptr uint8; b: ptr uint8): cint {.
      cdecl, importc: "SDL_GetTextureColorMod", dynlib: SDL2_LIB.}
  ##  Get the additional color value used in render copy operations.
  ##
  ##  ``texture`` The texture to query.
  ##
  ##  ``r`` A pointer filled in with the current red color value.
  ##
  ##  ``g`` A pointer filled in with the current green color value.
  ##
  ##  ``b`` A pointer filled in with the current blue color value.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid.
  ##
  ##  See also:
  ##
  ##  ``setTextureColorMod()``

template getTextureColorMod*(texture: Texture, color: Color): untyped =
  getTextureColorMod(texture,
    addr(color.r), addr(color.g), addr(color.b))

proc setTextureAlphaMod*(texture: Texture; alpha: uint8): cint {.
    cdecl, importc: "SDL_SetTextureAlphaMod", dynlib: SDL2_LIB.}
  ##  Set an additional alpha value used in render copy operations.
  ##
  ##  ``texture`` The texture to update.
  ##
  ##  ``alpha`` The alpha value multiplied into copy operations.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid or
  ##  alpha modulation is not supported.
  ##
  ##  See also:
  ##
  ##  ``getTextureAlphaMod()``

proc getTextureAlphaMod*(texture: Texture; alpha: ptr uint8): cint {.
    cdecl, importc: "SDL_GetTextureAlphaMod", dynlib: SDL2_LIB.}
  ##  Get the additional alpha value used in render copy operations.
  ##
  ##  ``texture`` The texture to query.
  ##
  ##  ``alpha`` A pointer filled in with the current alpha value.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid.
  ##
  ##  See also:
  ##
  ##  ``setTextureAlphaMod()``

proc setTextureBlendMode*(texture: Texture; blendMode: BlendMode): cint {.
    cdecl, importc: "SDL_SetTextureBlendMode", dynlib: SDL2_LIB.}
  ##  Set the blend mode used for texture copy operations.
  ##
  ##  ``texture`` The texture to update.
  ##
  ##  ``blendMode`` ``BlendMode`` to use for texture blending.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid or
  ##  the blend mode is not supported.
  ##
  ##  ``Note:`` If the blend mode is not supported,
  ##  the closest supported mode is chosen.
  ##
  ##  See also:
  ##
  ##  ``getTextureBlendMode()``

proc getTextureBlendMode*(texture: Texture; blendMode: ptr BlendMode): cint {.
    cdecl, importc: "SDL_GetTextureBlendMode", dynlib: SDL2_LIB.}
  ##  Get the blend mode used for texture copy operations.
  ##
  ##  ``texture`` The texture to query.
  ##
  ##  ``blendMode`` A pointer filled in with the current blend mode.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid.
  ##
  ##  See also:
  ##
  ##  ``setTextureBlendMode()``

proc updateTexture*(
    texture: Texture; rect: ptr Rect; pixels: pointer; pitch: cint): cint {.
      cdecl, importc: "SDL_UpdateTexture", dynlib: SDL2_LIB.}
  ##  Update the given texture rectangle with new pixel data.
  ##
  ##  ``texture`` The texture to update
  ##
  ##  ``rect`` A pointer to the rectangle of pixels to update, or `nil` to
  ##  update the entire texture.
  ##
  ##  ``pixels`` The raw pixel data.
  ##
  ##  ``pitch`` The number of bytes in a row of pixel data,
  ##  including padding between lines.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid.
  ##
  ##  ``Note:`` This is a fairly slow procedure.

proc updateYUVTexture*(
    texture: Texture; rect: ptr Rect;
    yPlane: ptr uint8; yPitch: cint;
    uPlane: ptr uint8; uPitch: cint;
    vPlane: ptr uint8; vPitch: cint): cint {.
      cdecl, importc: "SDL_UpdateYUVTexture", dynlib: SDL2_LIB.}
  ##  Update a rectangle within a planar YV12 or IYUV texture
  ##  with new pixel data.
  ##
  ##  ``texture`` The texture to update
  ##
  ##  ``rect`` A pointer to the rectangle of pixels to update,
  ##  or `nil` to update the entire texture.
  ##
  ##  ``yPlane`` The raw pixel data for the Y plane.
  ##
  ##  ``yPitch`` The number of bytes between rows of pixel data for the Y plane.
  ##
  ##  ``uPlane`` The raw pixel data for the U plane.
  ##
  ##  ``uPitch`` The number of bytes between rows of pixel data for the U plane.
  ##
  ##  ``vPlane`` The raw pixel data for the V plane.
  ##
  ##  ``vPitch`` The number of bytes between rows of pixel data for the V plane.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid.
  ##
  ##  ``Note:`` You can use ``updateTexture()`` as long as your pixel data is
  ##  a contiguous block of Y and U/V planes in the proper order,
  ##  but this procedure is available if your pixel data is not contiguous.

proc lockTexture*(
    texture: Texture; rect: ptr Rect;
    pixels: ptr pointer; pitch: ptr cint): cint {.
      cdecl, importc: "SDL_LockTexture", dynlib: SDL2_LIB.}
  ##  Lock a portion of the texture for write-only pixel access.
  ##
  ##  ``texture`` The texture to lock for access,
  ##  which was created with `TEXTUREACCESS_STREAMING`.
  ##
  ##  ``rect`` A pointer to the rectangle to lock for access.
  ##  If the rect is `nil`, the entire texture will be locked.
  ##
  ##  ``pixels`` This is filled in with a pointer to the locked pixels,
  ##  appropriately offset by the locked area.
  ##
  ##  ``pitch`` This is filled in with the pitch of the locked pixels.
  ##
  ##  ``Return`` `0` on success, or `-1` if the texture is not valid or
  ##  was not created with `TEXTUREACCESS_STREAMING`.
  ##
  ##  See also:
  ##
  ##  ``unlockTexture()``

proc unlockTexture*(texture: Texture) {.
    cdecl, importc: "SDL_UnlockTexture", dynlib: SDL2_LIB.}
  ##  Unlock a texture, uploading the changes to video memory, if needed.
  ##
  ##  See also:
  ##
  ##  ``lockTexture()``

proc renderTargetSupported*(renderer: Renderer): bool {.
    cdecl, importc: "SDL_RenderTargetSupported", dynlib: SDL2_LIB.}
  ##  Determines whether a window supports the use of render targets.
  ##
  ##  ``renderer`` The renderer that will be checked.
  ##
  ##  ``Return`` `true` if supported, `false` if not.

proc setRenderTarget*(renderer: Renderer; texture: Texture): cint {.
    cdecl, importc: "SDL_SetRenderTarget", dynlib: SDL2_LIB.}
  ##  Set a texture as the current rendering target.
  ##
  ##  ``renderer`` The renderer.
  ##
  ##  ``texture`` The targeted texture, which must be created with the
  ##  `TEXTUREACCESS_TARGET`` flag, or `nil` for the default render target
  ##
  ##  ``Return`` `0` on success, or `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``getRenderTarget()``

proc getRenderTarget*(renderer: Renderer): Texture {.
    cdecl, importc: "SDL_GetRenderTarget", dynlib: SDL2_LIB.}
  ##  Get the current render target or `nil` for the default render target.
  ##
  ##  ``Return`` The current render target.
  ##
  ##  See also:
  ##
  ##  ``setRenderTarget()``

proc renderSetLogicalSize*(renderer: Renderer; w: cint; h: cint): cint {.
    cdecl, importc: "SDL_RenderSetLogicalSize", dynlib: SDL2_LIB.}
  ##  Set device independent resolution for rendering.
  ##
  ##  ``renderer`` The renderer for which resolution should be set.
  ##
  ##  ``w`` The width of the logical resolution
  ##
  ##  ``h`` The height of the logical resolution
  ##
  ##  This procedure uses the viewport and scaling functionality to allow a
  ##  fixed logical resolution for rendering, regardless of the actual output
  ##  resolution. If the actual  output resolution doesn't have the same aspect
  ##  ratio the output rendering will be centered within the output display.
  ##
  ##  If the output display is a window, mouse events in the window will be
  ##  filtered and scaled so they seem to arrive within the logical resolution.
  ##
  ##  ``Note:`` If this procedure results in scaling or subpixel drawing by the
  ##  rendering backend, it will be handled using the appropriate quality hints.
  ##
  ##  ``Return`` `0` on success or a negative error code on failure.
  ##
  ##  See also:
  ##
  ##  ``renderGetLogicalSize()``
  ##
  ##  ``renderSetScale()``
  ##
  ##  ``renderSetViewport()``

proc renderGetLogicalSize*(renderer: Renderer; w: ptr cint; h: ptr cint) {.
    cdecl, importc: "SDL_RenderGetLogicalSize", dynlib: SDL2_LIB.}
  ##  Get device independent resolution for rendering.
  ##
  ##  ``renderer`` The renderer from which resolution should be queried.
  ##
  ##  ``w`` A pointer filled with the width of the logical resolution.
  ##
  ##  ``h`` A pointer filled with the height of the logical resolution.
  ##
  ##  See also:
  ##
  ##  ``renderSetLogicalSize()``

proc renderSetIntegerScale*(renderer: Renderer; enable: bool): cint {.
    cdecl, importc: "SDL_RenderSetIntegerScale", dynlib: SDL2_LIB.}
  ##  Set whether to force integer scales for resolution-independent rendering.
  ##
  ##  ``renderer`` The renderer for which integer scaling should be set.
  ##
  ##  ``enable`` Enable or disable integer scaling
  ##
  ##  This function restricts the logical viewport to integer values -
  ##  that is, when a resolution is between two multiples of a logical size,
  ##  the viewport size is rounded down to the lower multiple.
  ##
  ##  See also:
  ##
  ##  ``renderSetLogicalSize()``

proc renderGetIntegerScale*(renderer: Renderer): bool {.
    cdecl, importc: "SDL_RenderGetIntegerScale", dynlib: SDL2_LIB.}
  ##  Get whether integer scales are forced for
  ##  resolution-independent rendering.
  ##
  ##  ``renderer`` The renderer from which integer scaling should be queried.
  ##
  ##  See also:
  ##
  ##  ``renderSetIntegerScale()``

proc renderSetViewport*(renderer: Renderer; rect: ptr Rect): cint {.
    cdecl, importc: "SDL_RenderSetViewport", dynlib: SDL2_LIB.}
  ##  Set the drawing area for rendering on the current target.
  ##
  ##  ``renderer`` The renderer for which the drawing area should be set.
  ##
  ##  ``rect`` The rectangle representing the drawing area, or `nil` to set
  ##  the viewport to the entire target.
  ##
  ##  The `x`,`y` of the viewport rect represents the origin for rendering.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.
  ##
  ##  ``Note:`` If the window associated with the renderer is resized,
  ##  the viewport is automatically reset.
  ##
  ##  See also:
  ##
  ##  ``renderGetViewport()``
  ##
  ##  ``renderSetLogicalSize()``

proc renderGetViewport*(renderer: Renderer; rect: ptr Rect) {.
    cdecl, importc: "SDL_RenderGetViewport", dynlib: SDL2_LIB.}
  ##  Get the drawing area for the current target.
  ##
  ##  See also:
  ##
  ##  ``renderSetViewport()``

proc renderSetClipRect*(renderer: Renderer; rect: ptr Rect): cint {.
    cdecl, importc: "SDL_RenderSetClipRect", dynlib: SDL2_LIB.}
  ##  Set the clip rectangle for the current target.
  ##
  ##  ``renderer`` The renderer for which clip rectangle should be set.
  ##
  ##  ``rect`` A pointer to the rectangle to set as the clip rectangle,
  ##  or `nil` to disable clipping.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``renderGetClipRect()``

proc renderGetClipRect*(renderer: Renderer; rect: ptr Rect) {.
    cdecl, importc: "SDL_RenderGetClipRect", dynlib: SDL2_LIB.}
  ##  Get the clip rectangle for the current target.
  ##
  ##  ``renderer`` The renderer from which clip rectangle should be queried.
  ##
  ##  ``rect`` A pointer filled in with the current clip rectangle,
  ##  or an empty rectangle if clipping is disabled.
  ##
  ##  See also:
  ##
  ##  ``renderSetClipRect()``

proc renderIsClipEnabled*(renderer: Renderer): bool {.
    cdecl, importc: "SDL_RenderIsClipEnabled", dynlib: SDL2_LIB.}
  ##  Get whether clipping is enabled on the given renderer.
  ##
  ##  ``renderer`` The renderer from which clip state should be queried.
  ##
  ##  See also:
  ##
  ##  ``renderGetClipRect()``

proc renderSetScale*(
    renderer: Renderer; scaleX: cfloat; scaleY: cfloat): cint {.
      cdecl, importc: "SDL_RenderSetScale", dynlib: SDL2_LIB.}
  ##  Set the drawing scale for rendering on the current target.
  ##
  ##  ``renderer`` The renderer for which the drawing scale should be set.
  ##
  ##  ``scaleX`` The horizontal scaling factor.
  ##
  ##  ``scaleY`` The vertical scaling factor.
  ##
  ##  The drawing coordinates are scaled by the x/y scaling factors
  ##  before they are used by the renderer.  This allows resolution
  ##  independent drawing with a single coordinate system.
  ##
  ##  ``Note:`` If this results in scaling or subpixel drawing by the rendering
  ##  backend, it will be handled using the appropriate quality hints.
  ##  For best results use integer scaling factors.
  ##
  ##  See also:
  ##
  ##  ``renderGetScale()``
  ##
  ##  ``renderSetLogicalSize()``

proc renderGetScale*(
    renderer: Renderer; scaleX: ptr cfloat; scaleY: ptr cfloat) {.
      cdecl, importc: "SDL_RenderGetScale", dynlib: SDL2_LIB.}
  ##  Get the drawing scale for the current target.
  ##
  ##  ``renderer`` The renderer from which drawing scale should be queried.
  ##
  ##  ``scaleX`` A pointer filled in with the horizontal scaling factor.
  ##
  ##  ``scaleY`` A pointer filled in with the vertical scaling factor.
  ##
  ##  See also:
  ##
  ##  ``renderSetScale()``

proc setRenderDrawColor*(renderer: Renderer;
    r: uint8; g: uint8; b: uint8; a: uint8): cint {.
      cdecl, importc: "SDL_SetRenderDrawColor", dynlib: SDL2_LIB.}
  ##  Set the color used for drawing operations (Rect, Line and Clear).
  ##
  ##  ``renderer`` The renderer for which drawing color should be set.
  ##
  ##  ``r`` The red value used to draw on the rendering target.
  ##
  ##  ``g`` The green value used to draw on the rendering target.
  ##
  ##  ``b`` The blue value used to draw on the rendering target.
  ##
  ##  ``a`` The alpha value used to draw on the rendering target,
  ##  usually `ALPHA_OPAQUE` (`255`).
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

template setRenderDrawColor*(renderer: Renderer; color: Color): untyped =
  setRenderDrawColor(renderer, color.r, color.g, color.b, color.a)

proc getRenderDrawColor*(renderer: Renderer;
    r: ptr uint8; g: ptr uint8; b: ptr uint8; a: ptr uint8): cint {.
      cdecl, importc: "SDL_GetRenderDrawColor", dynlib: SDL2_LIB.}
  ##  Get the color used for drawing operations (Rect, Line and Clear).
  ##
  ##  ``renderer`` The renderer from which drawing color should be queried.
  ##
  ##  ``r`` A pointer to the red value used to draw on the rendering target.
  ##
  ##  ``g`` A pointer to the green value used to draw on the rendering target.
  ##
  ##  ``b`` A pointer to the blue value used to draw on the rendering target.
  ##
  ##  ``a`` A pointer to the alpha value used to draw on the rendering target,
  ##  usually `ALPHA_OPAQUE` (`255`).
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

template getRenderDrawColor*(renderer: Renderer; color: Color): untyped =
  getRenderDrawColor(renderer,
    addr(color.r), addr(color.g), addr(color.b), addr(color.a))

proc setRenderDrawBlendMode*(renderer: Renderer; blendMode: BlendMode): cint {.
    cdecl, importc: "SDL_SetRenderDrawBlendMode", dynlib: SDL2_LIB.}
  ##  Set the blend mode used for drawing operations (Fill and Line).
  ##
  ##  ``renderer`` The renderer for which blend mode should be set.
  ##
  ##  ``blendMode`` ``BlendMode`` to use for blending.
  ##
  ##  ``Return`` `0` on success, or `-1` on error
  ##
  ##  ``Note:`` If the blend mode is not supported,
  ##  the closest supported mode is chosen.
  ##
  ##  See also:
  ##
  ##  ``getRenderDrawBlendMode()``

proc getRenderDrawBlendMode*(
    renderer: Renderer; blendMode: ptr BlendMode): cint {.
      cdecl, importc: "SDL_GetRenderDrawBlendMode", dynlib: SDL2_LIB.}
  ##  Get the blend mode used for drawing operations.
  ##
  ##  ``renderer`` The renderer from which blend mode should be queried.
  ##
  ##  ``blendMode`` A pointer filled in with the current blend mode.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``setRenderDrawBlendMode()``

proc renderClear*(renderer: Renderer): cint {.
    cdecl, importc: "SDL_RenderClear", dynlib: SDL2_LIB.}
  ##  Clear the current rendering target with the drawing color.
  ##
  ##  This procedure clears the entire rendering target, ignoring the viewport,
  ##  and the clip rectangle.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderDrawPoint*(renderer: Renderer; x: cint; y: cint): cint {.
    cdecl, importc: "SDL_RenderDrawPoint", dynlib: SDL2_LIB.}
  ##  Draw a point on the current rendering target.
  ##
  ##  ``renderer`` The renderer which should draw a point.
  ##
  ##  ``x`` The x coordinate of the point.
  ##
  ##  ``y`` The y coordinate of the point.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderDrawPoints*(
    renderer: Renderer; points: ptr Point; count: cint): cint {.
      cdecl, importc: "SDL_RenderDrawPoints", dynlib: SDL2_LIB.}
  ##  Draw multiple points on the current rendering target.
  ##
  ##  ``renderer`` The renderer which should draw multiple points.
  ##
  ##  ``points`` The points to draw.
  ##
  ##  ``count`` The number of points to draw.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderDrawLine*(
    renderer: Renderer; x1: cint; y1: cint; x2: cint; y2: cint): cint {.
      cdecl, importc: "SDL_RenderDrawLine", dynlib: SDL2_LIB.}
  ##  Draw a line on the current rendering target.
  ##
  ##  ``renderer`` The renderer which should draw a line.
  ##
  ##  ``x1`` The x coordinate of the start point.
  ##
  ##  ``y1`` The y coordinate of the start point.
  ##
  ##  ``x2`` The x coordinate of the end point.
  ##
  ##  ``y2`` The y coordinate of the end point.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderDrawLines*(
    renderer: Renderer; points: ptr Point; count: cint): cint {.
      cdecl, importc: "SDL_RenderDrawLines", dynlib: SDL2_LIB.}
  ##  Draw a series of connected lines on the current rendering target.
  ##
  ##  ``renderer`` The renderer which should draw multiple lines.
  ##
  ##  ``points`` The points along the lines.
  ##
  ##  ``count`` The number of points, drawing `count-1` lines.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderDrawRect*(renderer: Renderer; rect: ptr Rect): cint {.
    cdecl, importc: "SDL_RenderDrawRect", dynlib: SDL2_LIB.}
  ##  Draw a rectangle on the current rendering target.
  ##
  ##  ``renderer`` The renderer which should draw a rectangle.
  ##
  ##  ``rect`` A pointer to the destination rectangle,
  ##  or `nil` to outline the entire rendering target.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderDrawRects*(
    renderer: Renderer; rects: ptr Rect; count: cint): cint {.
      cdecl, importc: "SDL_RenderDrawRects", dynlib: SDL2_LIB.}
  ##  Draw some number of rectangles on the current rendering target.
  ##
  ##  ``renderer`` The renderer which should draw multiple rectangles.
  ##
  ##  ``rects`` A pointer to an array of destination rectangles.
  ##
  ##  ``count`` The number of rectangles.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderFillRect*(renderer: Renderer; rect: ptr Rect): cint {.
    cdecl, importc: "SDL_RenderFillRect", dynlib: SDL2_LIB.}
  ##  Fill a rectangle on the current rendering target with the drawing color.
  ##
  ##  ``renderer`` The renderer which should fill a rectangle.
  ##
  ##  ``rect`` A pointer to the destination rectangle,
  ##  or `nil` for the entire rendering target.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderFillRects*(
    renderer: Renderer; rects: ptr Rect; count: cint): cint {.
      cdecl, importc: "SDL_RenderFillRects", dynlib: SDL2_LIB.}
  ##  Fill some number of rectangles on the current rendering target
  ##  with the drawing color.
  ##
  ##  ``renderer`` The renderer which should fill multiple rectangles.
  ##
  ##  ``rects`` A pointer to an array of destination rectangles.
  ##
  ##  ``count`` The number of rectangles.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderCopy*(
    renderer: Renderer; texture: Texture;
    srcrect: ptr Rect; dstrect: ptr Rect): cint {.
      cdecl, importc: "SDL_RenderCopy", dynlib: SDL2_LIB.}
  ##  Copy a portion of the texture to the current rendering target.
  ##
  ##  ``renderer`` The renderer which should copy parts of a texture.
  ##
  ##  ``texture`` The source texture.
  ##
  ##  ``srcrect`` A pointer to the source rectangle,
  ##  or `nil` for the entire texture.
  ##
  ##  ``dstrect`` A pointer to the destination rectangle,
  ##  or `nil` for the entire rendering target.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderCopyEx*(
    renderer: Renderer; texture: Texture;
    srcrect: ptr Rect; dstrect: ptr Rect;
    angle: cdouble; center: ptr Point; flip: RendererFlip): cint {.
      cdecl, importc: "SDL_RenderCopyEx", dynlib: SDL2_LIB.}
  ##  Copy a portion of the source texture to the current rendering target,
  ##  rotating it by angle around the given center.
  ##
  ##  ``renderer`` The renderer which should copy parts of a texture.
  ##
  ##  ``texture`` The source texture.
  ##
  ##  ``srcrect`` A pointer to the source rectangle,
  ##  or `nil` for the entire texture.
  ##
  ##  ``dstrect`` A pointer to the destination rectangle,
  ##  or `nil` for the entire rendering target.
  ##
  ##  ``angle`` An angle in degrees that indicates the rotation
  ##  that will be applied to dstrect.
  ##
  ##  ``center`` A pointer to a point indicating the point
  ##  around which ``dstrect`` will be rotated
  ##  (if `nil`, rotation will be done around `dstrect.w/2`, `dstrect.h/2`).
  ##
  ##  ``flip`` ``RendererFlip`` value stating which flipping actions should be
  ##  performed on the texture.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.

proc renderReadPixels*(
    renderer: Renderer; rect: ptr Rect;
    format: uint32; pixels: pointer; pitch: cint): cint {.
      cdecl, importc: "SDL_RenderReadPixels", dynlib: SDL2_LIB.}
  ##  Read pixels from the current rendering target.
  ##
  ##  ``renderer`` The renderer from which pixels should be read.
  ##
  ##  ``rect`` A pointer to the rectangle to read,
  ##  or `nil` for the entire render target.
  ##
  ##  ``format`` The desired format of the pixel data,
  ##  or `0` to use the formatof the rendering target.
  ##
  ##  ``pixels`` A pointer to be filled in with the pixel data.
  ##
  ##  ``pitch`` The pitch of the pixels parameter.
  ##
  ##  ``Return`` `0` on success, or `-1` if pixel reading is not supported.
  ##
  ##  ``Warning:`` This is a very slow operation,
  ##  and should not be used frequently.

proc renderPresent*(renderer: Renderer) {.
    cdecl, importc: "SDL_RenderPresent", dynlib: SDL2_LIB.}
  ##  Update the screen with rendering performed.

proc destroyTexture*(texture: Texture) {.
    cdecl, importc: "SDL_DestroyTexture", dynlib: SDL2_LIB.}
  ##  Destroy the specified texture.
  ##
  ##  See also:
  ##
  ##  ``createTexture()``
  ##
  ##  ``createTextureFromSurface()``

proc destroyRenderer*(renderer: Renderer) {.
    cdecl, importc: "SDL_DestroyRenderer", dynlib: SDL2_LIB.}
  ##  Destroy the rendering context for a window and free associated textures.
  ##
  ##  See also:
  ##
  ##  ``createRenderer()``

proc glBindTexture*(
    texture: Texture; texw: ptr cfloat; texh: ptr cfloat): cint {.
      cdecl, importc: "SDL_GL_BindTexture", dynlib: SDL2_LIB.}
  ##  Bind the texture to the current OpenGL/ES/ES2 context for use
  ##  with OpenGL instructions.
  ##
  ##  ``texture`` The SDL texture to bind.
  ##
  ##  ``texw`` A pointer to a float that will be filled with the texture width.
  ##
  ##  ``texh`` A pointer to a float that will be filled with the texture height.
  ##
  ##  ``Return`` `0` on success, or `-1` if the operation is not supported.

proc glUnbindTexture*(texture: Texture): cint {.
    cdecl, importc: "SDL_GL_UnbindTexture", dynlib: SDL2_LIB.}
  ##  Unbind a texture from the current OpenGL/ES/ES2 context.
  ##
  ##  ``texture`` The SDL texture to unbind.
  ##
  ##  ``Return`` `0` on success, or `-1` if the operation is not supported.
