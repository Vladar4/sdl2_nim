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

##  syswm.nim
##  =========
##
##  Include file for SDL custom system window manager hooks.
##
##  Your application has access to a special type of event ``SYSWMEVENT``,
##  which contains window-manager specific information and arrives whenever
##  an unhandled window event occurs.  This event is ignored by default, but
##  you can enable it with ``eventState()``.

{.deadCodeElim: on.}

import
  sdl

when defined(SDL_PROTOTYPES_ONLY):
  type
    SysWMinfo* = object

else:

  when defined(SDL_VIDEO_DRIVER_WINDOWS):
    import winim/lean  ##  winim lib
  elif defined(SDL_VIDEO_DRIVER_X11):
    import x11/[x, xlib]  ##  x11 lib
  elif defined(SDL_VIDEO_DRIVER_DIRECTFB):
    nil
  elif defined(SDL_VIDEO_DRIVER_COCOA):
    nil
  elif defined(SDL_VIDEO_DRIVER_UIKIT):
    nil
  elif defined(SDL_VIDEO_DRIVER_WAYLAND):
    nil
  elif defined(SDL_VIDEO_DRIVER_MIR):
    nil
  elif defined(SDL_VIDEO_DRIVER_WINRT):
    nil
  elif defined(SDL_VIDEO_DRIVER_ANDROID):
    nil

  type
    SysWMKind* {.size: sizeof(cint).} = enum  ##  \
        ##  These are the various supported windowing subsystems
      SYSWM_UNKNOWN,
      SYSWM_WINDOWS,
      SYSWM_X11,
      SYSWM_DIRECTFB,
      SYSWM_COCOA,
      SYSWM_UIKIT,
      SYSWM_WAYLAND,
      SYSWM_MIR,
      SYSWM_WINRT,
      SYSWM_ANDROID,
      SYSWM_VIVANTE,
      SYSWM_OS2,
      SYSWM_HAIKU

  when defined(SDL_VIDEO_DRIVER_UIKIT):
    type GLuint* = uint32

  # SysWMMsg

  #type
  #  SysWMMsgKindObj* = object {.union.}
  #    win*: SysWMMsgWinObj # when defined(SDL_VIDEO_DRIVER_WINDOWS)
  #    x11*: SysWMMsgX11Obj # when defined(SDL_VIDEO_DRIVER_X11)
  #    dfb*: SysWMMsgDFBObj # when defined(SDL_VIDEO_DRIVER_DIRECTFB)
  #    cocoa*: SysWMMsgCocoaObj # when defined(SDL_VIDEO_DRIVER_COCOA)
  #    uikit*: SysWMMsgUIKitObj # when defined(SDL_VIDEO_DRIVER_UIKIT)
  #    dummy*: cint  # Can't have an empty union

  when defined(SDL_VIDEO_DRIVER_WINDOWS):
    type
      SysWMMsgWinObj* = object  ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
        hwnd*: HWND     ##  The window for the message
        msg*: UINT   ##  The type of message
        wParam*: WPARAM ##  WORD message parameter
        lParam*: LPARAM ##  LONG message parameter

      SysWMMsgKindObj* = object ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
        win*: SysWMMsgWinObj

  elif defined(SDL_VIDEO_DRIVER_X11):
    type
      SysWMMsgX11Obj* = object  ##  when defined(SDL_VIDEO_DRIVER_X11)
        event*: XEvent

      SysWMMsgKindObj* = object ##  when defined(SDL_VIDEO_DRIVER_X11)
        x11*: SysWMMsgX11Obj

  elif defined(SDL_VIDEO_DRIVER_DIRECTFB):
    type
      SysWMMsgDFBObj* = object
        event*: DFBEvent

      SysWMMsgKindObj* = object
        dfb*: SysWMMsgDFBObj

  elif defined(SDL_VIDEO_DRIVER_COCOA):
    type
      SysWMMsgCocoaObj* = object
        dummy*: cint
          ##  Latest version of Xcode clang
          ##  complains about empty structs in C v. C++:
          ##
          ##  error: empty struct has size 0 in C, size 1 in C++
          ##
          ##  No Cocoa window events yet

      SysWMMsgKindObj* = object
        cocoa*: SysWMMsgCocoaObj

  elif defined(SDL_VIDEO_DRIVER_UIKIT):
    type
      SysWMMsgUIKitObj* = object
        dummy*: cint  ##  No UIKit window events yet

      SysWMMsgKindObj* = object
        uikit*: SysWMMsgUIKitObj

  elif defined(SDL_VIDEO_DRIVER_VIVANTE):
    type
      SysWMMsgVivanteObj* = object
        dummy*: cint  ##  No Vivante window events yet

      SysWMMsgKindObj* = object
        vivante*: SysWMMsgVivanteObj

  elif defined(SDL_VIDEO_DRIVER_OS2):
    type
      SysWMMsgOS2Obj * = object
        fFrame*: bool ##  `true` if hwnd is a frame window
        hwnd*: HWND   ##  The window receiving the message
        msg*: ULONG   ##  The message identifier
        mp1*: MPARAM  ##  The first first message parameter
        mp2*: MPARAM  ##  The second first message parameter

      SysWMMsgKindObj* = object
        os2*: SysWMMsgOS2Obj

  else:
    type SysWMMsgKindObj* = object
      dummy*: cint

  type
    SysWMMsg* = ptr SysWMMsgObj
    SysWMMsgObj* = object  ##  The custom event structure.
      version*: Version
      subsystem*: SysWMKind
      msg*: SysWMMsgKindObj


# SysWMinfo

  #type
  #  SysWMinfoKindObj* = object {.union.}
  #    win*: SysWMinfoWinObj ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
  #    winrt*: SysWMinfoWinRTObj ##  when defined(SDL_VIDEO_DRIVER_WINRT)
  #    x11*: SysWMinfoX11Obj ##  when defined(SDL_VIDEO_DRIVER_X11)
  #    dfb*: SysWMinfoDFBObj ##  when defined(SDL_VIDEO_DRIVER_DIRECTFB)
  #    cocoa*: SysWMinfoCocoaObj ##  when defined(SDL_VIDEO_DRIVER_COCOA)
  #    uikit*: SysWMinfoUIKitObj ##  when defined(SDL_VIDEO_DRIVER_UIKIT)
  #    wl*: SysWMinfoWLObj ##  when defined(SDL_VIDEO_DRIVER_WAYLAND)
  #    mir*: SysWMinfoMirObj ##  when defined(SDL_VIDEO_DRIVER_MIR)
  #    android*: SysWMinfoAndroidObj ##  when defined(SDL_VIDEO_DRIVER_ANDROID)
  #    dummy*: array[64, uint8]
  #      ##  Make sure this union is always 64 bytes (8 64-bit pointers).
  #      ##  Be careful not to overflow this if you add a new target!


  when defined(SDL_VIDEO_DRIVER_WINDOWS):
    when not declared(HINSTANCE):
      when declared(HINST):
        type HINSTANCE = HINST
      else:
        type HINSTANCE = HANDLE
    type
      SysWMinfoWinObj* = object ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
        window*: HWND         ##  The window handle
        hdc*: HDC             ##  The window device context
        hinstance*: HINSTANCE ##  The instance handle

      SysWMinfoKindObj* = object  ##  when defined(SDL_VIDEO_DRIVER_WINDOWS)
        win*: SysWMinfoWinObj


  elif defined(SDL_VIDEO_DRIVER_WINRT):
    type
      SysWMinfoWinRTObj* = object
        window*: ptr IInspectable ##  The WinRT CoreWindow

      SysWMinfoKindObj* = object
        winrt*: SysWMinfoWinRTObj

  elif defined(SDL_VIDEO_DRIVER_X11):
    type
      SysWMinfoX11Obj* = object   ##  when defined(SDL_VIDEO_DRIVER_X11)
        display*: ptr xlib.XDisplay  ##  The X11 display
        window*: x.Window            ##  The X11 window

      SysWMinfoKindObj* = object  ##  when defined(SDL_VIDEO_DRIVER_X11)
        x11*: SysWMinfoX11Obj

  elif defined(SDL_VIDEO_DRIVER_DIRECTFB):
    type
      SysWMinfoDFBObj* = object
        dfb*: ptr IDirectFB             ##  The directfb main interface
        window*: ptr IDirectFBWindow    ##  The directfb window handle
        surface*: ptr IDirectFBSurface  ##  The directfb client surface

      SysWMinfoKindObj* = object
        dfb*: SysWMinfoDFBObj

  elif defined(SDL_VIDEO_DRIVER_COCOA):
    type
      SysWMinfoCocoaObj* = object
        window*: pointer  ##  The Cocoa window

      SysWMinfoKindObj* = object
        cocoa*: SysWMinfoCocoaObj

  elif defined(SDL_VIDEO_DRIVER_UIKIT):
    type
      SysWMinfoUIKitObj* = object
        window*: ptr UIWindow       ##  The UIKit window
        framebuffer*: GLuint
          ##  The GL view's Framebuffer Object.
          ##  It must be bound when rendering to the screen using GL.
        colorbuffer*: GLuint
          ##  The GL view's color Renderbuffer Object.
          ##  It must be bound when SDL_GL_SwapWindow is called.
        resolveFramebuffer*: GLuint
          ##  The Framebuffer Object which holds the resolve color Renderbuffer,
          ##  when MSAA is used.

      SysWMinfoKindObj* = object
        uikit*: SysWMinfoUIKitObj

  elif defined(SDL_VIDEO_DRIVER_WAYLAND):
    type
      SysWMinfoWLObj* = object
        display*: ptr WlDisplay ##  Wayland display
        surface*: ptr WlSurface ##  Wayland surface
        shellSurface*: ptr WlShellSurface
          ##  Wayland shell_surface (window manager handle)

      SysWMinfoKindObj* = object
        wl*: SysWMinfoWLObj

  elif defined(SDL_VIDEO_DRIVER_MIR):
    type
      SysWMinfoMirObj* = object
        connection*: pointer  ##  Mir display server connection
        surface*: pointer     ##  Mir surface

      SysWMinfoKindObj* = object
        mir*: SysWMinfoMirObj

  elif defined(SDL_VIDEO_DRIVER_ANDROID):
    type
      SysWMinfoAndroidObj* = object
       window*: ptr ANativeWindow
       surface*: EGLSurface

      SysWMinfoKindObj* = object
        android*: SysWMinfoAndroidObj

  elif defined(SDL_VIDEO_DRIVER_VIVANTE):
    type
      SysWMinfoVivanteObj* = object
        display*: EGLNativeDisplayType
        window*: EGLNativeWindowType

      SysWMinfoKindObj* = object
        vivante*: SysWMinfoVivanteObj

  elif defined(SDL_VIDEO_DRIVER_OS2):
    type
      SysWMinfoOS2Obj* = object
        hwnd*: HWND       ##  The window handle
        hwndFrame*: HWND  ##  The frame window handle

      SysWMinfoKindObj* = object
        os2*: SysWMinfoOS2Obj

  else:
    type
      SysWMinfoKindObj* = object
        dummy*: array[64, uint8]
          ##  Make sure this union is always 64 bytes (8 64-bit pointers).
          ##  Be careful not to overflow this if you add a new target!

  type
    SysWMinfo* = object ##  \
      ##  The custom window manager information structure.
      ##
      ##  When this structure is returned, it holds information about which
      ##  low level system it is using, and will be one of ``SysWMKind``.
      version*: Version
      subsystem*: SysWMKind
      info*: SysWMinfoKindObj


# Procedure prototypes


proc getWindowWMInfo*(window: sdl.Window; info: ptr SysWMinfo): bool {.
    cdecl, importc: "SDL_GetWindowWMInfo", dynlib: SDL2_LIB.}
  ##  This procedure allows access to driver-dependent window information.
  ##
  ##  ``window`` The window about which information is being requested
  ##
  ##  ``info`` This object must be initialized with the SDL version, and is
  ##  then filled in with information about the given window.
  ##
  ##  ``Return`` ``true`` if the procedure is implemented and the version
  ##  member of the ``info`` object is valid, ``false`` otherwise.
  ##
  ##  You typically use this procedure like this:
  ##
  ##  .. code-block:: nim
  ##    var info: SysWMinfo
  ##    version(info.version);
  ##    if getWindowWMInfo(window, addr(info))"
  ##      ...
  ##
