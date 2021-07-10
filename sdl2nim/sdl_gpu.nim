#
# SDL_gpu:  A library for hardware-accelerated 2D graphics on top of SDL
# Copyright (c) 2015 Jonathan Dearborn

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

##  sdl_gpu.nim
##  ===========
##
##  * High performance by collecting and submitting batches of draw commands
##  * Shader API
##  * Arbitrary geometry rendering (triangles)
##  * Can be integrated with explicit OpenGL calls (mixed 2D and 3D)
##  * Full blend state control
##  * Built-in primitive shapes
##    (points, lines, tris, rects, ellipses, polygons, arcs)
##  * Loads BMP, TGA, and PNG files via stb-image
##  * Rotates and scales about the center of images
##    (adjustable via anchor settings)

{.deadCodeElim: on.}

import
  sdl

const # Compile-time versions
  MAJOR_VERSION*  = 0
  MINOR_VERSION*  = 11
  PATCHLEVEL*     = 0

const
  RENDERER_ORDER_MAX* = 10
  MODELVIEW*          = 0
  PROJECTION*         = 1

  DEFAULT_INIT_FLAGS* = 0
  NONE* = 0x0

type
  WindowFlags* = uint32  ##  \
    ##  The flags passed to SDL's ``createWindow`` through
    ##  SDL_gpu's ``init``, ``initRenderer``, or ``initRendererByID``

type
  InitFlags* = uint32 ##  \
    ##  Initialization flags for changing default init parameters.
    ##
    ##  Can be bitwise OR'ed together.
    ##
    ##  Default (`0`) is to use late swap vsync and double buffering.
    ##
    ##  See also:
    ##
    ##  ``setPreInitFlags()``
    ##
    ##  ``see getPreInitFlags()``

const # Init options
  INIT_ENABLE_VSYNC*                            = 0x1
  INIT_DISABLE_VSYNC*                           = 0x2
  INIT_DISABLE_DOUBLE_BUFFER*                   = 0x4
  INIT_DISABLE_AUTO_VIRTUAL_RESOLUTION*         = 0x8
  INIT_REQUEST_COMPATIBILITY_PROFILE*           = 0x10
  INIT_USE_ROW_BY_ROW_TEXTURE_UPLOAD_FALLBACK*  = 0x20
  INIT_USE_COPY_TEXTURE_UPLOAD_FALLBACK*        = 0x40

type
  FeatureFlags* = uint32  ##  \
    ##  Important GPU features which may not be supported
    ##  depending on a device's extension support.
    ##
    ##  Can be bitwise OR'd together.
    ##
    ##  See also:
    ##
    ##  ``isFeatureEnabled()``
    ##
    ##  ``setRequiredFeatures()``

const # Feature options
  FEATURE_NON_POWER_OF_TWO*         = 0x1
  FEATURE_RENDER_TARGETS*           = 0x2
  FEATURE_BLEND_EQUATIONS*          = 0x4
  FEATURE_BLEND_FUNC_SEPARATE*      = 0x8
  FEATURE_BLEND_EQUATIONS_SEPARATE* = 0x10
  FEATURE_GL_BGR*                   = 0x20
  FEATURE_GL_BGRA*                  = 0x40
  FEATURE_GL_ABGR*                  = 0x80
  FEATURE_VERTEX_SHADER*            = 0x100
  FEATURE_FRAGMENT_SHADER*          = 0x200
  FEATURE_PIXEL_SHADER*             = 0x200
  FEATURE_GEOMETRY_SHADER*          = 0x400
  FEATURE_WRAP_REPEAT_MIRRORED*     = 0x800
  FEATURE_CORE_FRAMEBUFFER_OBJECTS* = 0x1000

  # Combined feature flags
  FEATURE_ALL_BASE*           = FEATURE_RENDER_TARGETS
  FEATURE_ALL_BLEND_PRESETS*  = FEATURE_BLEND_EQUATIONS or
                                FEATURE_BLEND_FUNC_SEPARATE
  FEATURE_ALL_GL_FORMATS*     = FEATURE_GL_BGR or
                                FEATURE_GL_BGRA or
                                FEATURE_GL_ABGR
  FEATURE_BASIC_SHADERS*      = FEATURE_FRAGMENT_SHADER or
                                FEATURE_VERTEX_SHADER
  FEATURE_ALL_SHADERS*        = FEATURE_FRAGMENT_SHADER or
                                FEATURE_VERTEX_SHADER or
                                FEATURE_GEOMETRY_SHADER

type
  Rect* = tuple[x, y: cfloat, w, h: cfloat] ##  \
    ##  A struct representing a rectangular area with floating point precision.
    ##
    ##  See also:
    ##
    ##  ``makeRect()``

  RendererKind* {.size: sizeof(cint).} = enum
    RENDERER_UNKNOWN        = 0  ##  invalid value
    RENDERER_OPENGL_1_BASE  = 1
    RENDERER_OPENGL_1       = 2
    RENDERER_OPENGL_2       = 3
    RENDERER_OPENGL_3       = 4
    RENDERER_OPENGL_4       = 5
    RENDERER_GLES_1         = 11
    RENDERER_GLES_2         = 12
    RENDERER_GLES_3         = 13
    RENDERER_D3D9           = 21
    RENDERER_D3D10          = 22
    RENDERER_D3D11          = 23

  RendererID* = object  ##  \
    ##  Renderer ID object for identifying a specific renderer.
    ##
    ##  See also:
    ##
    ##  ``makeRendererID()``
    ##
    ##  ``initRendererByID()``
    name*: ptr char
    renderer*: RendererKind
    majorVersion*: cint
    minorVersion*: cint

  ComparisonEnum* {.size: sizeof(cint).} = enum ##  \
    ##  Comparison operations (for depth testing)
    ##
    ##  Values chosen for direct OpenGL compatibility.
    ##
    ##  See also:
    ##
    ##  ``setDepthFunction()``
    NEVER    = 0x0200
    LESS     = 0x0201
    EQUAL    = 0x0202
    LEQUAL   = 0x0203
    GREATER  = 0x0204
    NOTEQUAL = 0x0205
    GEQUAL   = 0x0206
    ALWAYS   = 0x0207

  BlendFunc* {.size: sizeof(cint).} = enum  ##  \
    ##  Blend component functions.
    ##
    ##  Values chosen for direct OpenGL compatibility.
    ##
    ##  See also:
    ##
    ##  ``setBlendFunction()``
    FUNC_ZERO                 = 0
    FUNC_ONE                  = 1
    FUNC_SRC_COLOR            = 0x0300
    FUNC_ONE_MINUS_SRC        = 0x0301
    FUNC_SRC_ALPHA            = 0x0302
    FUNC_ONE_MINUS_SRC_ALPHA  = 0x0303
    FUNC_DST_ALPHA            = 0x0304
    FUNC_ONE_MINUS_DST_ALPHA  = 0x0305
    FUNC_DST_COLOR            = 0x0306
    FUNC_ONE_MINUS_DST        = 0x0307

  BlendEq* {.size: sizeof(cint).} = enum  ##  \
    ##  Blend component equations.
    ##
    ##  Values chosen for direct OpenGL compatibility.
    ##
    ##  See also:
    ##
    ##  ``setBlendEquation()``
    EQ_ADD              = 0x8006
    EQ_SUBTRACT         = 0x800A
    EQ_REVERSE_SUBTRACT = 0x800B

  BlendMode* = object ##  Blend mode storage struct
    sourceColor*, destColor*: BlendFunc
    sourceAlpha*, destAlpha*: BlendFunc
    colorEquation*: BlendEq
    alphaEquation*: BlendEq

  BlendPreset* {.size: sizeof(cint).} = enum  ##  \
    ##  Blend mode presets.
    ##
    ##  See also:
    ##
    ##  ``setBlendMode()``
    ##
    ##  ``getBlendModeFromPreset()``
    BLEND_NORMAL              = 0
    BLEND_PREMULTIPLIED_ALPHA = 1
    BLEND_MULTIPLY            = 2
    BLEND_ADD                 = 3
    BLEND_SUBTRACT            = 4
    BLEND_MOD_ALPHA           = 5
    BLEND_SET_ALPHA           = 6
    BLEND_SET                 = 7
    BLEND_NORMAL_KEEP_ALPHA   = 8
    BLEND_NORMAL_ADD_ALPHA    = 9
    BLEND_NORMAL_FACTOR_ALPHA = 10

  Filter* {.size: sizeof(cint).} = enum ##  \
    ##  Image filtering options.
    ##
    ##  These affect the quality/interpolation of colors when images are scaled.
    ##
    ##  See also:
    ##
    ##  ``setImageFilter()``
    FILTER_NEAREST        = 0
    FILTER_LINEAR         = 1
    FILTER_LINEAR_MIPMAP  = 2

  Snap* {.size: sizeof(cint).} = enum ##  \
    ##  Snap modes.
    ##
    ##  Blitting with these modes will align the sprite
    ##  with the target's pixel grid.
    ##
    ##  See also:
    ##
    ##  ``setSnapMode()``
    ##
    ##  ``getSnapMode()``
    SNAP_NONE                     = 0
    SNAP_POSITION                 = 1
    SNAP_DIMENSIONS               = 2
    SNAP_POSITION_AND_DIMENSIONS  = 3

  Wrap* {.size: sizeof(cint).} = enum ##  \
    ##  Image wrapping options.
    ##
    ##  These affect how images handle ``src_rect`` coordinates
    ##  beyond their dimensions when blitted.
    ##
    ##  See also:
    ##
    ##  ``setWrapMode()``
    WRAP_NONE     = 0
    WRAP_REPEAT   = 1
    WRAP_MIRRORED = 2

  Format* {.size: sizeof(cint).} = enum ##  \
    ##  Image format enum.
    ##
    ##  See also:
    ##
    ##  ``createImage()``
    FORMAT_LUMINANCE        = 1
    FORMAT_LUMINANCE_ALPHA  = 2
    FORMAT_RGB              = 3
    FORMAT_RGBA             = 4
    FORMAT_ALPHA            = 5
    FORMAT_RG               = 6
    FORMAT_YCbCr422         = 7
    FORMAT_YCbCr420P        = 8
    FORMAT_BGR              = 9
    FORMAT_BGRA             = 10
    FORMAT_ABGR             = 11

  FileFormat* {.size: sizeof(cint).} = enum ##  \
    ##  File format enum.
    ##
    ##  See also:
    ##
    ##  ``saveSurface()``
    ##
    ##  ``saveImage()``
    ##
    ##  ``saveSurface_RW()``
    ##
    ##  ``saveImage_RW()``
    FILE_AUTO = 0
    FILE_PNG
    FILE_BMP
    FILE_TGA

  AttributeType* {.size: sizeof(cint).} = enum  ##  \
    ##  Type enumeration for attributeFormat specifications.
    ##
    ##  Using OpenGL's values for simpler translation.
    TYPE_BYTE           = 0x1400
    TYPE_UNSIGNED_BYTE  = 0x1401
    TYPE_SHORT          = 0x1402
    TYPE_UNSIGNED_SHORT = 0x1403
    TYPE_INT            = 0x1404
    TYPE_UNSIGNED_INT   = 0x1405
    TYPE_FLOAT          = 0x1406
    TYPE_DOUBLE         = 0x140A

  ShaderType* {.size: sizeof(cint).} = enum ##  \
    ##  Shader type enum.
    ##
    ##  See also:
    ##
    ##  ``loadShader()``
    ##
    ##  ``compileShader()``
    ##
    ##  ``compileShader_RW()``
    VERTEX_SHADER   = 0
    FRAGMENT_SHADER = 1
    GEOMETRY_SHADER = 2

const
  PIXEL_SHADER* = FRAGMENT_SHADER

type
  ShaderLanguage* {.size: sizeof(cint).} = enum ##  \
    ##  Type enumeration for the shader language used by the renderer.
    LANGUAGE_NONE         = 0
    LANGUAGE_ARB_ASSEMBLY = 1
    LANGUAGE_GLSL         = 2
    LANGUAGE_GLSLES       = 3
    LANGUAGE_HLSL         = 4
    LANGUAGE_CG           = 5

  AttributeFormat* = object
    isPerSprite*: bool
      ##  Per-sprite values are expanded to 4 vertices
    numElemsPerValue*: cint
    `type`*: AttributeType
      ##  TYPE_FLOAT, TYPE_INT, TYPE_UNSIGNED_INT, etc.
    normalize*: bool
    strideBytes*: cint
      ##  Number of bytes between two vertex specifications
    offsetBytes*: cint
      ##  Number of bytes to skip at the beginning of ``values``

  Attribute* = object
    location*: cint
    values*: pointer ##  Expect 4 values for each sprite
    format*: AttributeFormat

  AttributeSource* = object
    enabled*: bool
    numValues*: cint
    nextValue*: pointer
    ##  Automatic storage format
    perVertexStorageStrideBytes*: cint
    perVertexStorageOffsetBytes*: cint
    perVertexStorageSize*: cint
      ##  Over 0 means that the per-vertex storage
      ##  has been automatically allocated
    perVertexStorage*: pointer
      ##  Could point to the attribute's values or to allocated storage
    attribute*: Attribute

type
  Flip* = uint32  ##  \
    ##  Bit flags for blitting into a rectangular region.
    ##
    ##  See also:
    ##
    ##  ``blitRect()``
    ##
    ##  ``blitRectX()``

const #  Flip options
  FLIP_NONE*        = 0x0
  FLIP_HORIZONTAL*  = 0x1
  FLIP_VERTICAL*    = 0x2
  FLIP_BOTH*        = FLIP_HORIZONTAL or FLIP_VERTICAL  ##  Combined flip flags

type
  Image* = ptr object ##  \
    ##  Image object for containing pixel/texture data.
    ##
    ##  A image can be created with
    ##  ``createImage()``, ``loadImage()``, ``copyImage()``,
    ##  or ``copyImageFromSurface()``.
    ##
    ##  Free the memory with ``freeImage()`` when you're done.
    ##
    ##  See also:
    ##
    ##  ``createImage()``
    ##
    ##  ``loadImage()``
    ##
    ##  ``copyImage()``
    ##
    ##  ``copyImageFromSurface()``
    ##
    ##  ``Target``
    renderer*: Renderer
    contextTarget*: Target
    target*: Target
    w*, h*: uint16
    usingVirtualResolution*: bool
    format*: Format
    numLayers*: cint
    bytesPerPixel*: int
    baseW*, baseH*: uint16        ##  Original image dimensions
    textureH*, textureW*: uint16  ##  Underlying texture dimensions
    hasMipMaps*: bool

    anchorX*, anchorY*: cfloat
      ##  Normalized coords for the point at which the image is blitted.
      ##
      ##  Default is (0.5, 0.5), that is, the image is drawn centered.
      ##
      ##  These are interpreted according to ``setCoordinateMode()``
      ##  and range from (0.0 - 1.0) normally.

    color*: Color
    useBlending*: bool
    blendMode*: BlendMode
    filterMode*: Filter
    snapMode*: Snap
    wrapModeX*: Wrap
    wrapModeY*: Wrap

    data*: pointer
    refcount*: cint
    isAlias*: bool

  TextureHandle* {.importc: "uintptr_t", header: "<stdint.h>".} = distinct pointer  ##  \
    ##  A backend-neutral type that is intended to hold a backend-specific handle/pointer to a texture.
    ##
    ##  See also:
    ##
    ##  ``createImageUsingTexture()``
    ##
    ##  ``getTextureHandle()``

  Camera* = object  ##  \
    ##  Camera object that determines viewing transform.
    ##
    ##  See also:
    ##
    ##  ``setCamera()``
    ##
    ##  ``getDefaultCamera()``
    ##
    ##  ``getCamera()``
    x*, y*, z*: cfloat
    angle*, zoom*: cfloat
    zNear*, zFar*: cfloat ##  z clipping planes

  ShaderBlock* = object ##  \
    ##  Container for the built-in shader attribute and uniform locations
    ##  (indices).
    ##
    ##  See also:
    ##
    ##  ``loadShaderBlock()``
    ##
    ##  ``setShaderBlock()``
    positionLoc*: cint  ##  Attributes
    texcoordLoc*: cint
    colorLoc*: cint     ##  Uniforms
    modelViewProjectionLoc*: cint

  MatrixStack* = object ##  \
    ##  Matrix stack data structure for global vertex transforms.
    storage_size*: cuint
    size*: cuint
    matrix*: pointer # array[MATRIX_STACK_MAX, array[16, cfloat]]

  Context* = ptr object ##  \
    ##  Rendering context data.
    ##
    ##  Only targets which represent windows will store this.
    context*: pointer ##  SDL's GLContext
    failed*: bool

    windowID*: uint32             ##  SDL window ID
    windowW*, windowH*: cint      ##  Actual window dimensions
    drawableW*, drawableH*: cint  ##  Drawable region dimensions
    storedWindowW*, storedWindowH*: cint  ##  Window dimensions
      ##  for restoring windowed mode after setFullscreen(1,1).

    currentShaderProgram*: uint32
    defaultTexturedShaderProgram*: uint32
    defaultUntexturedShaderProgram*: uint32

    currentShaderBlock*: ShaderBlock
    defaultTexturedShaderBlock*: ShaderBlock
    defaultUntexturedShaderBlock*: ShaderBlock

    shapesUseBlending*: bool
    shapesBlendMode*: BlendMode
    lineThickness*: cfloat
    useTexturing*: bool

    matrixMode*: cint
    projectionMatrix*: MatrixStack
    modelviewMatrix*: MatrixStack

    refcount*: cint
    data*: pointer

  Target* = ptr object  ##  \
    ##  Render target object for use as a blitting destination.
    ##
    ##  A ``Target`` can be created from an ``Image`` with ``loadTarget()``.
    ##
    ##  A Target can also represent a separate window
    ##  with ``createTargetFromWindow()``.
    ##  In that case, ``context`` is allocated and filled in.
    ##
    ##  ``Note:`` You must have passed the `WINDOW_OPENGL` flag
    ##  to SDL's ``createWindow()`` for OpenGL renderers
    ##  to work with new windows.
    ##
    ##  Free the memory with ``freeTarget()`` when you're done.
    ##
    ##  See also:
    ##
    ##  ``loadTarget()``
    ##
    ##  ``createTargetFromWindow()``
    ##
    ##  ``freeTarget()``
    renderer*: Renderer
    contextTarget*: Target
    image*: Image
    data*: pointer
    w*, h*: uint16
    usingVirtualResolution*: bool
    baseW*, baseH*: uint16
      ##  The true dimensions of the underlying image or window
    useClipRect*: bool
    clipRect*: Rect
    useColor*: bool
    color*: Color

    viewport*: Rect
    camera*: Camera ##  Perspective and object viewing transforms.
    useCamera*: bool
    useDepthTest*: bool
    useDepthWrite*: bool
    depthFunction*: ComparisonEnum

    context*: Context ##  Renderer context data.
      ##  `nil` if the target does not represent a window or rendering context.

    refcount*: cint
    isAlias*: bool

  Renderer* = ptr object  ##  \
    ##  Renderer object which specializes the API to a particular backend.
    id*: RendererID
    requestedID*: RendererID
    SDLinitFlags*: WindowFlags
    GPUinitFlags*: InitFlags

    shaderLanguage*: ShaderLanguage
    minShaderVersion*: cint
    maxShaderVersion*: cint
    enabledFeatures*: FeatureFlags

    currentContextTarget*: Target ##  Current display target
    coordinateMode*: bool         ##  0 for inverted, 1 for mathematical

    defaultImageAnchorX*: cfloat ##  Default is (0.5, 0.5)
    defaultImageAnchorY*: cfloat ##  images draw centered.

    # impl*: ptr RendererImpl ##  Private implementation of renderer members


type
  BatchFlags* = uint32  ##  \
  ##  Bit flags for geometry batching.
  ##
  ##  See also:
  ##
  ##  ``triangleBatch()``
  ##
  ##  ``triangleBatchX()``

const #  Batch options
  BATCH_XY*     = 0x1
  BATCH_XYZ*    = 0x2
  BATCH_ST*     = 0x4
  BATCH_RGB*    = 0x8
  BATCH_RGBA*   = 0x10
  BATCH_RGB8*   = 0x20
  BATCH_RGBA8*  = 0x40

  # Combined batch flags
  BATCH_XY_ST*        = (BATCH_XY or BATCH_ST)
  BATCH_XYZ_ST*       = (BATCH_XYZ or BATCH_ST)
  BATCH_XY_RGB*       = (BATCH_XY or BATCH_RGB)
  BATCH_XYZ_RGB*      = (BATCH_XYZ or BATCH_RGB)
  BATCH_XY_RGBA*      = (BATCH_XY or BATCH_RGBA)
  BATCH_XYZ_RGBA*     = (BATCH_XYZ or BATCH_RGBA)
  BATCH_XY_ST_RGBA*   = (BATCH_XY or BATCH_ST or BATCH_RGBA)
  BATCH_XYZ_ST_RGBA*  = (BATCH_XYZ or BATCH_ST or BATCH_RGBA)
  BATCH_XY_RGB8*      = (BATCH_XY or BATCH_RGB8)
  BATCH_XYZ_RGB8*     = (BATCH_XYZ or BATCH_RGB8)
  BATCH_XY_RGBA8*     = (BATCH_XY or BATCH_RGBA8)
  BATCH_XYZ_RGBA8*    = (BATCH_XYZ or BATCH_RGBA8)
  BATCH_XY_ST_RGBA8*  = (BATCH_XY or BATCH_ST or BATCH_RGBA8)
  BATCH_XYZ_ST_RGBA8* = (BATCH_XYZ or BATCH_ST or BATCH_RGBA8)

type
  ErrorType* {.size: sizeof(cint).} = enum  ##  \
    ##  Type enumeration for error codes.
    ##
    ##  See also:
    ##
    ##  ``pushErrorCode()``
    ##
    ##  ``popErrorCode()``
    ERROR_NONE                  = 0
    ERROR_BACKEND_ERROR         = 1
    ERROR_DATA_ERROR            = 2
    ERROR_USER_ERROR            = 3
    ERROR_UNSUPPORTED_FUNCTION  = 4
    ERROR_NULL_ARGUMENT         = 5
    ERROR_FILE_NOT_FOUND        = 6

  ErrorObject* = object
    function*: cstring
    error*: ErrorType
    details*: cstring

  DebugLevel* {.size: sizeof(cint).} = enum ##  \
    ##  Type enumeration for debug levels.
    ##
    ##  See also:
    ##
    ##  ``setDebugLevel()``
    ##
    ##  ``getDebugLevel()``
    DEBUG_LEVEL_0 = 0
    DEBUG_LEVEL_1 = 1
    DEBUG_LEVEL_2 = 2
    DEBUG_LEVEL_3 = 3

const
  DEBUG_LEVEL_MAX* = DEBUG_LEVEL_3

type
  LogLevel* {.size: sizeof(cint).} = enum ##  \
    ##  Type enumeration for logging levels.
    ##
    ##  See also:
    ##
    ##  ``setLogCallback()``
    LOG_INFO = 0
    LOG_WARNING
    LOG_ERROR


# Initialization

proc getCompiledVersion*(): Version =
  result.major = MAJOR_VERSION
  result.minor = MINOR_VERSION
  result.patch = PATCHLEVEL

# proc getLinkedVersion*(): Version {.
#     cdecl, importc: "GPU_GetLinkedVersion", dynlib: SDL2_GPU_LIB.}

proc setInitWindow*(windowID: uint32) {.
    cdecl, importc: "GPU_SetInitWindow", dynlib: SDL2_GPU_LIB.}
  ##  The window corresponding to ``windowID`` will be used to create
  ##  the rendering context instead of creating a new window.

proc getInitWindow*(): uint32 {.
    cdecl, importc: "GPU_GetInitWindow", dynlib: SDL2_GPU_LIB.}
  ##  Returns the window ID that has been set via ``setInitWindow()``.

proc setPreInitFlags*(flags: InitFlags) {.
    cdecl, importc: "GPU_SetPreInitFlags", dynlib: SDL2_GPU_LIB.}
  ##  Set special flags to use for initialization.
  ##  Set these before calling ``init()``.
  ##
  ##  ``flags`` an OR'ed combination of ``initFlags`` constants.
  ##  Default flags (0) enable late swap vsync and double buffering.

proc getPreInitFlags*(): InitFlags {.
    cdecl, importc: "GPU_GetPreInitFlags", dynlib: SDL2_GPU_LIB.}
  ##  Returns the current special flags to use for initialization.

proc setRequiredFeatures*(features: FeatureFlags) {.
    cdecl, importc: "GPU_SetRequiredFeatures", dynlib: SDL2_GPU_LIB.}
  ##  Set required features to use for initialization.
  ##  Set these before calling ``init()``.
  ##
  ##  ``features`` An OR'ed combination of featureEnum flags.
  ##  Required features will force ``init()`` to create a renderer
  ##  that supports all of the given flags or else fail.

proc getRequiredFeatures*(): FeatureFlags {.
    cdecl, importc: "GPU_GetRequiredFeatures", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the current required features to use for initialization.

proc getDefaultRendererOrder*(orderSize: ptr cint; order: ptr RendererID) {.
    cdecl, importc: "GPU_GetDefaultRendererOrder", dynlib: SDL2_GPU_LIB.}
  ##  Gets the default initialization renderer IDs for the current platform
  ##  copied into the ``order`` array and the number of renderer IDs into
  ##  ``order_size``. Pass `nil` for ``order`` to just get the size of the
  ##  renderer order array. Will return at most `RENDERER_ORDER_MAX` renderers.

proc getRendererOrder*(orderSize: ptr cint; order: ptr RendererID) {.
    cdecl, importc: "GPU_GetRendererOrder", dynlib: SDL2_GPU_LIB.}
  ##  Gets the current renderer ID order for initialization
  ##  copied into the ``order`` array and the number of renderer IDs into
  ##  ``order_size``. Pass `nil` for ``order`` to just get the size of the
  ##  renderer order array.

proc setRendererOrder*(orderSize: cint; order: ptr RendererID) {.
    cdecl, importc: "GPU_SetRendererOrder", dynlib: SDL2_GPU_LIB.}
  ##  Sets the renderer ID order to use for initialization.
  ##
  ##  If ``order`` is `nil`, it will restore the default order.

proc init*(w, h: uint16; flags: WindowFlags): Target {.
    cdecl, importc: "GPU_Init", dynlib: SDL2_GPU_LIB.}
  ##  Initializes SDL's video subsystem (if necessary) and all of SDL_gpu's
  ##  internal structures. Chooses a renderer and creates a window with the
  ##  given dimensions and window creation flags. Returns a pointer
  ##  to the resulting window's render target.
  ##
  ##  ``w`` Desired window width in pixels.
  ##
  ##  ``h`` Desired window height in pixels.
  ##
  ##  ``flags`` The bit flags to pass to SDL when creating the window.
  ##  Use `GPU_DEFAULT_INIT_FLAGS` if you don't care.
  ##
  ##  ``Return`` On success, returns the new context target
  ##  (i.e. render target backed by a window). On failure, returns `nil`.
  ##
  ##  Initializes these systems:
  ##
  ##  * The 'error queue': Stores error codes and description strings.
  ##  * The 'renderer registry': An array of information about the supported
  ##    renderers on the current platform, such as the renderer name and id
  ##    and its life cycle functions.
  ##  * The SDL library and its video subsystem: Calls ``init()`` if SDL
  ##    has not already been initialized. Use ``initSubsystem()`` to initialize
  ##    more parts of SDL.
  ##  * The current renderer: Walks through each renderer in the renderer
  ##    registry and tries to initialize them until one succeeds.
  ##
  ##  See also:
  ##
  ##  ``RendererID``
  ##
  ##  ``initRenderer()``
  ##
  ##  ``initRendererByID()``
  ##
  ##  ``setRendererOrder()``
  ##
  ##  ``pushErrorCode()``

proc initRenderer*(
  RendererKind: RendererKind; w, h: uint16; flags: WindowFlags): Target {.
    cdecl, importc: "GPU_InitRenderer", dynlib: SDL2_GPU_LIB.}
  ##  Initializes SDL and SDL_gpu.
  ##
  ##  Creates a window and the requested renderer context.

proc initRendererByID*(
  rendererRequest: RendererID; w, h: uint16; flags: WindowFlags): Target {.
    cdecl, importc: "GPU_InitRendererByID", dynlib: SDL2_GPU_LIB.}
  ##  Initializes SDL and SDL_gpu.
  ##  Creates a window and the requested renderer context.
  ##
  ##  By requesting a renderer via ID, you can specify the major and minor
  ##  versions of an individual renderer backend.
  ##
  ##  See also:
  ##
  ##  ``makeRendererID()``

proc isFeatureEnabled*(feature: FeatureFlags): bool {.
    cdecl, importc: "GPU_IsFeatureEnabled", dynlib: SDL2_GPU_LIB.}
  ##  Checks for important GPU features which may not be supported
  ##  depending on a device's extension support.
  ##
  ##  ``feature`` flags (`FEATURE_*`) can be bitwise OR'd together.
  ##
  ##  ``Return`` `1` if all of the passed features are enabled/supported,
  ##  or `0` if any of the passed features are disabled/unsupported.

proc closeCurrentRenderer*() {.
    cdecl, importc: "GPU_CloseCurrentRenderer", dynlib: SDL2_GPU_LIB.}
  ##  Clean up the renderer state.

proc quit*() {.cdecl, importc: "GPU_Quit", dynlib: SDL2_GPU_LIB.}
  ##  Clean up the renderer state and shut down SDL_gpu.

# End of Initialization


# Debugging, logging, and error handling

const
  Log* = logInfo

proc setDebugLevel*(level: DebugLevel) {.
    cdecl, importc: "GPU_SetDebugLevel", dynlib: SDL2_GPU_LIB.}
  ##  Sets the global debug level.
  ##
  ##  `DEBUG_LEVEL_0`: Normal
  ##
  ##  `DEBUG_LEVEL_1`: Prints messages when errors are pushed via ``pushErrorCode()``
  ##
  ##  `DEBUG_LEVEL_2`: Elevates warning logs to error priority
  ##
  ##  `DEBUG_LEVEL_3`: Elevates info logs to error priority

proc getDebugLevel*(): DebugLevel {.
    cdecl, importc: "GPU_GetDebugLevel", dynlib: SDL2_GPU_LIB.}
  ##  Returns the current global debug level.

proc logInfo*(format: cstring) {.
    varargs, cdecl, importc: "GPU_LogInfo", dynlib: SDL2_GPU_LIB.}
  ##  Prints an informational log message.

proc logWarning*(format: cstring) {.
    varargs, cdecl, importc: "GPU_LogWarning", dynlib: SDL2_GPU_LIB.}
  ##  Prints a warning log message.

proc logError*(format: cstring) {.
    varargs, cdecl, importc: "GPU_LogError", dynlib: SDL2_GPU_LIB.}
  ##  Prints an error log message.

proc setLogCallback*(callback: proc (logLevel: LogLevel; format: cstring;
                     args: varargs[cstring]): cint {.cdecl.}) {.
    cdecl, importc: "GPU_SetLogCallback", dynlib: SDL2_GPU_LIB.}
  ##  Sets a custom callback for handling logging.
  ##
  ##  Use stdio's ``vsnprintf()`` to process the ``va_list`` into a string.
  ##
  ##  Passing `nil` as the callback will reset to the default internal logging.

proc pushErrorCode*(function: cstring; error: ErrorType; details: cstring) {.
    varargs, cdecl, importc: "GPU_PushErrorCode", dynlib: SDL2_GPU_LIB.}
  ##  Pushes a new error code into the error queue.
  ##  If the queue is full, the queue is not modified.
  ##
  ##  ``function`` The name of the function that pushed the error.
  ##
  ##  ``error`` The error code to push on the error queue.
  ##
  ##  ``details`` Additional information string, can be `nil`.

proc popErrorCode*(): ErrorObject {.
    cdecl, importc: "GPU_PopErrorCode", dynlib: SDL2_GPU_LIB.}
  ##  Pops an error object from the error queue and returns it.
  ##
  ##  If the error queue is empty, it returns an error object with `nil`
  ##  function, `ERROR_NONE` error, and `nil` details.

proc getErrorString*(error: ErrorType): cstring {.
    cdecl, importc: "GPU_GetErrorString", dynlib: SDL2_GPU_LIB.}
  ##  Gets the string representation of an error code.

proc setErrorQueueMax*(max: cuint) {.
    cdecl, importc: "GPU_SetErrorQueueMax", dynlib: SDL2_GPU_LIB.}
  ##  Changes the maximum number of error objects that SDL_gpu will store
  ##  This deletes all currently stored errors.

# End of Logging


# RendererSetup

proc makeRendererID*(name: cstring; renderer: RendererKind; majorVersion: cint;
                     minorVersion: cint): RendererID {.
    cdecl, importc: "GPU_MakeRendererID", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` an initialized ``RendererID``.

proc getRendererID*(renderer: RendererKind): RendererID {.
    cdecl, importc: "GPU_GetRendererID", dynlib: SDL2_GPU_LIB.}
  ##  Gets the first registered renderer identifier for the given enum value.

proc getNumRegisteredRenderers*(): cint {.
    cdecl, importc: "GPU_GetNumRegisteredRenderers", dynlib: SDL2_GPU_LIB.}
  ##  Gets the number of registered (available) renderers.

proc getRegisteredRendererList*(renderersArray: ptr RendererID) {.
    cdecl, importc: "GPU_GetRegisteredRendererList", dynlib: SDL2_GPU_LIB.}
  ##  Gets an array of identifiers for the registered (available) renderers.

proc registerRenderer*(
  id: RendererID;
  createRenderer: proc (request: RendererID): Renderer {.cdecl.};
  freeRenderer: proc (renderer: Renderer) {.cdecl.}) {.
    cdecl, importc: "GPU_RegisterRenderer", dynlib: SDL2_GPU_LIB.}
  ##  Prepares a renderer for use by SDL_gpu.

# End of RendererSetup


# RendererControls

proc reserveNextRendererEnum*(): RendererKind {.
    cdecl, importc: "GPU_ReserveNextRendererEnum", dynlib: SDL2_GPU_LIB.}
  ##  Gets the next enum ID that can be used for a custom renderer.

proc getNumActiveRenderers*(): cint {.
    cdecl, importc: "GPU_GetNumActiveRenderers", dynlib: SDL2_GPU_LIB.}
  ##  Gets the number of active (created) renderers.

proc getActiveRendererList*(renderersArray: ptr RendererID) {.
    cdecl, importc: "GPU_GetActiveRendererList", dynlib: SDL2_GPU_LIB.}
  ##  Gets an array of identifiers for the active renderers.

proc getCurrentRenderer*(): Renderer {.
    cdecl, importc: "GPU_GetCurrentRenderer", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the current renderer.

proc setCurrentRenderer*(id: RendererID) {.
    cdecl, importc: "GPU_SetCurrentRenderer", dynlib: SDL2_GPU_LIB.}
  ##  Switches the current renderer to the renderer
  ##  matching the given identifier.

proc getRenderer*(id: RendererID): Renderer {.
    cdecl, importc: "GPU_GetRenderer", dynlib: SDL2_GPU_LIB.}

proc freeRenderer*(renderer: Renderer) {.
    cdecl, importc: "GPU_FreeRenderer", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the renderer matching the given identifier.

proc resetRendererState*() {.
    cdecl, importc: "GPU_ResetRendererState", dynlib: SDL2_GPU_LIB.}
  ##  Reapplies the renderer state to the backend API (e.g. OpenGL, Direct3D).
  ##
  ##  Use this if you want SDL_gpu to be able to render
  ##  after you've used direct backend calls.

proc setCoordinateMode*(useMathCoords: bool) {.
    cdecl, importc: "GPU_SetCoordinateMode", dynlib: SDL2_GPU_LIB.}
  ##  Sets the coordinate mode for this renderer.
  ##
  ##  Target and image coordinates will be either
  ##  "inverted" (0,0 is the upper left corner, y increases downward) or
  ##  "mathematical" (0,0 is the bottom-left corner, y increases upward).
  ##
  ##  The default is inverted (`0`), as this is traditional for 2D graphics.
  ##
  ##  param inverted `0` is for inverted coordinates,
  ##  `1` is for mathematical coordinates

proc getCoordinateMode*(): bool {.
    cdecl, importc: "GPU_GetCoordinateMode", dynlib: SDL2_GPU_LIB.}

proc setDefaultAnchor*(anchorX, anchorY: cfloat) {.
    cdecl, importc: "GPU_SetDefaultAnchor", dynlib: SDL2_GPU_LIB.}
  ##  Sets the default image blitting anchor for newly created images.
  ##
  ##  See also:
  ##
  ##  ``setAnchor()``

proc getDefaultAnchor*(anchorX: ptr cfloat; anchorY: ptr cfloat) {.
    cdecl, importc: "GPU_GetDefaultAnchor", dynlib: SDL2_GPU_LIB.}
  ##  Returns the default image blitting anchor through the given variables.
  ##
  ##  See also:
  ##
  ##  ``getAnchor()``

#  End of RendererControls


#  Context / window controls

proc getContextTarget*(): Target {.
    cdecl, importc: "GPU_GetContextTarget", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the renderer's current context target.

proc getWindowTarget*(windowID: uint32): Target {.
    cdecl, importc: "GPU_GetWindowTarget", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the target that is associated with the given ``windowID``.

proc createTargetFromWindow*(windowID: uint32): Target {.
    cdecl, importc: "GPU_CreateTargetFromWindow", dynlib: SDL2_GPU_LIB.}
  ##  Creates a separate context for the given window
  ##  using the current renderer and returns a target that represents it.

proc makeCurrent*(target: Target; windowID: uint32) {.
    cdecl, importc: "GPU_MakeCurrent", dynlib: SDL2_GPU_LIB.}
  ##  Makes the given window the current rendering destination
  ##  for the given context target.
  ##
  ##  This also makes the target the current context for image loading
  ##  and window operations.
  ##
  ##  If the target does not represent a window, this does nothing.

proc setWindowResolution*(w: uint16; h: uint16): bool {.
    cdecl, importc: "GPU_SetWindowResolution", dynlib: SDL2_GPU_LIB.}
  ##  Change the actual size of the current context target's window.
  ##
  ##  This resets the virtual resolution and viewport of the context target.
  ##
  ##  Aside from direct resolution changes, this should also be called
  ##  in response to SDL's `WINDOWEVENT_RESIZED` window events
  ##  for resizable windows.

proc setFullscreen*(enableFullscreen: bool; useDesktopResolution: bool): bool {.
    cdecl, importc: "GPU_SetFullscreen", dynlib: SDL2_GPU_LIB.}
  ##  Enable/disable fullscreen mode for the current context target's window.
  ##
  ##  On some platforms, this may destroy the renderer context and require that
  ##  textures be reloaded. Unfortunately, SDL does not provide a notification
  ##  mechanism for this.
  ##
  ##  ``enableFullscreen`` If ``true``, make the application go fullscreen,
  ##  if ``false``, make the application go to windowed mode.
  ##
  ##  ``useDesktopResolution`` If ``true``, lets the window change its
  ##  resolution when it enters fullscreen mode
  ##  (via SDL's `WINDOW_FULLSCREEN_DESKTOP`).
  ##
  ##  ``Return`` `0` if the new mode is windowed,
  ##  `1` if the new mode is fullscreen.

proc getFullscreen*(): bool {.
    cdecl, importc: "GPU_GetFullscreen", dynlib: SDL2_GPU_LIB.}
  ##  Returns true if the current context target's window is in fullscreen mode.

proc setShapeBlending*(enable: bool) {.
    cdecl, importc: "GPU_SetShapeBlending", dynlib: SDL2_GPU_LIB.}
  ##  Enables/disables alpha blending for shape rendering on the current window.

proc getBlendModeFromPreset*(preset: BlendPreset): BlendMode {.
    cdecl, importc: "GPU_GetBlendModeFromPreset", dynlib: SDL2_GPU_LIB.}
  ##  Translates a blend preset into a blend mode.

proc setShapeBlendFunction*(sourceColor: BlendFunc; destColor: BlendFunc;
                            sourceAlpha: BlendFunc; destAlpha: BlendFunc) {.
    cdecl, importc: "GPU_SetShapeBlendFunction", dynlib: SDL2_GPU_LIB.}
  ##  Sets the blending component functions for shape rendering.

proc setShapeBlendEquation*(colorEquation: BlendEq; alphaEquation: BlendEq) {.
    cdecl, importc: "GPU_SetShapeBlendEquation", dynlib: SDL2_GPU_LIB.}
  ##  Sets the blending component equations for shape rendering.

proc setShapeBlendMode*(mode: BlendPreset) {.
    cdecl, importc: "GPU_SetShapeBlendMode", dynlib: SDL2_GPU_LIB.}
  ##  Sets the blending mode for shape rendering on the current window,
  ##  if supported by the renderer.

proc setLineThickness*(thickness: cfloat): cfloat {.
    cdecl, importc: "GPU_SetLineThickness", dynlib: SDL2_GPU_LIB.}
  ##  Sets the thickness of lines for the current context.
  ##
  ##  ``thickness`` New line thickness in pixels measured across the line.
  ##  Default is `1.0f`.
  ##
  ##  ``Return`` the old thickness value.

proc getLineThickness*(): cfloat {.
    cdecl, importc: "GPU_GetLineThickness", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the current line thickness value.

# End of ContextControls


# TargetControls

proc createAliasTarget*(target: Target): Target {.
    cdecl, importc: "GPU_CreateAliasTarget", dynlib: SDL2_GPU_LIB.}
  ##  Creates a target that aliases the given target.
  ##
  ##  Aliases can be used to store target settings (e.g. viewports)
  ##  for easy switching.
  ##
  ##  ``freeTarget()`` frees the alias's memory,
  ##  but does not affect the original.

proc loadTarget*(image: Image): Target {.
    cdecl, importc: "GPU_LoadTarget", dynlib: SDL2_GPU_LIB.}
  ##  Creates a new render target from the given image.
  ##  It can then be accessed from ``image.target``.
  ##
  ##  This increments the internal refcount of the target,
  ##  so it should be matched with a ``freeTarget()``.

proc getTarget*(image: Image): Target {.
    cdecl, importc: "GPU_GetTarget", dynlib: SDL2_GPU_LIB.}
  ##  Creates a new render target from the given image.
  ##  It can then be accessed from ``image.target``.
  ##
  ##  This does not increment the internal refcount of the target,
  ##  so it will be invalidated when the image is freed.

proc freeTarget*(target: Target) {.
    cdecl, importc: "GPU_FreeTarget", dynlib: SDL2_GPU_LIB.}
  ##  Deletes a render target in the proper way for this renderer.

proc setVirtualResolution*(target: Target; w, h: uint16) {.
    cdecl, importc: "GPU_SetVirtualResolution", dynlib: SDL2_GPU_LIB.}
  ##  Change the logical size of the given target.
  ##
  ##  Rendering to this target will be scaled
  ##  as if the dimensions were actually the ones given.

proc getVirtualResolution*(target: Target; w, h: ptr uint16) {.
    cdecl, importc: "GPU_GetVirtualResolution", dynlib: SDL2_GPU_LIB.}
  ##  Query the logical size of the given target.

proc getVirtualCoords*(target: Target; x, y: ptr cfloat; displayX, displayY: cfloat) {.
    cdecl, importc: "GPU_GetVirtualCoords", dynlib: SDL2_GPU_LIB.}
  ##  Converts screen space coordinates (such as from mouse input)
  ##  to logical drawing coordinates.
  ##
  ##  This interacts with ``setCoordinateMode()`` when the y-axis is flipped
  ##  (screen space is assumed to be inverted: (0,0) in the upper-left corner).

proc unsetVirtualResolution*(target: Target) {.
    cdecl, importc: "GPU_UnsetVirtualResolution", dynlib: SDL2_GPU_LIB.}
  ##  Reset the logical size of the given target to its original value.

proc makeRect*(x, y, w, h: cfloat): Rect {.
    cdecl, importc: "GPU_MakeRect", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` a ``Rect`` with the given values.

proc makeColor*(r, g, b, a: uint8): Color {.
    cdecl, importc: "GPU_MakeColor", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` a ``Color`` with the given values.

proc setViewport*(target: Target; viewport: Rect) {.
    cdecl, importc: "GPU_SetViewport", dynlib: SDL2_GPU_LIB.}
  ##  Sets the given target's viewport.

proc unsetViewport*(target: Target) {.
    cdecl, importc: "GPU_UnsetViewport", dynlib: SDL2_GPU_LIB.}
  ##  Resets the given target's viewport to the entire target area.

proc getDefaultCamera*(): Camera {.
    cdecl, importc: "GPU_GetDefaultCamera", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` a ``Camera`` with position (0, 0, 0),
  ##  angle of `0`, zoom of `1`, and near/far clipping planes of -100 and 100.

proc getCamera*(target: Target): Camera {.
    cdecl, importc: "GPU_GetCamera", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the camera of the given render target.
  ##  If target is `nil`, returns the default camera.

proc setCamera*(target: Target; cam: ptr Camera): Camera {.
    cdecl, importc: "GPU_SetCamera", dynlib: SDL2_GPU_LIB.}
  ##  Sets the current render target's current camera.
  ##
  ##  ``target`` A pointer to the target that will copy this camera.
  ##
  ##  ``cam`` A pointer to the camera data to use
  ##  or `nil` to use the default camera.
  ##
  ##  ``Return`` the old camera.

proc enableCamera*(target: Target; useCamera: bool) {.
    cdecl, importc: "GPU_EnableCamera", dynlib: SDL2_GPU_LIB.}
  ##  Enables or disables using the built-in camera matrix transforms.

proc isCameraEnabled*(target: Target): bool {.
    cdecl, importc: "GPU_IsCameraEnabled", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` `1` if the camera transforms are enabled, `0` otherwise.

proc addDepthBuffer*(target: Target) {.
    cdecl, importc: "GPU_AddDepthBuffer", dynlib: SDL2_GPU_LIB.}
  ##  Attach a new depth buffer to the given target so that it can use depth testing.
  ##  Context targets automatically have a depth buffer already.
  ##  If successful, also enables depth testing for this target.

proc setDepthTest*(target: Target, enable: bool) {.
    cdecl, importc: "GPU_SetDepthTest", dynlib: SDL2_GPU_LIB.}
  ##  Enables or disables the depth test, which will skip drawing pixels/fragments behind other fragments.
  ##  Disabled by default.
  ##  This has implications for alpha blending, where compositing might not work correctly depending on render order.

proc setDepthWrite*(target: Target, enable: bool) {.
    cdecl, importc: "GPU_SetDepthWrite", dynlib: SDL2_GPU_LIB.}
  ##  Enables or disables writing the depth (effective view z-coordinate) of new pixels to the depth buffer.
  ##  Enabled by default, but you must call setDepthTest() to use it.

proc setDepthFunction*(target: Target; compareOperation: ComparisonEnum) {.
    cdecl, importc: "GPU_SetDepthFunction", dynlib: SDL2_GPU_LIB.}
  ##  Sets the operation to perform when depth testing.

proc getPixel*(target: Target; x, y: int16): Color {.
    cdecl, importc: "GPU_GetPixel", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the RGBA color of a pixel.

proc setClipRect*(target: Target; rect: Rect): Rect {.
    cdecl, importc: "GPU_SetClipRect", dynlib: SDL2_GPU_LIB.}
  ##  Sets the clipping rect for the given render target.

proc setClip*(target: Target; x, y: int16; w, h: uint16): Rect {.
    cdecl, importc: "GPU_SetClip", dynlib: SDL2_GPU_LIB.}
  ##  Sets the clipping rect for the given render target.

proc unsetClip*(target: Target) {.
    cdecl, importc: "GPU_UnsetClip", dynlib: SDL2_GPU_LIB.}
  ##  Turns off clipping for the given target.

proc intersectRect*(a: Rect; b: Rect; result: ptr Rect): bool {.
    cdecl, importc: "GPU_IntersectRect", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` ``true`` if the given rects A and B overlap,
  ##  in which case it also fills the given ``result`` rect with the
  ##  intersection. ``result`` can be nil if you don't need the intersection.

proc intersectClipRect*(target: Target; b: Rect; result: ptr Rect): bool {.
    cdecl, importc: "GPU_IntersectClipRect", dynlib: SDL2_GPU_LIB.}
  ##  Returns ``true`` if the given target's clip rect and the given B rect
  ##  overlap, in which case it also fills the given result rect with the
  ##  intersection. ``result`` can be nil if you don't need the intersection.
  ##
  ##  If the target doesn't have a clip rect enabled,
  ##  this uses the whole target area.

proc setTargetColor*(target: Target; color: Color) {.
    cdecl, importc: "GPU_SetTargetColor", dynlib: SDL2_GPU_LIB.}
  ##  Sets the modulation color for subsequent drawing of images and shapes
  ##  on the given target. This has a cumulative effect with the image coloring
  ##  functions.
  ##  e.g. setRGB(image, 255, 128, 0); setTargetRGB(target, 128, 128, 128);
  ##  Would make the image draw with color of roughly (128, 64, 0).

proc setTargetRGB*(target: Target; r, g, b: uint8) {.
    cdecl, importc: "GPU_SetTargetRGB", dynlib: SDL2_GPU_LIB.}
  ##  Sets the modulation color for subsequent drawing of images and shapes
  ##  on the given target. This has a cumulative effect with the image coloring
  ##  functions.
  ##  e.g. setRGB(image, 255, 128, 0); setTargetRGB(target, 128, 128, 128);
  ##  Would make the image draw with color of roughly (128, 64, 0).

proc setTargetRGBA*(target: Target; r, g, b, a: uint8) {.
    cdecl, importc: "GPU_SetTargetRGBA", dynlib: SDL2_GPU_LIB.}
  ##  Sets the modulation color for subsequent drawing of images and shapes on the given target.
  ##  This has a cumulative effect with the image coloring functions.
  ##  e.g. setRGB(image, 255, 128, 0); setTargetRGB(target, 128, 128, 128);
  ##  Would make the image draw with color of roughly (128, 64, 0).

proc unsetTargetColor*(target: Target) {.
    cdecl, importc: "GPU_UnsetTargetColor", dynlib: SDL2_GPU_LIB.}
  ##  Unsets the modulation color for subsequent drawing of images and shapes on
  ##  the given target. This has the same effect as coloring with pure opaque
  ##  white (255, 255, 255, 255).

# End of TargetControls


# SurfaceControls

proc loadSurface*(filename: cstring): Surface {.
    cdecl, importc: "GPU_LoadSurface", dynlib: SDL2_GPU_LIB.}
  ##  Load surface from an image file that is supported by this renderer.
  ##  Don't forget to SDL's ``freeSurface()`` it.

proc loadSurfaceRW*(rwops: ptr RWops; freeRwops: bool): Surface {.
    cdecl, importc: "GPU_LoadSurface_RW", dynlib: SDL2_GPU_LIB.}
  ##  Load surface from an image file in memory.
  ##  Don't forget to SDL's ``freeSurface()`` it.

proc saveSurface*(surface: Surface; filename: cstring; format: FileFormat): bool {.
    cdecl, importc: "GPU_SaveSurface", dynlib: SDL2_GPU_LIB.}
  ##  Save surface to a file.
  ##  With a format of `FILE_AUTO`, the file type is deduced from the extension.
  ##
  ##  Supported formats are: png, bmp, tga.
  ##
  ##  ``Return`` `0` on failure.

proc saveSurfaceRW*(surface: Surface; rwops: ptr RWops; freeRwops: bool;
                   format: FileFormat): bool {.
    cdecl, importc: "GPU_SaveSurface_RW", dynlib: SDL2_GPU_LIB.}
  ##  Save surface to a ``RWops`` stream.
  ##
  ##  Does not support format of `FILE_AUTO`,
  ##  because the file type cannot be deduced.
  ##
  ##  Supported formats are: png, bmp, tga.
  ##
  ##  ``Return`` `0` on failure.

# End of SurfaceControls


# ImageControls

proc createImage*(w, h: uint16; format: Format): Image {.
    cdecl, importc: "GPU_CreateImage", dynlib: SDL2_GPU_LIB.}
  ##  Create a new, blank image with the given format.
  ##  Don't forget to ``freeImage()`` it.
  ##
  ##  ``w`` Image width in pixels.
  ##
  ##  ``h`` Image height in pixels.
  ##
  ##  ``format`` Format of color channels.

proc createImageUsingTexture*(handle: TextureHandle; takeOwnership: bool): Image {.
    cdecl, importc: "GPU_CreateImageUsingTexture", dynlib: SDL2_GPU_LIB.}
  ##  Create a new image that uses the given native texture handle
  ##  as the image texture.

proc loadImage*(filename: cstring): Image {.
    cdecl, importc: "GPU_LoadImage", dynlib: SDL2_GPU_LIB.}
  ##  Load image from an image file that is supported by this renderer.
  ##  Don't forget to ``freeImage()`` it.

proc loadImageRW*(rwops: ptr RWops; freeRwops: bool): Image {.
    cdecl, importc: "GPU_LoadImage_RW", dynlib: SDL2_GPU_LIB.}
  ##  Load image from an image file in memory
  ##  Don't forget to ``freeImage()`` it.

proc createAliasImage*(image: Image): Image {.
    cdecl, importc: "GPU_CreateAliasImage", dynlib: SDL2_GPU_LIB.}
  ##  Creates an image that aliases the given image.
  ##  Aliases can be used to store image settings (e.g. modulation color)
  ##  for easy switching. ``freeImage()`` frees the alias's memory,
  ##  but does not affect the original.

proc copyImage*(image: Image): Image {.
    cdecl, importc: "GPU_CopyImage", dynlib: SDL2_GPU_LIB.}
  ##  Copy an image to a new image
  ##  Don't forget to ``freeImage()`` both.

proc freeImage*(image: Image) {.
    cdecl, importc: "GPU_FreeImage", dynlib: SDL2_GPU_LIB.}
  ##  Deletes an image in the proper way for this renderer.
  ##  Also deletes the corresponding target if applicable.
  ##  Be careful not to use that target afterward!

proc setImageVirtualResolution*(image: Image; w: uint16; h: uint16) {.
    cdecl, importc: "GPU_SetImageVirtualResolution", dynlib: SDL2_GPU_LIB.}
  ##  Change the logical size of the given image.
  ##  Rendering this image will scaled it
  ##  as if the dimensions were actually the ones given.

proc unsetImageVirtualResolution*(image: Image) {.
    cdecl, importc: "GPU_UnsetImageVirtualResolution", dynlib: SDL2_GPU_LIB.}
  ##  Reset the logical size of the given image to its original value.

proc updateImage*(image: Image; imageRect: ptr Rect; surface: Surface;
                  surfaceRect: ptr Rect) {.
    cdecl, importc: "GPU_UpdateImage", dynlib: SDL2_GPU_LIB.}
  ##  Update an image from surface data.
  ##
  ##  Ignores virtual resolution on the image so the number of pixels
  ##  needed from the surface is known.

proc updateImageBytes*(
  image: Image; imageRect: ptr Rect; bytes: ptr cuchar; bytesPerRow: cint) {.
    cdecl, importc: "GPU_UpdateImageBytes", dynlib: SDL2_GPU_LIB.}
  ##  Update an image from an array of pixel data.
  ##
  ##  Ignores virtual resolution on the image
  ##  so the number of pixels needed from the surface is known.

proc replaceImage*(image: Image; surface: Surface; surfaceRect: ptr Rect): bool {.
    cdecl, importc: "GPU_ReplaceImage", dynlib: SDL2_GPU_LIB.}
  ##  Update an image from surface data,
  ##  replacing its underlying texture to allow for size changes.
  ##
  ##  Ignores virtual resolution on the image
  ##  so the number of pixels needed from the surface is known.

proc saveImage*(image: Image; filename: cstring; format: FileFormat): bool {.
    cdecl, importc: "GPU_SaveImage", dynlib: SDL2_GPU_LIB.}
  ##  Save image to a file.
  ##  With a format of `FILE_AUTO`, the file type is deduced from the extension.
  ##
  ##  Supported formats are: png, bmp, tga.
  ##
  ##  ``Return`` `0` on failure.

proc saveImageRW*(
  image: Image; rwops: ptr RWops; freeRwops: bool; format: FileFormat): bool {.
    cdecl, importc: "GPU_SaveImage_RW", dynlib: SDL2_GPU_LIB.}
  ##  Save image to a ``RWops`` stream.
  ##  Does not support format of `FILE_AUTO`,
  ##  because the file type cannot be deduced.
  ##
  ##  Supported formats are: png, bmp, tga.
  ##
  ##  ``Return`` `0` on failure.

proc generateMipmaps*(image: Image) {.
    cdecl, importc: "GPU_GenerateMipmaps", dynlib: SDL2_GPU_LIB.}
  ##  Loads mipmaps for the given image, if supported by the renderer.

proc setColor*(image: Image; color: Color) {.
    cdecl, importc: "GPU_SetColor", dynlib: SDL2_GPU_LIB.}
  ##  Sets the modulation color for subsequent drawing of the given image.

proc setRGB*(image: Image; r: uint8; g: uint8; b: uint8) {.
    cdecl, importc: "GPU_SetRGB", dynlib: SDL2_GPU_LIB.}
  ##  Sets the modulation color for subsequent drawing of the given image.

proc setRGBA*(image: Image; r: uint8; g: uint8; b: uint8; a: uint8) {.
    cdecl, importc: "GPU_SetRGBA", dynlib: SDL2_GPU_LIB.}
  ##  Sets the modulation color for subsequent drawing of the given image.

proc unsetColor*(image: Image) {.
    cdecl, importc: "GPU_UnsetColor", dynlib: SDL2_GPU_LIB.}
  ##  Unsets the modulation color for subsequent drawing of the given image.
  ##  This is equivalent to coloring with pure opaque white (255, 255, 255, 255).

proc getBlending*(image: Image): bool {.
    cdecl, importc: "GPU_GetBlending", dynlib: SDL2_GPU_LIB.}
  ##  Gets the current alpha blending setting.

proc setBlending*(image: Image; enable: bool) {.
    cdecl, importc: "GPU_SetBlending", dynlib: SDL2_GPU_LIB.}
  ##  Enables/disables alpha blending for the given image.

proc setBlendFunction*(image: Image; sourceColor: BlendFunc;
                       destColor: BlendFunc; sourceAlpha: BlendFunc;
                       destAlpha: BlendFunc) {.
    cdecl, importc: "GPU_SetBlendFunction", dynlib: SDL2_GPU_LIB.}
  ##  Sets the blending component functions.

proc setBlendEquation*(image: Image; colorEquation: BlendEq;
                       alphaEquation: BlendEq) {.
    cdecl, importc: "GPU_SetBlendEquation", dynlib: SDL2_GPU_LIB.}
  ##  Sets the blending component equations.

proc setBlendMode*(image: Image; mode: BlendPreset) {.
    cdecl, importc: "GPU_SetBlendMode", dynlib: SDL2_GPU_LIB.}
  ##  Sets the blending mode, if supported by the renderer.

proc setImageFilter*(image: Image; filter: Filter) {.
    cdecl, importc: "GPU_SetImageFilter", dynlib: SDL2_GPU_LIB.}
  ##  Sets the image filtering mode, if supported by the renderer.

proc setAnchor*(image: Image; anchorX, anchorY: cfloat) {.
    cdecl, importc: "GPU_SetAnchor", dynlib: SDL2_GPU_LIB.}
  ##  Sets the image anchor,
  ##  which is the point about which the image is blitted.
  ##
  ##  The default is to blit the image on-center (0.5, 0.5).
  ##  The anchor is in normalized coordinates (0.0-1.0).

proc getAnchor*(image: Image; anchorX, anchorY: ptr cfloat) {.
    cdecl, importc: "GPU_GetAnchor", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the image anchor via the passed parameters.
  ##  The anchor is in normalized coordinates (0.0-1.0).

proc getSnapMode*(image: Image): Snap {.
    cdecl, importc: "GPU_GetSnapMode", dynlib: SDL2_GPU_LIB.}
  ##  Gets the current pixel snap setting.
  ##  The default value is `SNAP_POSITION_AND_DIMENSIONS`.

proc setSnapMode*(image: Image; mode: Snap) {.
    cdecl, importc: "GPU_SetSnapMode", dynlib: SDL2_GPU_LIB.}
  ##  Sets the pixel grid snapping mode for the given image.

proc setWrapMode*(image: Image; wrapModeX: Wrap; wrapModeY: Wrap) {.
    cdecl, importc: "GPU_SetWrapMode", dynlib: SDL2_GPU_LIB.}
  ##  Sets the image wrapping mode, if supported by the renderer.

proc getTextureHandle*(image: Image):TextureHandle {.
    cdecl, importc: "GPU_GetTextureHandle", dynlib: SDL2_GPU_LIB.}
  ##  Returns the backend-specific texture handle associated with the given image.
  ##  Note that SDL_gpu will be unaware of changes made to the texture.

# End of ImageControls


# Surface / Image / Target conversions

proc copyImageFromSurface*(surface: Surface): Image {.
    cdecl, importc: "GPU_CopyImageFromSurface", dynlib: SDL2_GPU_LIB.}
  ##  Copy Surface data into a new image.
  ##  Don't forget to SDL's ``freeSurface()`` the surface
  ##  and ``freeImage()`` the image.

proc copyImageFromTarget*(target: Target): Image {.
    cdecl, importc: "GPU_CopyImageFromTarget", dynlib: SDL2_GPU_LIB.}
  ##  Copy target data into a new image.
  ##  Don't forget to ``freeImage()`` the image.

proc copySurfaceFromTarget*(target: Target): Surface {.
    cdecl, importc: "GPU_CopySurfaceFromTarget", dynlib: SDL2_GPU_LIB.}
  ##  Copy target data into a new ``Surface``.
  ##  Don't forget to SDL's ``freeSurface()`` the surface.

proc copySurfaceFromImage*(image: Image): Surface {.
    cdecl, importc: "GPU_CopySurfaceFromImage", dynlib: SDL2_GPU_LIB.}
  ##  Copy image data into a new ``Surface``.
  ##  Don't forget to SDL's ``freeSurface()`` the surface
  ##  and ``freeImage()`` the image.

# End of Conversions


# Matrix
# Basic vector operations (3D)

proc vectorLength*(vec3: ptr cfloat): cfloat {.
    cdecl, importc: "GPU_VectorLength", dynlib: SDL2_GPU_LIB.}
  ##  Returns the magnitude (length) of the given vector.

proc vectorNormalize*(vec3: ptr cfloat) {.
    cdecl, stdcall, importc: "GPU_VectorNormalize", dynlib: SDL2_GPU_LIB.}
  ##  Modifies the given vector so that it has a new length of `1`.

proc vectorDot*(a: ptr cfloat; b: ptr cfloat): cfloat {.
    cdecl, importc: "GPU_VectorDot", dynlib: SDL2_GPU_LIB.}
  ##  Returns the dot product of two vectors.

proc vectorCross*(result: ptr cfloat; a: ptr cfloat; b: ptr cfloat) {.
    cdecl, importc: "GPU_VectorCross", dynlib: SDL2_GPU_LIB.}
  ##  Performs the cross product of vectors A and B (result = A x B)
  ##  Do not use A or B as ``result``.

proc vectorCopy*(result: ptr cfloat; a: ptr cfloat) {.
    cdecl, importc: "GPU_VectorCopy", dynlib: SDL2_GPU_LIB.}
  ##  Overwrite ``result`` vector with the values from vector A.

proc vectorApplyMatrix*(vec3: ptr cfloat; matrix4x4: ptr cfloat) {.
    cdecl, importc: "GPU_VectorApplyMatrix", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies the given matrix into the given vector (vec3 = matrix*vec3).

proc vectorApplyMatrix*(vec4: ptr cfloat; matrix4x4: ptr cfloat) {.
    cdecl, importc: "GPU_Vector4ApplyMatrix", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies the given matrix into the given vector (vec4 = matrix*vec4).

# Basic matrix operations (4x4)

proc matrixCopy*(result: ptr cfloat; a: ptr cfloat) {.
    cdecl, importc: "GPU_MatrixCopy", dynlib: SDL2_GPU_LIB.}
  ##  Overwrite ``result`` matrix with the values from matrix A.

proc matrixIdentity*(result: ptr cfloat) {.
    cdecl, importc: "GPU_MatrixIdentity", dynlib: SDL2_GPU_LIB.}
  ##  Fills ``result`` matrix with the identity matrix.

proc matrixOrtho*(result: ptr cfloat; left: cfloat; right: cfloat; bottom: cfloat;
                  top: cfloat; zNear: cfloat; zFar: cfloat) {.
    cdecl, importc: "GPU_MatrixOrtho", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies an orthographic projection matrix into the given matrix.

proc matrixFrustum*(result: ptr cfloat; left: cfloat; right: cfloat; bottom: cfloat;
                    top: cfloat; zNear: cfloat; zFar: cfloat) {.
    cdecl, importc: "GPU_MatrixFrustum", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a perspective projection matrix into the given matrix.

proc matrixPerspective*(result: ptr cfloat; fovy: cfloat; aspect: cfloat;
                        zNear: cfloat; zFar: cfloat) {.
    cdecl, importc: "GPU_MatrixPerspective", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a perspective projection matrix into the given matrix.

proc matrixLookAt*(matrix: ptr cfloat; eyeX: cfloat; eyeY: cfloat; eyeZ: cfloat;
                   targetX: cfloat; targetY: cfloat; targetZ: cfloat;
                   upX: cfloat; upY: cfloat; upZ: cfloat) {.
    cdecl, importc: "GPU_MatrixLookAt", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a view matrix into the given matrix.

proc matrixTranslate*(result: ptr cfloat; x: cfloat; y: cfloat; z: cfloat) {.
    cdecl, importc: "GPU_MatrixTranslate", dynlib: SDL2_GPU_LIB.}
  ##  Adds a translation into the given matrix.

proc matrixScale*(result: ptr cfloat; sx: cfloat; sy: cfloat; sz: cfloat) {.
    cdecl, importc: "GPU_MatrixScale", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a scaling matrix into the given matrix.

proc matrixRotate*(result: ptr cfloat; degrees: cfloat; x: cfloat; y: cfloat; z: cfloat) {.
    cdecl, importc: "GPU_MatrixRotate", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a rotation matrix into the given matrix.

proc multiply4x4*(result: ptr cfloat; a, b: ptr cfloat) {.
    cdecl, importc: "GPU_MatrixMultiply", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies matrices A and B and stores the result
  ##  in the given ``result`` matrix (result = A*B)
  ##  Do not use A or B as ``result``.
  ##
  ##  See also:
  ##
  ##  ``multiplyAndAssign()``

proc multiplyAndAssign*(result: ptr cfloat; b: ptr cfloat) {.
    cdecl, importc: "GPU_MultiplyAndAssign", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies matrices ``result`` and B and stores the result
  ##  in the given ``result`` matrix (result = result * B).

# Matrix stack accessors

proc getMatrixString*(a: ptr cfloat): cstring {.
    cdecl, importc: "GPU_GetMatrixString", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` an internal string that represents the contents of matrix A.

proc getCurrentMatrix*(): ptr cfloat {.
    cdecl, importc: "GPU_GetCurrentMatrix", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the current matrix from the top of the matrix stack,
  ##  or `nil` if stack is empty.

proc getModelView*(): ptr cfloat {.
    cdecl, importc: "GPU_GetModelView", dynlib: SDL2_GPU_LIB.}
  ##  ``Returns`` the current modelview matrix from the top of the matrix stack,
  ##  or `nil` if stack is empty.

proc getProjection*(): ptr cfloat {.
    cdecl, importc: "GPU_GetProjection", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the current projection matrix from the top of the matrix stack,
  ##  or `nil` if stack is empty.

proc getModelViewProjection*(result: ptr cfloat) {.
    cdecl, importc: "GPU_GetModelViewProjection", dynlib: SDL2_GPU_LIB.}
  ##  Copies the current modelview-projection matrix
  ##  into the given ``result`` matrix (result = P*M).

# Matrix stack manipulators

proc initMatrixStack*(stack: MatrixStack) {.
    cdecl, importc: "GPU_InitMatrixStack", dynlib: SDL2_GPU_LIB.}
  ##  Allocate new matrices for the given stack.

proc matrixMode*(matrixMode: cint) {.
    cdecl, importc: "GPU_MatrixMode", dynlib: SDL2_GPU_LIB.}
  ##  Changes matrix mode to either `PROJECTION` or `MODELVIEW`.
  ##  Further matrix stack operations manipulate that particular stack.

proc pushMatrix*() {.
    cdecl, importc: "GPU_PushMatrix", dynlib: SDL2_GPU_LIB.}
  ##  Pushes the current matrix as a new matrix stack item.

proc popMatrix*() {.
    cdecl, importc: "GPU_PopMatrix", dynlib: SDL2_GPU_LIB.}
  ##  Removes the current matrix from the stack.

proc loadIdentity*() {.
    cdecl, importc: "GPU_LoadIdentity", dynlib: SDL2_GPU_LIB.}
  ##  Fills current matrix with the identity matrix.

proc loadMatrix*(matrix4x4: ptr cfloat) {.
    cdecl, importc: "GPU_LoadMatrix", dynlib: SDL2_GPU_LIB.}
  ##  Copies a given matrix to be the current matrix.

proc ortho*(left: cfloat; right: cfloat; bottom: cfloat; top: cfloat;
    zNear: cfloat; zFar: cfloat) {.
    cdecl, importc: "GPU_Ortho", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies an orthographic projection matrix into the current matrix.

proc frustum*(left: cfloat; right: cfloat; bottom: cfloat; top: cfloat;
    zNear: cfloat; zFar: cfloat) {.
    cdecl, importc: "GPU_Frustum", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a perspective projection matrix into the current matrix.

proc translate*(x: cfloat; y: cfloat; z: cfloat) {.
    cdecl, importc: "GPU_Translate", dynlib: SDL2_GPU_LIB.}
  ##  Adds a translation into the current matrix.

proc scale*(sx: cfloat; sy: cfloat; sz: cfloat) {.
    cdecl, importc: "GPU_Scale", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a scaling matrix into the current matrix.

proc rotate*(degrees: cfloat; x: cfloat; y: cfloat; z: cfloat) {.
    cdecl, importc: "GPU_Rotate", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a rotation matrix into the current matrix.

proc multMatrix*(matrix4x4: ptr cfloat) {.
    cdecl, importc: "GPU_MultMatrix", dynlib: SDL2_GPU_LIB.}
  ##  Multiplies a given matrix into the current matrix.

# End of Matrix


# Rendering

proc clear*(target: Target) {.
    cdecl, importc: "GPU_Clear", dynlib: SDL2_GPU_LIB.}
  ##  Clears the contents of the given render target.
  ##  Fills the target with color [0, 0, 0, 0].

proc clearColor*(target: Target; color: Color) {.
    cdecl, importc: "GPU_ClearColor", dynlib: SDL2_GPU_LIB.}
  ##  Fills the given render target with a color.

proc clearRGB*(target: Target; r, g, b: uint8) {.
    cdecl, importc: "GPU_ClearRGB", dynlib: SDL2_GPU_LIB.}
  ##  Fills the given render target with a color (alpha is `255`, fully opaque).

proc clearRGBA*(target: Target; r, g, b, a: uint8) {.
    cdecl, importc: "GPU_ClearRGBA", dynlib: SDL2_GPU_LIB.}
  ##  Fills the given render target with a color.

proc blit*(image: Image; srcRect: ptr Rect; target: Target; x, y: cfloat) {.
    cdecl, importc: "GPU_Blit", dynlib: SDL2_GPU_LIB.}
  ##  Draws the given image to the given render target.
  ##
  ##  ``src_rect`` The region of the source image to use.
  ##  Pass `nil` for the entire image.
  ##
  ##  ``x`` Destination x-position.
  ##
  ##  ``y`` Destination y-position.

proc blitRotate*(image: Image; srcRect: ptr Rect; target: Target;
                 x: cfloat; y: cfloat; degrees: cfloat) {.
    cdecl, importc: "GPU_BlitRotate", dynlib: SDL2_GPU_LIB.}
  ##  Rotates and draws the given image to the given render target.
  ##
  ##  ``src_rect`` The region of the source image to use.
  ##  Pass `nil` for the entire image.
  ##
  ##  ``x`` Destination x-position.
  ##
  ##  ``y`` Destination y-position.
  ##
  ##  ``degrees`` Rotation angle (in degrees).

proc blitScale*(image: Image; srcRect: ptr Rect; target: Target;
                x: cfloat; y: cfloat; scaleX: cfloat; scaleY: cfloat) {.
    cdecl, importc: "GPU_BlitScale", dynlib: SDL2_GPU_LIB.}
  ##  Scales and draws the given image to the given render target.
  ##
  ##  ``src_rect`` The region of the source image to use.
  ##  Pass `nil` for the entire image.
  ##
  ##  ``x`` Destination x-position.
  ##
  ##  ``y`` Destination y-position.
  ##
  ##  ``scaleX`` Horizontal stretch factor.
  ##
  ##  ``scaleY`` Vertical stretch factor.

proc blitTransform*(image: Image; srcRect: ptr Rect; target: Target;
  x: cfloat; y: cfloat; degrees: cfloat; scaleX: cfloat; scaleY: cfloat) {.
    cdecl, importc: "GPU_BlitTransform", dynlib: SDL2_GPU_LIB.}
  ##  Scales, rotates, and draws the given image to the given render target.
  ##
  ##  ``src_rect`` The region of the source image to use.
  ##  Pass `nil` for the entire image.
  ##
  ##  ``x`` Destination x-position.
  ##
  ##  ``y`` Destination y-position.
  ##
  ##  ``degrees`` Rotation angle (in degrees).
  ##
  ##  ``scaleX`` Horizontal stretch factor.
  ##
  ##  ``scaleY`` Vertical stretch factor.

proc blitTransformX*(image: Image; srcRect: ptr Rect; target: Target;
  x: cfloat; y: cfloat; pivotX: cfloat; pivotY: cfloat; degrees: cfloat;
  scaleX: cfloat; scaleY: cfloat) {.
    cdecl, importc: "GPU_BlitTransformX", dynlib: SDL2_GPU_LIB.}
  ##  Scales, rotates around a pivot point,
  ##  and draws the given image to the given render target.
  ##  The drawing point (x, y) coincides with the pivot point
  ##  on the src image (pivot_x, pivot_y).
  ##
  ##  ``src_rect`` The region of the source image to use
  ##  Pass `nil` for the entire image.
  ##
  ##  ``x`` Destination x-position.
  ##
  ##  ``y`` Destination y-position.
  ##
  ##  ``pivot_x`` Pivot x-position (in image coordinates).
  ##
  ##  ``pivot_y`` Pivot y-position (in image coordinates).
  ##
  ##  ``degrees`` Rotation angle (in degrees).
  ##
  ##  ``scaleX`` Horizontal stretch factor.
  ##
  ##  ``scaleY`` Vertical stretch factor.

proc blitRect*(
  image: Image; srcRect: ptr Rect; target: Target; destRect: ptr Rect) {.
    cdecl, importc: "GPU_BlitRect", dynlib: SDL2_GPU_LIB.}
  ##  Draws the given image to the given render target,
  ##  scaling it to fit the destination region.
  ##
  ##  ``src_rect`` The region of the source image to use.
  ##  Pass `nil` for the entire image.
  ##
  ##  ``dest_rect`` The region of the destination target image to draw upon.
  ##  Pass `nil` for the entire target.

proc blitRectX*(image: Image; srcRect: ptr Rect; target: Target;
                destRect: ptr Rect; degrees: cfloat;
                pivotX: cfloat; pivotY: cfloat; flipDirection: Flip) {.
    cdecl, importc: "GPU_BlitRectX", dynlib: SDL2_GPU_LIB.}
  ##  Draws the given image to the given render target,
  ##  scaling it to fit the destination region.
  ##
  ##  ``src_rect`` The region of the source image to use.
  ##  Pass `nil` for the entire image.
  ##
  ##  ``dest_rect`` The region of the destination target image to draw upon.
  ##  Pass `nil` for the entire target.
  ##
  ##  ``degrees`` Rotation angle (in degrees).
  ##
  ##  ``pivot_x`` Pivot x-position (in image coordinates).
  ##
  ##  ``pivot_y`` Pivot y-position (in image coordinates).
  ##
  ##  ``flip_direction`` A ``Flip`` enum value (or bitwise OR'd combination)
  ##  that specifies which direction the image should be flipped.

proc triangleBatch*(image: Image; target: Target; numVertices: cushort;
                    values: ptr cfloat; numIndices: cuint; indices: ptr cushort;
                    flags: BatchFlags) {.
    cdecl, importc: "GPU_TriangleBatch", dynlib: SDL2_GPU_LIB.}
  ##  Renders triangles from the given set of vertices.
  ##  This lets you render arbitrary 2D geometry.
  ##  It is a direct path to the GPU, so the format is different than typical
  ##  SDL_gpu calls.
  ##
  ##  ``values`` A tightly-packed array of vertex position (e.g. x,y),
  ##  texture coordinates (e.g. s,t), and color (e.g. r,g,b,a) values.
  ##  Texture coordinates and color values are expected to be already
  ##  normalized to 0.0 - 1.0.
  ##  Pass `nil` to render with only custom shader attributes.
  ##
  ##  ``indices`` If not `nil`, this is used to specify which vertices to use
  ##  and in what order (i.e. it indexes the vertices in the ``values`` array).
  ##
  ##  ``flags`` Bit flags to control the interpretation
  ##  of the ``values`` array parameters.

proc triangleBatchX*(image: Image; target: Target; numVertices: cushort;
                    values: pointer; numIndices: cuint; indices: ptr cushort;
                    flags: BatchFlags) {.
    cdecl, importc: "GPU_TriangleBatchX", dynlib: SDL2_GPU_LIB.}
  ##  Renders triangles from the given set of vertices.
  ##  This lets you render arbitrary 2D geometry
  ##  It is a direct path to the GPU, so the format is different than typical
  ##  SDL_gpu calls.
  ##
  ##  ``values`` A tightly-packed array of vertex position (e.g. x,y),
  ##  texture coordinates (e.g. s,t), and color (e.g. r,g,b,a) values.
  ##  Texture coordinates and color values are expected to be already
  ##  normalized to 0.0 - 1.0 (or 0 - 255 for 8-bit color components).
  ##  Pass `nil` to render with only custom shader attributes.
  ##
  ##  ``indices`` If not `nil`, this is used to specify which vertices
  ##  to use and in what order
  ##  (i.e. it indexes the vertices in the ``values`` array).
  ##
  ##  ``flags`` Bit flags to control the interpretation
  ##  of the ``values`` array parameters.

proc flushBlitBuffer*() {.
    cdecl, importc: "GPU_FlushBlitBuffer", dynlib: SDL2_GPU_LIB.}
  ##  Send all buffered blitting data to the current context target.

proc flip*(target: Target) {.
    cdecl, importc: "GPU_Flip", dynlib: SDL2_GPU_LIB.}
  ##  Updates the given target's associated window.
  ##  For non-context targets (e.g. image targets),
  ##  this will flush the blit buffer.

# End of Rendering


# Shapes

proc pixel*(target: Target; x: cfloat; y: cfloat; color: Color) {.
    cdecl, importc: "GPU_Pixel", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored point.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of the point.
  ##
  ##  ``y`` y-coord of the point.
  ##
  ##  ``color`` The color of the shape to render.

proc line*(target: Target;
  x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat; color: Color) {.
    cdecl, importc: "GPU_Line", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored line.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of starting point.
  ##
  ##  ``y1`` y-coord of starting point.
  ##
  ##  ``x2`` x-coord of ending point.
  ##
  ##  ``y2`` y-coord of ending point.
  ##
  ##  ``color`` The color of the shape to render.

proc arc*(target: Target; x: cfloat; y: cfloat; radius: cfloat; startAngle: cfloat;
         endAngle: cfloat; color: Color) {.
    cdecl, importc: "GPU_Arc", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored arc curve (circle segment).
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``radius`` The radius of the circle / distance from the center point
  ##  that rendering will occur.
  ##
  ##  ``start_angle`` The angle to start from, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``end_angle`` The angle to end at, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``color`` The color of the shape to render.

proc arcFilled*(target: Target; x: cfloat; y: cfloat; radius: cfloat;
                startAngle: cfloat; endAngle: cfloat; color: Color) {.
    cdecl, importc: "GPU_ArcFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled arc (circle segment / pie piece).
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``radius`` The radius of the circle / distance from the center point
  ##  that rendering will occur.
  ##
  ##  ``start_angle`` The angle to start from, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``end_angle`` The angle to end at, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``color`` The color of the shape to render.

proc circle*(target: Target; x: cfloat; y: cfloat; radius: cfloat; color: Color) {.
    cdecl, importc: "GPU_Circle", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored circle outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``radius`` The radius of the circle / distance from the center point
  ##  that rendering will occur.
  ##
  ##  ``color`` The color of the shape to render.

proc circleFilled*(
  target: Target; x: cfloat; y: cfloat; radius: cfloat; color: Color) {.
    cdecl, importc: "GPU_CircleFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled circle.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``radius`` The radius of the circle / distance from the center point
  ##  that rendering will occur.
  ##
  ##  ``color`` The color of the shape to render.

proc ellipse*(target: Target; x: cfloat; y: cfloat; rx: cfloat; ry: cfloat;
              degrees: cfloat; color: Color) {.
    cdecl, importc: "GPU_Ellipse", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored ellipse outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``rx`` x-radius of ellipse.
  ##
  ##  ``ry`` y-radius of ellipse.
  ##
  ##  ``degrees`` The angle to rotate the ellipse.
  ##
  ##  ``color`` The color of the shape to render.

proc ellipseFilled*(target: Target; x: cfloat; y: cfloat;
                    rx: cfloat; ry: cfloat; degrees: cfloat; color: Color) {.
    cdecl, importc: "GPU_EllipseFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled ellipse.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``rx`` x-radius of ellipse.
  ##
  ##  ``ry`` y-radius of ellipse.
  ##
  ##  ``degrees`` The angle to rotate the ellipse.
  ##
  ##  ``color`` The color of the shape to render.

proc sector*(target: Target; x: cfloat; y: cfloat; innerRadius: cfloat;
  outerRadius: cfloat; startAngle: cfloat; endAngle: cfloat; color: Color) {.
    cdecl, importc: "GPU_Sector", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored annular sector outline (ring segment).
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``inner_radius`` The inner radius of the ring.
  ##
  ##  ``outer_radius`` The outer radius of the ring.
  ##
  ##  ``start_angle`` The angle to start from, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``end_angle`` The angle to end at, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``color`` The color of the shape to render.

proc sectorFilled*(target: Target; x: cfloat; y: cfloat; innerRadius: cfloat;
  outerRadius: cfloat; startAngle: cfloat; endAngle: cfloat; color: Color) {.
    cdecl, importc: "GPU_SectorFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled annular sector (ring segment).
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x`` x-coord of center point.
  ##
  ##  ``y`` y-coord of center point.
  ##
  ##  ``inner_radius`` The inner radius of the ring.
  ##
  ##  ``outer_radius`` The outer radius of the ring.
  ##
  ##  ``start_angle`` The angle to start from, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``end_angle`` The angle to end at, in degrees.
  ##  Measured clockwise from the positive x-axis.
  ##
  ##  ``color`` The color of the shape to render.

proc tri*(target: Target; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat;
          x3: cfloat; y3: cfloat; color: Color) {.
    cdecl, importc: "GPU_Tri", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored triangle outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of first point.
  ##
  ##  ``y1`` y-coord of first point.
  ##
  ##  ``x2`` x-coord of second point.
  ##
  ##  ``y2`` y-coord of second point.
  ##
  ##  ``x3`` x-coord of third point.
  ##
  ##  ``y3`` y-coord of third point.
  ##
  ##  ``color`` The color of the shape to render.

proc triFilled*(target: Target; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat;
                x3: cfloat; y3: cfloat; color: Color) {.
    cdecl, importc: "GPU_TriFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled triangle.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of first point.
  ##
  ##  ``y1`` y-coord of first point.
  ##
  ##  ``x2`` x-coord of second point.
  ##
  ##  ``y2`` y-coord of second point.
  ##
  ##  ``x3`` x-coord of third point.
  ##
  ##  ``y3`` y-coord of third point.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangle*(target: Target; x1: cfloat; y1: cfloat; x2: cfloat; y2: cfloat;
                color: Color) {.
    cdecl, importc: "GPU_Rectangle", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored rectangle outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of top-left corner.
  ##
  ##  ``y1`` y-coord of top-left corner.
  ##
  ##  ``x2`` x-coord of bottom-right corner.
  ##
  ##  ``y2`` y-coord of bottom-right corner.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangle2*(target: Target; rect: Rect; color: Color) {.
    cdecl, importc: "GPU_Rectangle2", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored rectangle outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``rect`` The rectangular area to draw.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangleFilled*(target: Target; x1: cfloat; y1: cfloat;
                      x2: cfloat; y2: cfloat; color: Color) {.
    cdecl, importc: "GPU_RectangleFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled rectangle.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of top-left corner.
  ##
  ##  ``y1`` y-coord of top-left corner.
  ##
  ##  ``x2`` x-coord of bottom-right corner.
  ##
  ##  ``y2`` y-coord of bottom-right corner.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangleFilled2*(target: Target; rect: Rect; color: Color) {.
    cdecl, importc: "GPU_RectangleFilled2", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled rectangle.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``rect`` The rectangular area to draw.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangleRound*(target: Target; x1: cfloat; y1: cfloat;
                     x2: cfloat; y2: cfloat; radius: cfloat; color: Color) {.
    cdecl, importc: "GPU_RectangleRound", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored rounded (filleted) rectangle outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of top-left corner.
  ##
  ##  ``y1`` y-coord of top-left corner.
  ##
  ##  ``x2`` x-coord of bottom-right corner.
  ##
  ##  ``y2`` y-coord of bottom-right corner.
  ##
  ##  ``radius`` The radius of the corners.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangleRound2*(
  target: Target; rect: Rect; radius: cfloat; color: Color) {.
    cdecl, importc: "GPU_RectangleRound2", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored rounded (filleted) rectangle outline.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``rect`` The rectangular area to draw.
  ##
  ##  ``radius`` The radius of the corners.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangleRoundFilled*(target: Target; x1: cfloat; y1: cfloat; x2: cfloat;
                           y2: cfloat; radius: cfloat; color: Color) {.
    cdecl, importc: "GPU_RectangleRoundFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled rounded (filleted) rectangle.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``x1`` x-coord of top-left corner.
  ##
  ##  ``y1`` y-coord of top-left corner.
  ##
  ##  ``x2`` x-coord of bottom-right corner.
  ##
  ##  ``y2`` y-coord of bottom-right corner.
  ##
  ##  ``radius`` The radius of the corners.
  ##
  ##  ``color`` The color of the shape to render.

proc rectangleRoundFilled2*(
  target: Target; rect: Rect; radius: cfloat; color: Color) {.
    cdecl, importc: "GPU_RectangleRoundFilled2", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled rounded (filleted) rectangle.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``rect`` The rectangular area to draw.
  ##
  ##  ``radius`` The radius of the corners.
  ##
  ##  ``color`` The color of the shape to render.

proc polygon*(
  target: Target; numVertices: cuint; vertices: ptr cfloat; color: Color) {.
    cdecl, importc: "GPU_Polygon", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored polygon outline.
  ##  The vertices are expected to define a convex polygon.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``num_vertices`` Number of vertices (x and y pairs).
  ##
  ##  ``vertices`` An array of vertex positions stored
  ##  as interlaced x and y coords, e.g. [x1, y1, x2, y2, ...]
  ##
  ##  ``color`` The color of the shape to render.

proc polyline*(target: Target; numVertices: cuint; vertices: ptr cfloat;
               color: Color; closeLoop: bool) {.
    cdecl, importc: "GPU_Polyline", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored sequence of line segments.
  ##
  ##  ``target`` The destination render target
  ##
  ##  ``num_vertices`` Number of vertices (x and y pairs)
  ##
  ##  ``vertices`` An array of vertex positions stored
  ##  as interlaced x and y coords, e.g. [x1, y1, x2, y2, ...]
  ##
  ##  ``color`` The color of the shape to render
  ##
  ##  ``close_loop`` Make a closed polygon by drawing a
  ##   line at the end back to the start point

proc polygonFilled*(target: Target; numVertices: cuint; vertices: ptr cfloat;
                   color: Color) {.
    cdecl, importc: "GPU_PolygonFilled", dynlib: SDL2_GPU_LIB.}
  ##  Renders a colored filled polygon.
  ##  The vertices are expected to define a convex polygon.
  ##
  ##  ``target`` The destination render target.
  ##
  ##  ``num_vertices`` Number of vertices (x and y pairs).
  ##
  ##  ``vertices`` An array of vertex positions stored
  ##  as interlaced x and y coords, e.g. [x1, y1, x2, y2, ...]
  ##
  ##  ``color`` The color of the shape to render.

# End of Shapes


# ShaderInterface

proc createShaderProgram*(): uint32 {.
    cdecl, importc: "GPU_CreateShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  Creates a new, empty shader program.
  ##  You will need to compile shaders, attach them to the program,
  ##  then link the program.
  ##
  ##  See also:
  ##
  ##  ``attachShader()``
  ##
  ##  ``linkShaderProgram()``

proc freeShaderProgram*(programObject: uint32) {.
    cdecl, importc: "GPU_FreeShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  Deletes a shader program.

proc compileShaderRW*(
  shaderType: ShaderType; shaderSource: ptr RWops; freeRwops: bool): uint32 {.
    cdecl, importc: "GPU_CompileShader_RW", dynlib: SDL2_GPU_LIB.}
  ##  Loads shader source from SDL's ``RWops``, compiles it,
  ##  and returns the new shader object.

proc compileShader*(shaderType: ShaderType; shaderSource: cstring): uint32 {.
    cdecl, importc: "GPU_CompileShader", dynlib: SDL2_GPU_LIB.}
  ##  Compiles shader source and returns the new shader object.

proc loadShader*(shaderType: ShaderType; filename: cstring): uint32 {.
    cdecl, importc: "GPU_LoadShader", dynlib: SDL2_GPU_LIB.}
  ##  Loads shader source from a file, compiles it,
  ##  and returns the new shader object.

proc linkShaders*(shaderObject1: uint32; shaderObject2: uint32): uint32 {.
    cdecl, importc: "GPU_LinkShaders", dynlib: SDL2_GPU_LIB.}
  ##  Creates and links a shader program with the given shader objects.

proc linkManyShaders*(shaderObjects: ptr uint32; count: cint): uint32 {.
    cdecl, importc: "GPU_LinkManyShaders", dynlib: SDL2_GPU_LIB.}
  ##  Creates and links a shader program with the given shader objects.

proc freeShader*(shaderObject: uint32) {.
    cdecl, importc: "GPU_FreeShader", dynlib: SDL2_GPU_LIB.}
  ##  Deletes a shader object.

proc attachShader*(programObject: uint32; shaderObject: uint32) {.
    cdecl, importc: "GPU_AttachShader", dynlib: SDL2_GPU_LIB.}
  ##  Attaches a shader object to a shader program for future linking.

proc detachShader*(programObject: uint32; shaderObject: uint32) {.
    cdecl, importc: "GPU_DetachShader", dynlib: SDL2_GPU_LIB.}
  ##  Detaches a shader object from a shader program.

proc linkShaderProgram*(programObject: uint32): bool {.
    cdecl, importc: "GPU_LinkShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  Links a shader program with any attached shader objects.

proc getCurrentShaderProgram*(): uint32 {.
    cdecl, importc: "GPU_GetCurrentShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the current shader program.

proc isDefaultShaderProgram*(programObject: uint32): bool {.
    cdecl, importc: "GPU_IsDefaultShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` `1` if the given shader program is a default shader
  ##  for the current context, `0` otherwise.

proc activateShaderProgram*(programObject: uint32; `block`: ptr ShaderBlock) {.
    cdecl, importc: "GPU_ActivateShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  Activates the given shader program.
  ##  Passing `nil` for ``block`` will disable the built-in shader variables
  ##  for custom shaders until a shaderBlock is set again.

proc deactivateShaderProgram*() {.
    cdecl, importc: "GPU_DeactivateShaderProgram", dynlib: SDL2_GPU_LIB.}
  ##  Deactivates the current shader program (activates program 0).

proc getShaderMessage*(): cstring {.
    cdecl, importc: "GPU_GetShaderMessage", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` the last shader log message.

proc getAttributeLocation*(programObject: uint32; attribName: cstring): cint {.
    cdecl, importc: "GPU_GetAttributeLocation", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` an integer representing the location
  ##  of the specified attribute shader variable.

proc makeAttributeFormat*(numElemsPerVertex: cint; `type`: AttributeType;
  normalize: bool; strideBytes: cint; offsetBytes: cint): AttributeFormat {.
    cdecl, importc: "GPU_MakeAttributeFormat", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` a filled attributeFormat object.

proc makeAttribute*(
  location: cint; values: pointer; format: AttributeFormat): Attribute {.
    cdecl, importc: "GPU_MakeAttribute", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` a filled attribute object.

proc getUniformLocation*(programObject: uint32; uniformName: cstring): cint {.
    cdecl, importc: "GPU_GetUniformLocation", dynlib: SDL2_GPU_LIB.}
  ##  ``Return`` an integer representing the location
  ##  of the specified uniform shader variable.

proc loadShaderBlock*(programObject: uint32; positionName: cstring;
                      texcoordName: cstring; colorName: cstring;
                      modelViewMatrixName: cstring): ShaderBlock {.
    cdecl, importc: "GPU_LoadShaderBlock", dynlib: SDL2_GPU_LIB.}
  ##  Loads the given shader program's built-in attribute and uniform locations.

proc setShaderBlock*(`block`: ShaderBlock) {.
    cdecl, importc: "GPU_SetShaderBlock", dynlib: SDL2_GPU_LIB.}
  ##  Sets the current shader block
  ##  to use the given attribute and uniform locations.

proc getShaderBlock*(): ShaderBlock {.
    cdecl, importc: "GPU_GetShaderBlock", dynlib: SDL2_GPU_LIB.}
  ##  Gets the shader block for the current shader.

proc setShaderImage*(image: Image; location: cint; imageUnit: cint) {.
    cdecl, importc: "GPU_SetShaderImage", dynlib: SDL2_GPU_LIB.}
  ##  Sets the given image unit to the given image so that a custom shader
  ##  can sample multiple textures.
  ##
  ##  ``image`` The source image/texture.
  ##  Pass `nil` to disable the image unit.
  ##
  ##  ``location`` The uniform location of a texture sampler.
  ##
  ##  ``image_unit`` The index of the texture unit to set.
  ##  `0` is the first unit, which is used by SDL_gpu's blitting functions.
  ##  `1` would be the second unit.

proc getUniformiv*(programObject: uint32; location: cint; values: ptr cint) {.
    cdecl, importc: "GPU_GetUniformiv", dynlib: SDL2_GPU_LIB.}
  ##  Fills ``values`` with the value of the uniform shader variable
  ##  at the given location.

proc setUniformi*(location: cint; value: cint) {.
    cdecl, importc: "GPU_SetUniformi", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the integer uniform shader variable
  ##  at the given location. This is equivalent to calling
  ##  setUniformiv(location, 1, 1, addr(value)).

proc setUniformiv*(location: cint; numElementsPerValue: cint;
                   numValues: cint; values: ptr cint) {.
    cdecl, importc: "GPU_SetUniformiv", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the integer uniform shader variable
  ##  at the given location.

proc getUniformuiv*(programObject: uint32; location: cint; values: ptr cuint) {.
    cdecl, importc: "GPU_GetUniformuiv", dynlib: SDL2_GPU_LIB.}
  ##  Fills ``values`` with the value of the uniform shader variable
  ##  at the given location.

proc setUniformui*(location: cint; value: cuint) {.
    cdecl, importc: "GPU_SetUniformui", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the unsigned integer uniform shader variable
  ##  at the given location. This is equivalent to calling
  ##  setUniformuiv(location, 1, 1, addr(value)).

proc setUniformuiv*(location: cint; numElementsPerValue: cint;
                    numValues: cint; values: ptr cuint) {.
    cdecl, importc: "GPU_SetUniformuiv", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the unsigned integer uniform shader variable
  ##  at the given location.

proc getUniformfv*(programObject: uint32; location: cint; values: ptr cfloat) {.
    cdecl, importc: "GPU_GetUniformfv", dynlib: SDL2_GPU_LIB.}
  ##  Fills ``values`` with the value of the uniform shader variable
  ##  at the given location.

proc setUniformf*(location: cint; value: cfloat) {.
    cdecl, importc: "GPU_SetUniformf", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the floating point uniform shader variable
  ##  at the given location. This is equivalent to calling
  ##  setUniformfv(location, 1, 1, addr(value)).

proc setUniformfv*(location: cint; numElementsPerValue: cint;
                   numValues: cint; values: ptr cfloat) {.
    cdecl, importc: "GPU_SetUniformfv", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the floating point uniform shader variable
  ##  at the given location.

proc getUniformMatrixfv*(programObject: uint32; location: cint; values: ptr cfloat) {.
    cdecl, importc: "GPU_GetUniformMatrixfv", dynlib: SDL2_GPU_LIB.}
  ##  Fills ``values`` with the value of the uniform shader variable
  ##  at the given location. The results are identical to calling
  ##  ``getUniformfv()``.  Matrices are gotten in column-major order.

proc setUniformMatrixfv*(
  location: cint; numMatrices: cint; numRows: cint; numColumns: cint;
  transpose: bool; values: ptr cfloat) {.
    cdecl, importc: "GPU_SetUniformMatrixfv", dynlib: SDL2_GPU_LIB.}
  ##  Sets the value of the matrix uniform shader variable
  ##  at the given location.
  ##
  ##  The size of the matrices sent is specified
  ##  by ``num_rows`` and ``num_columns``.
  ##  Rows and columns must be between `2` and `4`.

proc setAttributef*(location: cint; value: cfloat) {.
    cdecl, importc: "GPU_SetAttributef", dynlib: SDL2_GPU_LIB.}
  ##  Sets a constant-value shader attribute
  ##  that will be used for each rendered vertex.

proc setAttributei*(location: cint; value: cint) {.
    cdecl, importc: "GPU_SetAttributei", dynlib: SDL2_GPU_LIB.}
  ##  Sets a constant-value shader attribute
  ##  that will be used for each rendered vertex.

proc setAttributeui*(location: cint; value: cuint) {.
    cdecl, importc: "GPU_SetAttributeui", dynlib: SDL2_GPU_LIB.}
  ##  Sets a constant-value shader attribute
  ##  that will be used for each rendered vertex.

proc setAttributefv*(location: cint; numElements: cint; value: ptr cfloat) {.
    cdecl, importc: "GPU_SetAttributefv", dynlib: SDL2_GPU_LIB.}
  ##  Sets a constant-value shader attribute
  ##  that will be used for each rendered vertex.

proc setAttributeiv*(location: cint; numElements: cint; value: ptr cint) {.
    cdecl, importc: "GPU_SetAttributeiv", dynlib: SDL2_GPU_LIB.}
  ##  Sets a constant-value shader attribute
  ##  that will be used for each rendered vertex.

proc setAttributeuiv*(location: cint; numElements: cint; value: ptr cuint) {.
    cdecl, importc: "GPU_SetAttributeuiv", dynlib: SDL2_GPU_LIB.}
  ##  Sets a constant-value shader attribute
  ##  that will be used for each rendered vertex.

proc setAttributeSource*(numValues: cint; source: Attribute) {.
    cdecl, importc: "GPU_SetAttributeSource", dynlib: SDL2_GPU_LIB.}
  ##  Enables a shader attribute and sets its source data.

# End of ShaderInterface
