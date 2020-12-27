#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>
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

##  blendmode.nim
##  =============
##
##  Header file declaring the BlendMode enumeration.

type
  BlendMode* {.size: sizeof(cint).} = enum ##  \
    ##  The blend mode used in renderCopy() and drawing operations.
    ##
    ##  Additional custom blend modes
    ##  can be returned by ``composeCustomBlendMode()``.
    BLENDMODE_NONE = 0x00000000,
      ##  no blending
      ##  dstRGBA = srcRGBA
    BLENDMODE_BLEND = 0x00000001,
      ##  alpha blending
      ##  dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
      ##  dstA = srcA + (dstA * (1-srcA))
    BLENDMODE_ADD = 0x00000002,
      ##  additive blending
      ##  dstRGB = (srcRGB * srcA) + dstRGB
      ##  dstA = dstA
    BLENDMODE_MOD = 0x00000004,
      ##  color modulate
      ##  dstRGB = srcRGB * dstRGB
      ##  dstA = dstA
    BLENDMODE_MUL = 0x00000008,
      ##  color multiply
      ##  dstRGB = (srcRGB * dstRGB) + (dstRGB * (1-srcA))
      ##  dstA = (srcA * dstA) + (dstA * (1-srcA))
    BLENDMODE_INVALID = 0x7FFFFFFF

  BlendOperation* {.size: sizeof(cint).} = enum ##  \
    ##  The blend operation used when combining
    ##  source and destination pixel components.
    BLENDOPERATION_ADD          = 0x1,
      ##  dst + src : supported by all renderers
    BLENDOPERATION_SUBTRACT     = 0x2,
      ##  dst - src : supported by D3D9, D3D11, OpenGL, OpenGLES
    BLENDOPERATION_REV_SUBTRACT = 0x3,
      ##  src - dst : supported by D3D9, D3D11, OpenGL, OpenGLES
    BLENDOPERATION_MINIMUM      = 0x4,
      ##  min(dst, src) : supported by D3D11
    BLENDOPERATION_MAXIMUM      = 0x5
      ##  max(dst, src) : supported by D3D11

  BlendFactor* {.size: sizeof(cint).} = enum  ##  \
    ##  The normalized factor used to multiply pixel components.
    BLENDFACTOR_ZERO                = 0x1,  ##  0, 0, 0, 0
    BLENDFACTOR_ONE                 = 0x2,  ##  1, 1, 1, 1
    BLENDFACTOR_SRC_COLOR           = 0x3,  ##  srcR, srcG, srcB, srcA
    BLENDFACTOR_ONE_MINUS_SRC_COLOR = 0x4,  ##  1-srcR, 1-srcG, 1-srcB, 1-srcA
    BLENDFACTOR_SRC_ALPHA           = 0x5,  ##  srcA, srcA, srcA, srcA
    BLENDFACTOR_ONE_MINUS_SRC_ALPHA = 0x6,  ##  1-srcA, 1-srcA, 1-srcA, 1-srcA
    BLENDFACTOR_DST_COLOR           = 0x7,  ##  dstR, dstG, dstB, dstA
    BLENDFACTOR_ONE_MINUS_DST_COLOR = 0x8,  ##  1-dstR, 1-dstG, 1-dstB, 1-dstA
    BLENDFACTOR_DST_ALPHA           = 0x9,  ##  dstA, dstA, dstA, dstA
    BLENDFACTOR_ONE_MINUS_DST_ALPHA = 0xA   ##  1-dstA, 1-dstA, 1-dstA, 1-dstA

proc composeCustomBlendMode*(
    srcColorFactor: BlendFactor,
    dstColorFactor: BlendFactor,
    colorOperation: BlendOperation,
    srcAlphaFactor: BlendFactor,
    dstAlphaFactor: BlendFactor,
    alphaOperation: BlendOperation): BlendMode {.
    cdecl, importc: "SDL_ComposeCustomBlendMode", dynlib: SDL2_LIB.}
  ##  Create a custom blend mode,
  ##  which may or may not be supported by a given renderer.
  ##
  ##  ``srcColorFactor`` source color factor
  ##
  ##  ``dstColorFactor`` destination color factor
  ##
  ##  ``colorOperation`` color operation
  ##
  ##  ``srcAlphaFactor`` source alpha factor
  ##
  ##  ``dstAlphaFactor`` destination alpha factor
  ##
  ##  ``alphaOperation`` alpha operation
  ##
  ##  The result of the blend mode operation will be:
  ##
  ##  dstRGB = dstRGB * dstColorFactor colorOperation srcRGB * srcColorFactor
  ##
  ##  and
  ##
  ##  dstA = dstA * dstAlphaFactor alphaOperation srcA * srcAlphaFactor

