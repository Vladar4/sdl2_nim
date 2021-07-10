#  SMPEG - SDL MPEG Player Library
#  Copyright (C) 1999  Loki Entertainment Software
#
#  This library is free software; you can redistribute it and/or
#  modify it under the terms of the GNU Library General Public
#  License as published by the Free Software Foundation; either
#  version 2 of the License, or (at your option) any later version.
#
#  This library is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  Library General Public License for more details.
#
#  You should have received a copy of the GNU Library General Public
#  License along with this library; if not, write to the Free
#  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#

##  smpeg.nim
##  =========
##
##  SDL2 MPEG Player library.
##
##  Use ``ffmpeg`` to convert media files to the supported format:
##
##  .. code-block::
##    ffmpeg -i input_file -target ntsc-vcd -c:v mpeg1video -c:a mp2 output.mpg
##

{.deadCodeElim: on.}

import sdl

const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 0

type
  Version* = object
    major*: uint8
    minor*: uint8
    patch*: uint8

template version*(x: untyped) = ##  \
  ##  This template can be used to fill a version structure with
  ##  the compile-time version of the SDL library.
  (x).major = MAJOR_VERSION
  (x).minor = MINOR_VERSION
  (x).patch = PATCHLEVEL


type
  Smpeg* = pointer  ##  This is the actual SMPEG object

  Frame* = ptr FrameObj
  FrameObj* = object ##  \
    ##  A YV12 format video frame
    w*: cuint
    h*: cuint
    imageWidth*: cuint
    imageHeight*: cuint
    image*: ptr uint8

  Info* = object  ##  \
    ##  Used to get information about the SMPEG object
    hasAudio*: cint
    hasVideo*: cint
    width*: cint
    height*: cint
    currentFrame*: cint
    currentFps*: cdouble
    audioString*: array[80, char]
    audioCurrentFrame*: cint
    currentOffset*: uint32
    totalSize*: uint32
    currentTime*: cdouble
    totalTime*: cdouble


type
  SMPEGstatus* {.size: sizeof(cint).} = enum  ##  Possible MPEG status codes
    ERROR = - 1
    STOPPED
    PLAYING


type
  DisplayCallback* = proc (data: pointer; frame: Frame) {.cdecl.}
    ##  Matches the declaration of ``sdl.updateRect()``
    ##
    ##  ``data``  Your custom movie object,
    ##  should contain at least ``Frame`` field.
    ##
    ##  ``frame`` New frame data. Use it to update target texture on render
    ##  with ``updateTexture()`` call. Target texture should be of
    ##  `sdl.PixelFormat_YV12` format and with `sdl.TextureAccessStreaming`
    ##  access.
    ##
    ##  Minimal viable implementation:
    ##
    ##  .. code-block:: nim
    ##    proc update(data: pointer, frame: Frame) {.cdecl.} =
    ##      var movie = cast[MyCustomMovie](data)
    ##      movie.frame = frame
    ##


proc new*(file: cstring; info: ptr Info; sdlAudio: bool): Smpeg {.
    cdecl, importc: "SMPEG_new", dynlib: SMPEG2_LIB.}
  ##  Create a new SMPEG object from an MPEG file.
  ##
  ##  On return, if ``info`` is not `nil`, it will be filled with information
  ##  about the MPEG object.
  ##
  ##  This procedure returns a new SMPEG object. Use ``smpeg.error()``
  ##  to find out whether or not there was a problem building the MPEG stream.
  ##
  ##  The ``sdl_audio`` parameter indicates if SMPEG should initialize
  ##  the SDL audio subsystem. If not, you will have to use
  ##  the ``smpeg.playaudio()`` procedure below to extract the decoded data.


proc newDescr*(file: cint; info: ptr Info; sdlAudio: bool): Smpeg {.
    cdecl, importc: "SMPEG_new_descr", dynlib: SMPEG2_LIB.}
  ##  The same as above for a file descriptor


proc newData*(
  data: pointer; size: cint; info: ptr Info; sdlAudio: bool): Smpeg {.
    cdecl, importc: "SMPEG_new_data", dynlib: SMPEG2_LIB.}
  ##  The same as above but for a raw chunk of data.
  ##
  ##  SMPEG makes a copy of the data, so the application is free to delete
  ##  after a successful call to this procedure.

proc newRwops*(
  src: ptr sdl.RWops; info: ptr Info; freesrc: bool; sdlAudio: bool): Smpeg {.
    cdecl, importc: "SMPEG_new_rwops", dynlib: SMPEG2_LIB.}
  ##  The same for a generic ``sdl.RWops`` structure.
  ##
  ##  ``freesrc`` should be `true` if SMPEG should close the source
  ##  when it's done.

proc getInfo*(mpeg: Smpeg; info: ptr Info) {.
    cdecl, importc: "SMPEG_getinfo", dynlib: SMPEG2_LIB.}
  ##  Get current information about an SMPEG object.

proc enableAudio*(mpeg: Smpeg; enable: bool) {.
    cdecl, importc: "SMPEG_enableaudio", dynlib: SMPEG2_LIB.}
  ##  Enable or disable audio playback in MPEG stream.

proc enableVideo*(mpeg: Smpeg; enable: bool) {.
    cdecl, importc: "SMPEG_enablevideo", dynlib: SMPEG2_LIB.}
  ##  Enable or disable video playback in MPEG stream.

proc delete*(mpeg: Smpeg) {.
    cdecl, importc: "SMPEG_delete", dynlib: SMPEG2_LIB.}
  ##  Delete an SMPEG object.

proc status*(mpeg: Smpeg): SMPEGstatus {.
    cdecl, importc: "SMPEG_status", dynlib: SMPEG2_LIB.}
  ##  Get the current status of an SMPEG object.

proc setVolume*(mpeg: Smpeg; volume: cint) {.
    cdecl, importc: "SMPEG_setvolume", dynlib: SMPEG2_LIB.}
  ##  Set the audio volume of an MPEG stream, in the range `0`-`100`.

proc setDisplay*(
  mpeg: Smpeg; callback: DisplayCallback; data: pointer; lock: sdl.Mutex) {.
    cdecl, importc: "SMPEG_setdisplay", dynlib: SMPEG2_LIB.}
  ##  Set the frame display callback for MPEG video.
  ##
  ##  ``lock`` is a mutex used to synchronize access to the frame data,
  ##  and is held during the update callback.

proc loop*(mpeg: Smpeg; repeat: bool) {.
    cdecl, importc: "SMPEG_loop", dynlib: SMPEG2_LIB.}
  ##  Set or clear looping play on an SMPEG object.

proc play*(mpeg: Smpeg) {.
    cdecl, importc: "SMPEG_play", dynlib: SMPEG2_LIB.}
  ##  Play an SMPEG object.

proc pause*(mpeg: Smpeg) {.
    cdecl, importc: "SMPEG_pause", dynlib: SMPEG2_LIB.}
  ##  Pause/Resume playback of an SMPEG object.

proc stop*(mpeg: Smpeg) {.
    cdecl, importc: "SMPEG_stop", dynlib: SMPEG2_LIB.}
  ##  Stop playback of an SMPEG object.

proc rewind*(mpeg: Smpeg) {.
    cdecl, importc: "SMPEG_rewind", dynlib: SMPEG2_LIB.}
  ##  Rewind the play position of an SMPEG object to the beginning of the MPEG.

proc seek*(mpeg: Smpeg; bytes: cint) {.
    cdecl, importc: "SMPEG_seek", dynlib: SMPEG2_LIB.}
  ##  Seek ``bytes`` bytes in the MPEG stream.

proc skip*(mpeg: Smpeg; seconds: cfloat) {.
    cdecl, importc: "SMPEG_skip", dynlib: SMPEG2_LIB.}
  ##  Skip ``seconds`` seconds in the MPEG stream.

proc renderFrame*(mpeg: Smpeg; framenum: cint) {.
    cdecl, importc: "SMPEG_renderFrame", dynlib: SMPEG2_LIB.}
  ##  Render a particular frame in the MPEG video.

proc renderFinal*(mpeg: Smpeg) {.
    cdecl, importc: "SMPEG_renderFinal", dynlib: SMPEG2_LIB.}
  ##  Render the last frame of an MPEG video.

proc error*(mpeg: Smpeg): cstring {.
    cdecl, importc: "SMPEG_error", dynlib: SMPEG2_LIB.}
  ##  Return `nil` if there is no error in the MPEG stream, or an error message
  ##  if there was a fatal error in the MPEG stream for the SMPEG object.

proc playAudio*(mpeg: Smpeg; stream: ptr uint8; len: cint): cint {.
    cdecl, importc: "SMPEG_playAudio", dynlib: SMPEG2_LIB.}
  ##  Exported callback procedure for audio playback.
  ##
  ##  The procedure takes a buffer and the amount of data to fill, and returns
  ##  the amount of data in bytes that was actually written. This will be the
  ##  amount requested unless the MPEG audio has finished.

proc playAudioSDL*(mpeg: pointer; stream: ptr uint8; len: cint) {.
    cdecl, importc: "SMPEG_playAudioSDL", dynlib: SMPEG2_LIB.}
  ##  Wrapper for ``smpeg.playAudio()`` that can be passed to SDL and SDL_mixer.

proc wantedSpec*(mpeg: Smpeg; wanted: ptr sdl.AudioSpec): cint {.
    cdecl, importc: "SMPEG_wantedSpec", dynlib: SMPEG2_LIB.}
  ##  Get the best SDL audio spec for the audio stream.

proc actualSpec*(mpeg: Smpeg; spec: ptr sdl.AudioSpec) {.
    cdecl, importc: "SMPEG_actualSpec", dynlib: SMPEG2_LIB.}
  ##  Inform SMPEG of the actual SDL audio spec used for sound playback.

