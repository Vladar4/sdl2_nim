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
#  Header file for SDL 2D rendering functions.
#
# This API supports the following features:
#     * single pixel points
#     * single pixel lines
#     * filled rectangles
#     * texture images
#
# The primitives may be drawn in opaque, blended, or additive modes.
#
# The texture images may be drawn in opaque, blended, or additive modes.
# They can have an additional color tint or alpha modulation applied to
# them, and may also be stretched with linear interpolation.
#
# This API is designed to accelerate simple 2D operations. You may
# want more functionality such as rotation and particle effects and
# in that case you should use SDL's OpenGL/Direct3D support or one
# of the many good 3D engines.
#


const
  # Flags used when creating a rendering context
  RENDERER_SOFTWARE*: Uint32 = 0x00000001 ## The renderer is a software fallback
  RENDERER_ACCELERATED*: Uint32 = 0x00000002 ## The renderer uses hardware acceleration
  RENDERER_PRESENTVSYNC*: Uint32 = 0x00000004 ## Present is synchronized with the refresh rate
  RENDERER_TARGETTEXTURE*: Uint32 = 0x00000008 ## The renderer supports rendering to texture

type
  PRendererInfo* = ptr TRendererInfo
  TRendererInfo* = object ## Information on the capabilities of a render driver or context.
    name*: cstring ## The name of the renderer
    flags*: Uint32 ## Supported rendererFlags
    num_texture_formats*: Uint32 ## The number of available texture formats
    texture_formats*: array[0..15, Uint32] ## The available texture formats
    max_texture_width*: int ## The maximimum texture width
    max_texture_height*: int ## The maximimum texture height


  TTextureAccess* = enum ## The access pattern allowed for a texture.
    TEXTUREACCESS_STATIC, ## Changes rarely, not lockable
    TEXTUREACCESS_STREAMING, ## Changes frequently, lockable
    TEXTUREACCESS_TARGET ## Texture can be used as a render target


  TTextureModulate* = enum ## The texture channel modulation used in renderCopy().
    TEXTUREMODULATE_NONE = 0x00000000, ## No modulation
    TEXTUREMODULATE_COLOR = 0x00000001, ## srcC = srcC * color
    TEXTUREMODULATE_ALPHA = 0x00000002 ## srcA = srcA * alpha


  TRendererFlip* = enum ## Flip constants for renderCopyEx
    FLIP_NONE = 0x00000000, ## Do not flip
    FLIP_HORIZONTAL = 0x00000001, ## flip horizontally
    FLIP_VERTICAL = 0x00000002 ## flip vertically


  ## A structure representing rendering state
  PRenderer* = pointer
  #struct SDL_Renderer;
  #typedef struct SDL_Renderer SDL_Renderer;

  ## An efficient driver-specific representation of pixel data
  PTexture* = pointer
  #struct SDL_Texture;
  #typedef struct SDL_Texture SDL_Texture;


# Function prototypes


proc getNumRenderDrivers*(): int {.cdecl, importc: "SDL_GetNumRenderDrivers", dynlib: LibName.}
  ## Get the number of 2D rendering drivers available for the current display.
  ##
  ## A render driver is a set of code that handles rendering and texture
  ## management on a particular display.  Normally there is only one, but
  ## some drivers may have several available with different capabilities.
  ##
  ## See also: getRenderDriverInfo(), 
  ## createRenderer()


proc getRenderDriverInfo*(index: int, info: PRendererInfo): int {.cdecl, importc: "SDL_GetRenderDriverInfo", dynlib: LibName.}
  ## Get information about a specific 2D rendering driver for the current display.
  ##
  ## ``index`` The index of the driver to query information about.
  ##
  ## ``info`` A pointer to an SDL_RendererInfo struct to be filled with
  ## information on the rendering driver.
  ##
  ## Return 0 on success, -1 if the index was out of range.
  ##
  ## See also: createRenderer()

proc createWindowAndRenderer*(width, height: int, window_flags: Uint32,
    window: ptr PWindow, renderer: ptr PRenderer): int {.cdecl, importc: "SDL_CreateWindowAndRenderer", dynlib: LibName.}
  ## Create a window and default renderer
  ##
  ## ``width`` The width of the window
  ##
  ## ``height`` The height of the window
  ##
  ## ``window_flags`` The flags used to create the window
  ##
  ## ``window`` A pointer filled with the window, or nil on error
  ##
  ## ``renderer`` A pointer filled with the renderer, or nil on error
  ##
  ## Return 0 on success, or -1 on error



proc createRenderer*(window: PWindow,
    index: int, flags: Uint32): PRenderer {.cdecl, importc: "SDL_CreateRenderer", dynlib: LibName.}
  ## Create a 2D rendering context for a window.
  ##
  ## ``window`` The window where rendering is displayed.
  ##
  ## ``index`` The index of the rendering driver to initialize, or -1 to
  ## initialize the first one supporting the requested flags.
  ##
  ## ``flags`` TRendererFlags.
  ##
  ## Return A valid rendering context or nil if there was an error.
  ##
  ## See also: createSoftwareRenderer(), 
  ## getRendererInfo(), 
  ## destroyRenderer()


proc createSoftwareRenderer*(surface: PSurface): PRenderer {.cdecl, importc: "SDL_CreateSoftwareRenderer", dynlib: LibName.}
  ## Create a 2D software rendering context for a surface.
  ##
  ## ``surface`` The surface where rendering is done.
  ##
  ## Return A valid rendering context or nil if there was an error.
  ##
  ## See also: createRenderer(),
  ## destroyRenderer()


proc getRenderer*(window: PWindow): PRenderer {.cdecl, importc: "SDL_GetRenderer", dynlib: LibName.}
  ## Get the renderer associated with a window.


proc getRendererInfo*(renderer: PRenderer, info: PRendererInfo): int {.cdecl, importc: "SDL_GetRendererInfo", dynlib: LibName.}
  ## Get information about a rendering context.


proc createTexture*(renderer: PRenderer,
    format: Uint32, access, w, h: int): PTexture {.cdecl, importc: "SDL_CreateTexture", dynlib: LibName.}
  ## Create a texture for a rendering context.
  ##
  ## ``renderer`` The renderer.
  ##
  ## ``format`` The format of the texture.
  ##
  ## ``access`` One of the enumerated values in TTextureAccess.
  ##
  ## ``w`` The width of the texture in pixels.
  ##
  ## ``h`` The height of the texture in pixels.
  ##
  ## Return The created texture is returned, or 0 if no rendering context was
  ## active,  the format was unsupported, or the width or height were out
  ## of range.
  ##
  ## See also: queryTexture(), 
  ## updateTexture(), 
  ## destroyTexture()


proc createTextureFromSurface*(renderer: PRenderer,
    surface: PSurface): PTexture {.cdecl, importc: "SDL_CreateTextureFromSurface", dynlib: LibName.}
  ## Create a texture from an existing surface.
  ##
  ## ``renderer`` The renderer.
  ##
  ## ``surface`` The surface containing pixel data used to fill the texture.
  ##
  ## Return The created texture is returned, or 0 on error.
  ##
  ## The surface is not modified or freed by this function.
  ##
  ## See also: queryTexture(),
  ## destroyTexture()

proc queryTexture*(texture: PTexture,
    format: ptr Uint32, access, w, h: ptr int): int {.cdecl, importc: "SDL_QueryTexture", dynlib: LibName.}
  ## Query the attributes of a texture
  ##
  ## ``texture`` A texture to be queried.
  ##
  ## ``format`` A pointer filled in with the raw format of the texture.  The
  ## actual format may differ, but pixel transfers will use this format.
  ##
  ## ``access`` A pointer filled in with the actual access to the texture.
  ##
  ## ``w`` A pointer filled in with the width of the texture in pixels.
  ##
  ## ``h`` A pointer filled in with the height of the texture in pixels.
  ##
  ## Return 0 on success, or -1 if the texture is not valid.


proc setTextureColorMod*(texture: PTexture,
    r, g, b: Uint8): int {.cdecl, importc: "SDL_SetTextureColorMod", dynlib: LibName.}
  ## Set an additional color value used in render copy operations.
  ##
  ## ``texture`` The texture to update.
  ##
  ## ``r`` The red color value multiplied into copy operations.
  ##
  ## ``g`` The green color value multiplied into copy operations.
  ##
  ## ``b`` The blue color value multiplied into copy operations.
  ##
  ## Return 0 on success, or -1 if the texture is not valid or color
  ## modulation is not supported.
  ##
  ## See also: getTextureColorMod()


proc getTextureColorMod*(texture: PTexture,
    r, g, b: ptr Uint8): int {.cdecl, importc: "SDL_GetTextureColorMod", dynlib: LibName.}
  ## Get the additional color value used in render copy operations.
  ##
  ## ``texture`` The texture to query.
  ##
  ## ``r`` A pointer filled in with the current red color value.
  ##
  ## ``g`` A pointer filled in with the current green color value.
  ##
  ## ``b`` A pointer filled in with the current blue color value.
  ##
  ## Return 0 on success, or -1 if the texture is not valid.
  ##
  ## See also: setTextureColorMod()


proc setTextureAlphaMod*(texture: PTexture, alpha: Uint8): int {.cdecl, importc: "SDL_SetTextureAlphaMod", dynlib: LibName.}
  ## Set an additional alpha value used in render copy operations.
  ##
  ## ``texture`` The texture to update.
  ##
  ## ``alpha`` The alpha value multiplied into copy operations.
  ##
  ## Return 0 on success, or -1 if the texture is not valid or alpha
  ## modulation is not supported.
  ##
  ## See also: getTextureAlphaMod()


proc getTextureAlphaMod*(texture: PTexture, alpha: ptr Uint8): int {.cdecl, importc: "SDL_GetTextureAlphaMod", dynlib: LibName.}
  ## Get the additional alpha value used in render copy operations.
  ##
  ## ``texture`` The texture to query.
  ##
  ## ``alpha`` A pointer filled in with the current alpha value.
  ##
  ## Return 0 on success, or -1 if the texture is not valid.
  ##
  ## See also: setTextureAlphaMod()


proc setTextureBlendMode*(texture: PTexture, blendMode: TBlendMode): int {.cdecl, importc: "SDL_SetTextureBlendMode", dynlib: LibName.}
  ## Set the blend mode used for texture copy operations.
  ##
  ## ``texture`` The texture to update.
  ##
  ## ``blendMode`` TBlendMode to use for texture blending.
  ##
  ## Return 0 on success, or -1 if the texture is not valid or the blend mode
  ## is not supported.
  ##
  ## If the blend mode is not supported, the closest supported mode is chosen.
  ##
  ## See also: getTextureBlendMode()


proc getTextureBlendMode*(texture: PTexture, blendMode: ptr TBlendMode): int {.cdecl, importc: "SDL_GetTextureBlendMode", dynlib: LibName.}
  ## Get the blend mode used for texture copy operations.
  ##
  ## ``texture`` The texture to query.
  ##
  ## ``blendMode`` A pointer filled in with the current blend mode.
  ##
  ## Return 0 on success, or -1 if the texture is not valid.
  ##
  ## See also: setTextureBlendMode()


proc updateTexture*(texture: PTexture,
    rect: PRect, pixels: pointer, pitch: int): int {.cdecl, importc: "SDL_UpdateTexture", dynlib: LibName.}
  ## Update the given texture rectangle with new pixel data.
  ##
  ## ``texture`` The texture to update
  ##
  ## ``rect`` A pointer to the rectangle of pixels to update, or nil to
  ## update the entire texture.
  ##
  ## ``pixels`` The raw pixel data.
  ##
  ## ``pitch`` The number of bytes between rows of pixel data.
  ##
  ## Return 0 on success, or -1 if the texture is not valid.
  ##
  ## This is a fairly slow function.


proc lockTexture*(texture: PTexture,
    rect: PRect, pixels: ptr pointer, pitch: ptr int): int {.cdecl, importc: "SDL_LockTexture", dynlib: LibName.}
  ## Lock a portion of the texture for write-only pixel access.
  ##
  ## ``texture`` The texture to lock for access, which was created with
  ## TEXTUREACCESS_STREAMING.
  ##
  ## ``rect``      A pointer to the rectangle to lock for access. If the rect
  ## is nil, the entire texture will be locked.
  ##
  ## ``pixels`` This is filled in with a pointer to the locked pixels,
  ## appropriately offset by the locked area.
  ##
  ## ``pitch`` This is filled in with the pitch of the locked pixels.
  ##
  ## Return 0 on success, or -1 if the texture is not valid or was not created
  ## with TEXTUREACCESS_STREAMING.
  ##
  ## See also: unlockTexture()


proc unlockTexture*(texture: PTexture) {.cdecl, importc: "SDL_UnlockTexture", dynlib: LibName.}
  ## Unlock a texture, uploading the changes to video memory, if needed.
  ##
  ## See also: lockTexture()


proc renderTargetSupported*(renderer: PRenderer): bool {.cdecl, importc: "SDL_RenderTargetSupported", dynlib: LibName.}
  ## Determines whether a window supports the use of render targets
  ##
  ## ``renderer`` The renderer that will be checked
  ##
  ## Return TRUE if supported, FALSE if not.


proc setRenderTarget*(renderer: PRenderer, texture: PTexture): int {.cdecl, importc: "SDL_SetRenderTarget", dynlib: LibName.}
  ## Set a texture as the current rendering target.
  ##
  ## ``renderer`` The renderer.
  ##
  ## ``texture`` The targeted texture, which must be created with the
  ## TEXTUREACCESS_TARGET flag, or nil for the default render target
  ##
  ## Return 0 on success, or -1 on error
  ##
  ## See also: getRenderTarget()


proc getRenderTarget*(renderer: PRenderer): PTexture {.cdecl, importc: "SDL_GetRenderTarget", dynlib: LibName.}
  ## Get the current render target or nil for the default render target.
  ##
  ## Return The current render target
  ##
  ## See also: setRenderTarget()


proc renderSetLogicalSize*(renderer: PRenderer,
    w, h: int): int {.cdecl, importc: "SDL_RenderSetLogicalSize", dynlib: LibName.}
  ## Set device independent resolution for rendering
  ##
  ## ``renderer`` The renderer for which resolution should be set.
  ##
  ## ``w`` The width of the logical resolution
  ##
  ## ``h`` The height of the logical resolution
  ##
  ## This function uses the viewport and scaling functionality to allow a fixed
  ## logical resolution for rendering, regardless of the actual output
  ## resolution.  If the actual  output resolution doesn't have the same aspect
  ## ratio the output rendering will be centered within the output display.
  ##
  ## If the output display is a window, mouse events in the window will be
  ## filtered and scaled so they seem to arrive within the logical resolution.
  ##
  ## If this function results in scaling or subpixel drawing by the rendering
  ## backend, it will be handled using the appropriate quality hints.
  ##
  ## See also: renderGetLogicalSize(), 
  ## renderSetScale(), 
  ## renderSetViewport()


proc renderGetLogicalSize*(renderer: PRenderer,
    w, h: ptr int) {.cdecl, importc: "SDL_RenderGetLogicalSize", dynlib: LibName.}
  ## Get device independent resolution for rendering
  ##
  ## ``renderer`` The renderer from which resolution should be queried.
  ##
  ## ``w`` A pointer filled with the width of the logical resolution
  ##
  ## ``h`` A pointer filled with the height of the logical resolution
  ##
  ## See also: renderSetLogicalSize()


proc renderSetViewport*(renderer: PRenderer, rect: PRect): int {.cdecl, importc: "SDL_RenderSetViewPort", dynlib: LibName.}
  ## Set the drawing area for rendering on the current target.
  ##
  ## ``renderer`` The renderer for which the drawing area should be set.
  ##
  ## ``rect`` The rectangle representing the drawing area, or nil to set
  ## the viewport to the entire target.
  ##
  ## The x,y of the viewport rect represents the origin for rendering.
  ##
  ## Return 0 on success, or -1 on error
  ##
  ## When the window is resized, the current viewport is automatically
  ## centered within the new window size.
  ##
  ## See also: renderGetViewport(), 
  ## renderSetLogicalSize()


proc renderGetViewport*(renderer: PRenderer, rect: PRect) {.cdecl, importc: "SDL_RenderGetViewport", dynlib: LibName.}
  ## Get the drawing area for the current target.
  ##
  ## See also: renderSetViewport()


proc renderSetClipRect*(renderer: PRenderer, rect: PRect): int {.cdecl, importc: "SDL_RenderSetClipRect", dynlib: LibName.}
  ## Set the clip rectangle for the current target.
  ##
  ## ``renderer`` The renderer for which clip rectangle should be set.
  ##
  ## ``rect`` A pointer to the rectangle to set as the clip rectangle, or
  ## nil to disable clipping.
  ##
  ## Return 0 on success, or -1 on error
  ##
  ## See also: renderGetClipRect()


proc renderGetClipRect*(renderer: PRenderer, rect: PRect) {.cdecl, importc: "SDL_RenderGetClipRect", dynlib: LibName.}
  ## Get the clip rectangle for the current target.
  ##
  ## ``renderer`` The renderer from which clip rectangle should be queried.
  ## ``rect``   A pointer filled in with the current clip rectangle, or
  ## an empty rectangle if clipping is disabled.
  ##
  ## See also: renderSetClipRect()


proc renderSetScale*(renderer: PRenderer,
    scaleX, scaleY: cfloat): int {.cdecl, importc: "SDL_RenderSetScale", dynlib: LibName.}
  ## Set the drawing scale for rendering on the current target.
  ##
  ## ``renderer`` The renderer for which the drawing scale should be set.
  ##
  ## ``scaleX`` The horizontal scaling factor
  ##
  ## ``scaleY`` The vertical scaling factor
  ##
  ## The drawing coordinates are scaled by the x/y scaling factors
  ## before they are used by the renderer.  This allows resolution
  ## independent drawing with a single coordinate system.
  ##
  ## If this results in scaling or subpixel drawing by the
  ## rendering backend, it will be handled using the appropriate
  ## quality hints.  For best results use integer scaling factors.
  ##
  ## See also: renderGetScale(), 
  ## renderSetLogicalSize()


proc renderGetScale*(renderer: PRenderer,
    scaleX, scaleY: ptr cfloat) {.cdecl, importc: "SDL_RenderGetScale", dynlib: LibName.}
  ## Get the drawing scale for the current target.
  ##
  ## ``renderer`` The renderer from which drawing scale should be queried.
  ##
  ## ``scaleX`` A pointer filled in with the horizontal scaling factor
  ##
  ## ``scaleY`` A pointer filled in with the vertical scaling factor
  ##
  ## See also: renderSetScale()


proc setRenderDrawColor*(renderer: PRenderer,
    r, g, b: Uint8, a: Uint8 = ALPHA_OPAQUE): int {.cdecl, importc: "SDL_SetRenderDrawColor", dynlib: LibName.}
  ## Set the color used for drawing operations (Rect, Line and Clear).
  ##
  ## ``renderer`` The renderer for which drawing color should be set.
  ##
  ## ``r`` The red value used to draw on the rendering target.
  ##
  ## ``g`` The green value used to draw on the rendering target.
  ##
  ## ``b`` The blue value used to draw on the rendering target.
  ##
  ## ``a`` The alpha value used to draw on the rendering target, usually
  ## ALPHA_OPAQUE (255).
  ##
  ## Return 0 on success, or -1 on error


proc getRenderDrawColor*(renderer: PRenderer,
    r, g, b, a: ptr Uint8): int {.cdecl, importc: "SDL_GetRenderDrawColor", dynlib: LibName.}
  ## Get the color used for drawing operations (Rect, Line and Clear).
  ##
  ## ``renderer`` The renderer from which drawing color should be queried.
  ##
  ## ``r`` A pointer to the red value used to draw on the rendering target.
  ##
  ## ``g`` A pointer to the green value used to draw on the rendering target.
  ##
  ##  ``b`` A pointer to the blue value used to draw on the rendering target.
  ##
  ## ``a`` A pointer to the alpha value used to draw on the rendering target,
  ## usually ALPHA_OPAQUE (255).
  ##
  ## Return 0 on success, or -1 on error


proc setRenderDrawBlendMode*(renderer: PRenderer, blendMode: TBlendMode): int {.cdecl, importc: "SDL_SetRenderDrawBlendMode", dynlib: LibName.}
  ## Set the blend mode used for drawing operations (Fill and Line).
  ##
  ## ``renderer`` The renderer for which blend mode should be set.
  ##
  ## ``blendMode`` TBlendMode to use for blending.
  ##
  ## Return 0 on success, or -1 on error
  ##
  ## If the blend mode is not supported, the closest supported mode is chosen.
  ##
  ## See also: getRenderDrawBlendMode()


proc getRenderDrawBlendMode*(renderer: PRenderer, blendMode: ptr TBlendMode): int {.cdecl, importc: "SDL_GetRenderDrawBlendMode", dynlib: LibName.}
  ## Get the blend mode used for drawing operations.
  ##
  ## ``renderer`` The renderer from which blend mode should be queried.
  ##
  ## ``blendMode`` A pointer filled in with the current blend mode.
  ##
  ## Return 0 on success, or -1 on error
  ##
  ## See also: setRenderDrawBlendMode()


proc renderClear*(renderer: PRenderer): int {.cdecl, importc: "SDL_RenderClear", dynlib: LibName.}
  ## Clear the current rendering target with the drawing color
  ##
  ## This function clears the entire rendering target, ignoring the viewport.
  ##
  ## Return 0 on success, or -1 on error


proc renderDrawPoint*(renderer: PRenderer,
    x, y: int): int {.cdecl, importc: "SDL_RenderDrawPoint", dynlib: LibName.}
  ## Draw a point on the current rendering target.
  ##
  ## ``renderer`` The renderer which should draw a point.
  ##
  ## ``x`` The x coordinate of the point.
  ##
  ## ``y`` The y coordinate of the point.
  ##
  ## Return 0 on success, or -1 on error


proc renderDrawPoints*(renderer: PRenderer,
    points: PPoint, count: int): int {.cdecl, importc: "SDL_RenderDrawPoints", dynlib: LibName.}
  ## Draw multiple points on the current rendering target.
  ##
  ## ``renderer`` The renderer which should draw multiple points.
  ##
  ## ``points`` The points to draw
  ##
  ## ``count`` The number of points to draw
  ##
  ## Return 0 on success, or -1 on error


proc renderDrawLine*(renderer: PRenderer,
    x1, y1, x2, y2: int): int {.cdecl, importc: "SDL_RenderDrawLine", dynlib: LibName.}
  ## Draw a line on the current rendering target.
  ##
  ## ``renderer`` The renderer which should draw a line.
  ##
  ## ``x1`` The x coordinate of the start point.
  ##
  ## ``y1`` The y coordinate of the start point.
  ##
  ## ``x2`` The x coordinate of the end point.
  ##
  ## ``y2`` The y coordinate of the end point.
  ##
  ## Return 0 on success, or -1 on error


proc renderDrawLines*(renderer: PRenderer,
    points: PPoint, count: int): int {.cdecl, importc: "SDL_RenderDrawLines", dynlib: LibName.}
  ## Draw a series of connected lines on the current rendering target.
  ##
  ## ``renderer`` The renderer which should draw multiple lines.
  ##
  ## ``points`` The points along the lines
  ##
  ## ``count`` The number of points, drawing count-1 lines
  ##
  ## Return 0 on success, or -1 on error


proc renderDrawRect*(renderer: PRenderer, rect: PRect): int {.cdecl, importc: "SDL_RenderDrawRect", dynlib: LibName.}
  ## Draw a rectangle on the current rendering target.
  ##
  ## ``renderer`` The renderer which should draw a rectangle.
  ##
  ## ``rect`` A pointer to the destination rectangle, or nil to outline the entire rendering target.
  ##
  ## Return 0 on success, or -1 on error


proc renderDrawRects*(renderer: PRenderer,
    rects: PRect, count: int): int {.cdecl, importc: "SDL_RenderDrawRects", dynlib: LibName.}
  ## Draw some number of rectangles on the current rendering target.
  ##
  ## ``renderer`` The renderer which should draw multiple rectangles.
  ##
  ## ``rects`` A pointer to an array of destination rectangles.
  ##
  ## ``count`` The number of rectangles.
  ##
  ## Return 0 on success, or -1 on error


proc renderFillRect*(renderer: PRenderer, rect: PRect): int {.cdecl, importc: "SDL_RenderFillRect", dynlib: LibName.}
  ## Fill a rectangle on the current rendering target with the drawing color.
  ##
  ## ``renderer`` The renderer which should fill a rectangle.
  ##
  ## ``rect`` A pointer to the destination rectangle, or nil for the entire
  ## rendering target.
  ##
  ## Return 0 on success, or -1 on error


proc renderFillRects*(renderer: PRenderer,
    rects: PRect, count: int): int {.cdecl, importc: "SDL_RenderFillRects", dynlib: LibName.}
  ## Fill some number of rectangles on the current rendering target with the drawing color.
  ##
  ## ``renderer`` The renderer which should fill multiple rectangles.
  ##
  ## ``rects`` A pointer to an array of destination rectangles.
  ##
  ## ``count`` The number of rectangles.
  ##
  ## Return 0 on success, or -1 on error


proc renderCopy*(renderer: PRenderer, texture: PTexture,
    srcrect, dstrect: PRect): int {.cdecl, importc: "SDL_RenderCopy", dynlib: LibName.}
  ## Copy a portion of the texture to the current rendering target.
  ##
  ## ``renderer`` The renderer which should copy parts of a texture.
  ##
  ## ``texture`` The source texture.
  ##
  ## ``srcrect`` A pointer to the source rectangle, or nil for the
  ## entire texture.
  ##
  ## ``dstrect`` A pointer to the destination rectangle, or nil for the
  ## entire rendering target.
  ##
  ## Return 0 on success, or -1 on error


proc renderCopyEx*(renderer: PRenderer, texture: PTexture,
    srcrect, dstrect: PRect, angle: cdouble,
    center: PPoint, flip: TRendererFlip): int {.cdecl, importc: "SDL_RenderCopyEx", dynlib: LibName.}
  ## Copy a portion of the source texture to the current rendering target, rotating it by angle around the given center
  ##
  ## ``renderer`` The renderer which should copy parts of a texture.
  ##
  ## ``texture`` The source texture.
  ##
  ## ``srcrect`` A pointer to the source rectangle, or nil for the
  ## entire texture.
  ##
  ## ``dstrect`` A pointer to the destination rectangle, or nil for the
  ## entire rendering target.
  ##
  ## ``angle`` An angle in degrees that indicates the rotation that will be
  ## applied to dstrect
  ##
  ## ``center`` A pointer to a point indicating the point around which
  ## dstrect will be rotated (if nil, rotation will be done aroud
  ## dstrect.w/2, dstrect.h/2)
  ##
  ## ``flip`` An TRendererFlip value stating which flipping actions should be
  ## performed on the texture
  ##
  ## Return 0 on success, or -1 on error


proc renderReadPixels*(renderer: PRenderer, rect: PRect,
    format: Uint32, pixels: pointer, pitch: int): int {.cdecl, importc: "SDL_RenderReadPixels", dynlib: LibName.}
  ## Read pixels from the current rendering target.
  ##
  ## ``renderer`` The renderer from which pixels should be read.
  ##
  ## ``rect`` A pointer to the rectangle to read, or nil for the entire
  ## render target.
  ##
  ## ``format`` The desired format of the pixel data, or 0 to use the format
  ## of the rendering target
  ##
  ## ``pixels`` A pointer to be filled in with the pixel data
  ##
  ## ``pitch`` The pitch of the pixels parameter.
  ##
  ## Return 0 on success, or -1 if pixel reading is not supported.
  ##
  ## Warning: This is a very slow operation, and should not be used frequently.


proc renderPresent*(renderer: PRenderer) {.cdecl, importc: "SDL_RenderPresent", dynlib: LibName.}
  ## Update the screen with rendering performed.


proc destroyTexture*(texture: PTexture) {.cdecl, importc: "SDL_DestroyTexture", dynlib: LibName.}
  ## Destroy the specified texture.
  ##
  ## See also: createTexture(), 
  ## createTextureFromSurface()


proc destroyRenderer*(renderer: PRenderer) {.cdecl, importc: "SDL_DestroyRenderer", dynlib: LibName.}
  ## Destroy the rendering context for a window and free associated textures.
  ##
  ## See also: createRenderer()


proc glBindTexture*(texture: PTexture,
    texw, texh: ptr cfloat): int {.cdecl, importc: "SDL_GL_BindTexture", dynlib: LibName.}
  ## Bind the texture to the current OpenGL/ES/ES2 context for use with
  ## OpenGL instructions.
  ##
  ## ``texture`` The SDL texture to bind
  ##
  ## ``texw`` A pointer to a float that will be filled with the texture width
  ## ``texh`` A pointer to a float that will be filled with the texture height
  ##
  ## Return 0 on success, or -1 if the operation is not supported


proc glUnbindTexture*(texture: PTexture): int {.cdecl, importc: "SDL_GL_UnbindTexture", dynlib: LibName.}
  ## Unbind a texture from the current OpenGL/ES/ES2 context.
  ##
  ## ``texture`` The SDL texture to unbind
  ##
  ## Return 0 on success, or -1 if the operation is not supported

