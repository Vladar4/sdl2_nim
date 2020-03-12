#
# Simple DirectMedia Layer
# Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>
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

##  metal.nim
##  =========
##
##  Header file for functions to creating Metal layers and views on SDL windows.

type
  MetalView* = pointer  ##  \
    ##  A handle to a CAMetalLayer-backed NSView (macOS) or UIView (iOS/tvOS).
    ##
    ##  ``Note:`` This can be cast directly to an NSView or UIView.

# Metal support functions


proc metalCreateView*(window: Window): MetalView {.
    cdecl, importc: "SDL_Metal_CreateView", dynlib: SDL2_LIB.}
  ##  Create a CAMetalLayer-backed NSView/UIView
  ##  and attach it to the specified window.
  ##
  ##  On macOS, this does ``not`` associate a MTLDevice with the CAMetalLayer
  ##  on its own. It is up to user code to do that.
  ##
  ##  The returned handle can be casted directly to a NSView or UIView, and the
  ##  CAMetalLayer can be accessed from the view's ``layer`` property.
  ##
  ##  .. code-block:: nim
  ##    var
  ##      metalview: MetalView = metalCreateView(window)
  ##      uiview: UIView = UIView(metalview)
  ##      metallayer: CAMetalLayer = CAMetalLayer(uiview.layer)
  ##    # [...]
  ##    metalDestroyView(metalview)
  ##
  ##  See also:
  ##
  ##  ``metalDestroyView()``
  ##

proc metalDestroyView*(view: MetalView) {.
    cdecl, importc: "SDL_Metal_DestroyView", dynlib: SDL2_LIB.}
  ##  Destroy an existing ``MetalView`` object.
  ##
  ##  This should be called before ``destroyWindow()``,
  ##  if ``metalCreateView()`` was called after ``createWindow()``.
  ##
  ##  See also:
  ##
  ##  ``metalCreateView()``
