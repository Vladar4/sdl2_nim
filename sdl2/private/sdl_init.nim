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

##  sdl_init.nim
##  ============
##
##  Header file for initialization and shutdown procedures.

##  Simple DirectMedia Layer is a cross-platform development library designed
##  to provide low level access to audio, keyboard, mouse, joystick, and
##  graphics hardware via OpenGL and Direct3D. It is used by video playback
##  software, emulators, and popular games including Valve's award winning
##  catalog and many Humble Bundle games.
##
##  SDL officially supports Windows, Mac OS X, Linux, iOS, and Android.
##  Support for other platforms may be found in the source code.
##
##  SDL is written in C, works natively with C++, and there are bindings
##  available for several other languages, including C# and Python.
##
##  This library is distributed under the zlib license, which can be found
##  in the file "SDL-COPYING.txt".
##
##  The best way to learn how to use SDL is to check out the header files in
##  the "include" subdirectory and the programs in the "test" subdirectory.
##  The header files and test programs are well commented and always up to date.
##  More documentation and FAQs are available online at:
##  http://wiki.libsdl.org
##
##  If you need help with the library, or just want to discuss SDL related
##  issues, you can join the developers mailing list:
##  http://www.libsdl.org/mailing-list.php
##
##  Enjoy!
##
##  Sam Lantinga                (slouken@libsdl.org)

#   INIT_*
#
#  These are the flags which may be passed to SDL_Init().  You should
#  specify the subsystems which you will be using in your application.
const
  INIT_TIMER* = 0x00000001
  INIT_AUDIO* = 0x00000010
  INIT_VIDEO* = 0x00000020  # implies INIT_EVENTS
  INIT_JOYSTICK* = 0x00000200 # implies INIT_EVENTS
  INIT_HAPTIC* = 0x00001000
  INIT_GAMECONTROLLER* = 0x00002000 # implies INIT_JOYSTICK
  INIT_EVENTS* = 0x00004000
  INIT_NOPARACHUTE* = 0x00100000 # compatibility; this flag is ignored
  INIT_EVERYTHING* = (INIT_TIMER or INIT_AUDIO or INIT_VIDEO or INIT_EVENTS or
      INIT_JOYSTICK or INIT_HAPTIC or INIT_GAMECONTROLLER)

proc init*(flags: uint32): cint {.
    cdecl, importc: "SDL_Init", dynlib: SDL2_LIB.}
  ##  This procedure initializes the subsystems specified by ``flags``
  ##  Unless the `INIT_NOPARACHUTE` flag is set, it will install cleanup
  ##  signal handlers for some commonly ignored fatal signals (like SIGSEGV).
  ##
  ##  ``Return`` `0` on success or a negative error code on failure.

proc initSubSystem*(flags: uint32): cint {.
    cdecl, importc: "SDL_InitSubSystem", dynlib: SDL2_LIB.}
  ##  This procedure initializes specific SDL subsystems.
  ##
  ##  Subsystem initialization is ref-counted, you must call
  ##  ``sdl.quitSubSystem()`` for each ``sdl.initSubSystem()`` to correctly
  ##  shutdown a subsystem manually (or call ``sdl.quit()`` to force shutdown).
  ##
  ##  If a subsystem is already loaded then this call
  ##  will increase the ref-count and return.

proc quitSubSystem*(flags: uint32) {.
    cdecl, importc: "SDL_QuitSubSystem", dynlib: SDL2_LIB.}
  ##  This procedure cleans up specific SDL subsystems.

proc wasInit*(flags: uint32): uint32 {.
    cdecl, importc: "SDL_WasInit", dynlib: SDL2_LIB.}
  ##  This procedure returns a mask of the specified subsystems which have
  ##  previously been initialized.
  ##
  ##  If ``flags`` is `0`, it returns a mask of all initialized subsystems.

proc quit*() {.
    cdecl, importc: "SDL_Quit", dynlib: SDL2_LIB.}
  ##  This procedure cleans up all initialized subsystems. You should
  ##  call it upon all exit conditions.
