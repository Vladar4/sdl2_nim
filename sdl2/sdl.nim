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
# Main include header for the SDL library
#

#
# Simple DirectMedia Layer (SDL)
#
# http://www.libsdl.org/
#
# Introduction
#
# This is the Simple DirectMedia Layer, a general API that provides low
# level access to audio, keyboard, mouse, joystick, 3D hardware via OpenGL,
# and 2D framebuffer across multiple platforms.
#
# SDL is written in C, but works with C++ natively, and has bindings to
# several other languages, including Ada, C#, Eiffel, Erlang, Euphoria,
# Guile, Haskell, Java, Lisp, Lua, ML, Objective C, Pascal, Perl, PHP,
# Pike, Pliant, Python, Ruby, and Smalltalk.
#
# This library is distributed under the zlib license, which can be
# found in the file  "COPYING".  This license allows you to use SDL
# freely for any purpose as long as you retain the copyright notice.
#
# The best way to learn how to use SDL is to check out the header files in
# the "include" subdirectory and the programs in the "test" subdirectory.
# The header files and test programs are well commented and always up to date.
# More documentation and FAQs are available online at:
#   http://wiki.libsdl.org/
#
# If you need help with the library, or just want to discuss SDL related
# issues, you can join the developers mailing list:
#   http://www.libsdl.org/mailing-list.php
#
# Enjoy!
#   Sam Lantinga                (slouken@libsdl.org)
#

import unsigned


include
  sdl_libname,
  stdinc,
  blendmode,
  clipboard,
  error,
  loadso,
  hints,
  pixels,
  rect,
  rwops,
  surface,
  video,
  render,
  shape,
  messagebox,
  timer,
  power,
  scancode,
  keycode,
  keyboard,
  mouse,
  joystick,
  gamecontroller,
  haptic,
  touch,
  gesture,
  events,
  mutex,
  thread,
  audio,
  log,
  cpuinfo,
  version,
  revision


# As of version 0.5, SDL is loaded dynamically into the application

# These are the flags which may be passed to SDL_Init().  You should
# specify the subsystems which you will be using in your application.

const
  INIT_TIMER* = 0x00000001
  INIT_AUDIO* = 0x00000010
  INIT_VIDEO* = 0x00000020
  INIT_JOYSTICK* = 0x00000200
  INIT_HAPTIC* = 0x00001000
  INIT_GAMECONTROLLER* = 0x00002000 ## turn on game controller also implicitly does JOYSTICK
  INIT_NOPARACHUTE* = 0x00100000 ## Don't catch fatal signals
  INIT_EVERYTHING* = INIT_TIMER or INIT_AUDIO or INIT_VIDEO or
    INIT_JOYSTICK or INIT_HAPTIC or INIT_GAMECONTROLLER


proc init*(flags: Uint32): int {.cdecl, importc: "SDL_Init", dynlib: LibName.}
  ## This function initializes  the subsystems specified by ``flags``
  ## Unless the ``INIT_NOPARACHUTE`` flag is set, it will install cleanup
  ## signal handlers for some commonly ignored fatal signals (like SIGSEGV).


proc initSubSystem*(flags: Uint32): int {.cdecl, importc: "SDL_InitSubSystem", dynlib: LibName.}
  ## This function initializes specific SDL subsystems


proc quitSubSystem*(flags: Uint32) {.cdecl, importc: "SDL_QuitSubSystem", dynlib: LibName.}
  ## This function cleans up specific SDL subsystems


proc wasInit*(flags: Uint32): Uint32 {.cdecl, importc: "SDL_WasInit", dynlib: LibName.}
  ## This function returns a mask of the specified subsystems which have
  ## previously been initialized.
  ##
  ## If ``flags`` is 0, it returns a mask of all initialized subsystems.


proc quit*() {.cdecl, importc: "SDL_Quit", dynlib: LibName.}
  ## This function cleans up all initialized subsystems. You should
  ## call it upon all exit conditions.


proc quitRequested*(): bool {.inline.} =
  pumpEvents()
  peepEvents(nil, 0, PEEKEVENT, QUITEVENT, QUITEVENT) > 0


proc  getPlatform*(): cstring {.cdecl, importc: "SDL_GetPlatform", dynlib: LibName.}
  ## Gets the name of the platform.

