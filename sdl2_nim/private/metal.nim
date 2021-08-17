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
##  Header file for procedures to creating Metal layers and views
##  on SDL windows.

type
  MetalView* = pointer  ##  \
    ##  A handle to a CAMetalLayer-backed NSView (macOS) or UIView (iOS/tvOS).
    ##
    ##  ``Note:`` This can be cast directly to an NSView or UIView.


# Metal support procedures

proc metalCreateView*(window: Window): MetalView {.
    cdecl, importc: "SDL_Metal_CreateView", dynlib: SDL2_LIB.}
  ##  Create a CAMetalLayer-backed NSView/UIView
  ##  and attach it to the specified window.
  ##
  ##  On macOS, this does ``not`` associate a MTLDevice with the CAMetalLayer
  ##  on its own. It is up to user code to do that.
  ##
  ##  The returned handle can be casted directly to a NSView or UIView.
  ##  To access the backing CAMetalLayer, call ``sdl.metalGetLayer()``.
  ##
  ##  ``Note:`` ``window`` must be created with the `sdl.WINDOW_METAL` flag.
  ##
  ##  See also:
  ##
  ##  ``metalDestroyView()``
  ##
  ##  ``metalGetLayer()``

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

proc metalGetLayer*(view: MetalView): pointer {.
    cdecl, importc: "SDL_Metal_GetLayer", dynlib: SDL2_LIB.}
  ##  Get a pointer to the backing CAMetalLayer for the given view.
  ##
  ##  See also:
  ##
  ##  ``metalCreateView()``

proc metalGetDrawableSize*(window: Window; w, h: ptr cint) {.
    cdecl, importc: "SDL_Metal_GetDrawableSize", dynlib: SDL2_LIB.}
  ##  Get the size of a window's underlying drawable in pixels (for use
  ##  with setting viewport, scissor & etc).
  ##
  ##  ``window``  ``sdl.Window`` from which the drawable size should be queried
  ##
  ##  ``w`` Pointer to variable for storing the width in pixels, may be `nil`
  ##
  ##  ``h``  Pointer to variable for storing the height in pixels, may be `nil`
  ##
  ##  This may differ from ``sdl.getWindowSize()`` if we're rendering
  ##  to a high-DPI drawable, i.e. the window was created with
  ##  `sdl.WINDOW_ALLOW_HIGHDPI` on a platform with high-DPI support
  ##  (Apple calls this "Retina"), and not disabled by the
  ##  `sdl.HINT_VIDEO_HIGHDPI_DISABLED` hint.
  ##
  ##  ``Note:`` On macOS high-DPI support must be enabled for an application by
  ##  setting NSHighResolutionCapable to true in its Info.plist.
  ##
  ##  See also:
  ##
  ##  ``getWindowSize()``
  ##
  ##  ``createWindow()``

