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

##  audio.nim
##  =========
##
##  Access to the raw audio mixing buffer for the SDL library.

type
  AudioFormat* = uint16 ##  \
    ##  Audio format flags.
    ##
    ##  These are what the 16 bits in ``AudioFormat`` currently mean...
    ##  (Unspecified bits are always zero).
    ##
    ##  ::
    ##    ++-----------------------sample is signed if set
    ##    ||
    ##    ||       ++-----------sample is bigendian if set
    ##    ||       ||
    ##    ||       ||          ++---sample is float if set
    ##    ||       ||          ||
    ##    ||       ||          || +---sample bit size---+
    ##    ||       ||          || |                     |
    ##    15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
    ##
    ##  There are templates in SDL 2.0 and later to query these bits.

# Audio flags
const
  AUDIO_MASK_BITSIZE* = 0x000000FF
  AUDIO_MASK_DATATYPE* = (1 shl 8)
  AUDIO_MASK_ENDIAN* = (1 shl 12)
  AUDIO_MASK_SIGNED* = (1 shl 15)

template audioBitSize*(x: untyped): untyped =
  (x and AUDIO_MASK_BITSIZE)

template audioIsFloat*(x: untyped): untyped =
  (x and AUDIO_MASK_DATATYPE)

template audioIsBigEndian*(x: untyped): untyped =
  (x and AUDIO_MASK_ENDIAN)

template audioIsSigned*(x: untyped): untyped =
  (x and AUDIO_MASK_SIGNED)

template audioIsInt*(x: untyped): untyped =
  (not audioIsFloat(x))

template audioIsLittleEndian*(x: untyped): untyped =
  (not audioIsBigEndian(x))

template audioIsUnsigned*(x: untyped): untyped =
  (not audioIsSigned(x))

# Audio format flags
#
# Defaults to LSB byte order.
const
  AUDIO_U8*     = 0x00000008  ##  Unsigned 8-bit samples
  AUDIO_S8*     = 0x00008008  ##  Signed 8-bit samples
  AUDIO_U16LSB* = 0x00000010  ##  Unsigned 16-bit samples
  AUDIO_S16LSB* = 0x00008010  ##  Signed 16-bit samples
  AUDIO_U16MSB* = 0x00001010  ##  As above, but big-endian byte order
  AUDIO_S16MSB* = 0x00009010  ##  As above, but big-endian byte order
  AUDIO_U16* = AUDIO_U16LSB
  AUDIO_S16* = AUDIO_S16LSB

# int32 support
const
  AUDIO_S32LSB* = 0x00008020  ##  32-bit integer samples
  AUDIO_S32MSB* = 0x00009020  ##  As above, but big-endian byte order
  AUDIO_S32* = AUDIO_S32LSB

# float32 support
const
  AUDIO_F32LSB* = 0x00008120  ##  32-bit floating point samples
  AUDIO_F32MSB* = 0x00009120  ##  As above, but big-endian byte order
  AUDIO_F32* = AUDIO_F32LSB

# Native audio byte ordering
when(cpuEndian == littleEndian):
  const
    AUDIO_U16SYS* = AUDIO_U16LSB
    AUDIO_S16SYS* = AUDIO_S16LSB
    AUDIO_S32SYS* = AUDIO_S32LSB
    AUDIO_F32SYS* = AUDIO_F32LSB
else:
  const
    AUDIO_U16SYS* = AUDIO_U16MSB
    AUDIO_S16SYS* = AUDIO_S16MSB
    AUDIO_S32SYS* = AUDIO_S32MSB
    AUDIO_F32SYS* = AUDIO_F32MSB

# Allow change flags
#
# Which audio format changes are allowed when opening a device.
const
  AUDIO_ALLOW_FREQUENCY_CHANGE* = 0x00000001
  AUDIO_ALLOW_FORMAT_CHANGE*    = 0x00000002
  AUDIO_ALLOW_CHANNELS_CHANGE*  = 0x00000004
  AUDIO_ALLOW_ANY_CHANGE*       = (AUDIO_ALLOW_FREQUENCY_CHANGE or
                                   AUDIO_ALLOW_FORMAT_CHANGE or
                                   AUDIO_ALLOW_CHANNELS_CHANGE)

# Audio flags

type
  AudioCallback* = proc (userdata: pointer; stream: ptr uint8; len: cint) {.
      cdecl.} ##  \
    ##  This procedure is called when the audio device needs more data.
    ##
    ##  ``userdata`` An application-specific parameter
    ##  saved in ``AudioSpec`` object.
    ##
    ##  ``stream`` A pointer to the audio data buffer.
    ##
    ##  ``len`` The length of that buffer in bytes.
    ##
    ##  Once the callback returns, the buffer will no longer be valid.
    ##  Stereo samples are stored in a LRLRLR ordering.
    ##
    ##  You can choose to avoid callbacks and use ``queueAudio()`` instead,
    ##  if you like. Just open your audio device with a `nil` callback.


type
  AudioSpec* = object ##  \
    ##  The calculated values in this object are calculated by ``OpenAudio()``.
    freq*: cint               ##  DSP frequency -- samples per second
    format*: AudioFormat      ##  Audio data format
    channels*: uint8          ##  Number of channels: `1` mono, `2` stereo
    silence*: uint8           ##  Audio buffer silence value (calculated)
    samples*: uint16          ##  Audio buffer size in samples (power of 2)
    padding*: uint16          ##  Necessary for some compile environments
    size*: uint32             ##  Audio buffer size in bytes (calculated)
    callback*: AudioCallback  ##  Callback that feeds the audio device  \
      ##  (`nil` to use ``queueAudio()``).
    userdata*: pointer        ##  Userdata passed to callback \
      ##  (ignored for `nil` callbacks).

type
  AudioFilter* = proc (cvt: ptr AudioCVT; format: AudioFormat) {.cdecl.}

  AudioCVT* = object {.packed.} ##  \
    ##  A structure to hold a set of audio conversion filters and buffers.
    ##
    ##  This structure is 84 bytes on 32-bit architectures, make sure GCC
    ##  doesn't pad it out to 88 bytes to guarantee ABI compatibility between
    ##  compilers. The next time we rev the ABI, make sure to size the ints
    ##  and add padding.
    needed*: cint             ##  Set to `1` if conversion possible
    src_format*: AudioFormat  ##  Source audio format
    dst_format*: AudioFormat  ##  Target audio format
    rate_incr*: cdouble       ##  Rate conversion increment
    buf*: ptr uint8           ##  Buffer to hold entire audio data
    len*: cint                ##  Length of original audio buffer
    len_cvt*: cint            ##  Length of converted audio buffer
    len_mult*: cint           ##  buffer must be `len*len_mult` big
    len_ratio*: cdouble       ##  Given len, final size is `len*len_ratio`
    filters*: array[10, AudioFilter]  ##  Filter list
    filter_index*: cint       ##  Current audio conversion procedure

# Procedures

proc getNumAudioDrivers*(): cint {.
    cdecl, importc: "SDL_GetNumAudioDrivers", dynlib: SDL2_LIB.}
  ##  Driver discovery procedures.
  ##
  ##  These procedures return the list of built in audio drivers, in the
  ##  order that they are normally initialized by default.

proc getAudioDriver*(index: cint): cstring {.
    cdecl, importc: "SDL_GetAudioDriver", dynlib: SDL2_LIB.}
  ##  Driver discovery procedures.
  ##
  ##  These procedures return the list of built in audio drivers, in the
  ##  order that they are normally initialized by default.

proc audioInit*(driver_name: cstring): cint {.
    cdecl, importc: "SDL_AudioInit", dynlib: SDL2_LIB.}
  ##  Initialization.
  ##
  ##  ``Internal:`` These procedures are used internally, and should not be used
  ##  unless you have a specific need to specify the audio driver you want to
  ##  use.  You should normally use ``init()`` or ``initSubSystem()``.

proc audioQuit*() {.
    cdecl, importc: "SDL_AudioQuit", dynlib: SDL2_LIB.}
  ##  Cleanup.
  ##
  ##  ``Internal``: These procedures are used internally, and should not be used
  ##  unless you have a specific need to specify the audio driver you want to
  ##  use.  You should normally use ``init()`` or ``initSubSystem()``.

proc getCurrentAudioDriver*(): cstring {.
    cdecl, importc: "SDL_GetCurrentAudioDriver", dynlib: SDL2_LIB.}
  ##  This procedure returns the name of the current audio driver, or `nil`
  ##  if no driver has been initialized.

proc openAudio*(desired: ptr AudioSpec; obtained: ptr AudioSpec): cint {.
    cdecl, importc: "SDL_OpenAudio", dynlib: SDL2_LIB.}
  ##  This procedure opens the audio device with the desired parameters, and
  ##  returns `0` if successful, placing the actual hardware parameters in the
  ##  object pointed to by ``obtained``.  If ``obtained`` is `nil`, the audio
  ##  data passed to the callback procedure will be guaranteed to be in the
  ##  requested format, and will be automatically converted to the hardware
  ##  audio format if necessary.  This procedure returns `-1` if it failed
  ##  to open the audio device, or couldn't set up the audio thread.
  ##
  ##  When filling in the ``desired`` audio spec object,
  ##  * ``desired.freq`` should be the desired audio frequency
  ##    in samples-per- second.
  ##  * ``desired.format`` should be the desired audio format.
  ##  * ``desired.samples`` is the desired size of the audio buffer,
  ##    in samples.  This number should be a power of two, and may be adjusted
  ##    by the audio driver to a value more suitable for the hardware.
  ##    Good values seem to range between `512` and `8096` inclusive, depending
  ##    on the  application and CPU speed.  Smaller values yield faster
  ##    response time, but can lead to underflow if the application is doing
  ##    heavy processing and cannot fill the audio buffer in time.  A stereo
  ##    sample consists of both right and left channels in LR ordering.
  ##
  ##    Note that the number of samples is directly related to time by the
  ##    following formula:
  ##
  ##    `ms = (samples*1000)/freq`
  ##
  ##  * ``desired.size`` is the size in bytes of the audio buffer, and is
  ##    calculated by ``openAudio()``.
  ##  * ``desired.silence`` is the value used to set the buffer to silence,
  ##    and is calculated by ``openAudio()``.
  ##  * ``desired.callback`` should be set to a procedure that will be called
  ##    when the audio device is ready for more data.  It is passed a pointer
  ##    to the audio buffer, and the length in bytes of the audio buffer.
  ##    This procedure usually runs in a separate thread, and so you should
  ##    protect data structures that it accesses by calling ``lockAudio()``
  ##    and ``unlockAudio()`` in your code. Alternately, you may pass a `nil`
  ##    pointer here, and call ``queueAudio()`` with some frequency, to queue
  ##    more audio samples to be played (or for capture devices, call
  ##    ``sdl.dequeueAudio()`` with some frequency, to obtain audio samples).
  ##  * ``desired.userdata`` is passed as the first parameter to your callback
  ##    procedure. If you passed a `nil` callback, this value is ignored.
  ##
  ##  The audio device starts out playing silence when it's opened, and should
  ##  be enabled for playing by calling ``pauseAudio(0)`` when you are ready
  ##  for your audio callback procedure to be called.  Since the audio driver
  ##  may modify the requested size of the audio buffer, you should allocate
  ##  any local mixing buffers after you open the audio device.

type
  AudioDeviceID* = uint32 ##  \
  ##  SDL Audio Device IDs.
  ##
  ##  A successful call to ``openAudio()`` is always device id `1`, and legacy
  ##  SDL audio APIs assume you want this device ID.
  ##  ``openAudioDevice()`` calls always returns devices >= `2` on success.
  ##  The legacy calls are good both for backwards compatibility and when you
  ##  don't care about multiple, specific, or capture devices.

proc getNumAudioDevices*(iscapture: cint): cint {.
    cdecl, importc: "SDL_GetNumAudioDevices", dynlib: SDL2_LIB.}
  ##  Get the number of available devices exposed by the current driver.
  ##
  ##  Only valid after a successfully initializing the audio subsystem.
  ##  Returns `-1` if an explicit list of devices can't be determined; this is
  ##  not an error. For example, if SDL is set up to talk to a remote audio
  ##  server, it can't list every one available on the Internet, but it will
  ##  still allow a specific host to be specified to ``openAudioDevice()``.
  ##
  ##  In many common cases, when this procedure returns a value <= `0`,
  ##  it can still  successfully open the default device (`nil` for first
  ##  argument of ``openAudioDevice()``).

proc getAudioDeviceName*(index: cint; iscapture: cint): cstring {.
    cdecl, importc: "SDL_GetAudioDeviceName", dynlib: SDL2_LIB.}
  ##  Get the human-readable name of a specific audio device.
  ##
  ##  Must be a value between `0` and `(number of audio devices-1)`.
  ##  Only valid after a successfully initializing the audio subsystem.
  ##  The values returned by this procedure reflect the latest call to
  ##  ``getNumAudioDevices()``; recall that procedure to redetect available
  ##  hardware.
  ##
  ##  The string returned by this procedure is UTF-8 encoded, read-only, and
  ##  managed internally. You are not to free it. If you need to keep the
  ##  string for any length of time, you should make your own copy of it, as it
  ##  will be invalid next time any of several other SDL prodedures is called.

proc openAudioDevice*(
    device: cstring; iscapture: cint;
    desired: ptr AudioSpec; obtained: ptr AudioSpec;
    allowed_changes: cint): AudioDeviceID {.
      cdecl, importc: "SDL_OpenAudioDevice", dynlib: SDL2_LIB.}
  ##  Open a specific audio device.
  ##
  ##  Passing in a device name of `nil` requests the most reasonable default
  ##  (and is equivalent to calling ``openAudio()``).
  ##
  ##  The device name is a UTF-8 string reported by ``getAudioDeviceName()``,
  ##  but some drivers allow arbitrary and driver-specific strings, such as a
  ##  hostname/IP address for a remote audio server, or a filename in the
  ##  diskaudio driver.
  ##
  ##  ``Return`` `0` on error, a valid device ID that is >= `2` on success.
  ##
  ##  ``openAudio()``, unlike this procedure, always acts on device ID `1`.

type
  AudioStatus* {.size: sizeof(cint).} = enum
    AUDIO_STOPPED = 0,
    AUDIO_PLAYING,
    AUDIO_PAUSED

proc GetAudioStatus*(): AudioStatus {.
    cdecl, importc: "SDL_GetAudioStatus", dynlib: SDL2_LIB.}
  ##  Get the current audio state.

proc GetAudioDeviceStatus*(dev: AudioDeviceID): AudioStatus {.
    cdecl, importc: "SDL_GetAudioDeviceStatus", dynlib: SDL2_LIB.}
  ##  Get the current audio state.

proc pauseAudio*(pause_on: cint) {.
    cdecl, importc: "SDL_PauseAudio", dynlib: SDL2_LIB.}
  ##  Pause audio procedures.
  ##
  ##  These procedures pause and unpause the audio callback processing.
  ##  They should be called with a parameter of `0` after opening the audio
  ##  device to start playing sound.  This is so you can safely initialize
  ##  data for your callback procedure after opening the audio device.
  ##  Silence will be written to the audio device during the pause.

proc pauseAudioDevice*(dev: AudioDeviceID; pause_on: cint) {.
    cdecl, importc: "SDL_PauseAudioDevice", dynlib: SDL2_LIB.}
  ##  Pause audio procedures.
  ##
  ##  These procedures pause and unpause the audio callback processing.
  ##  They should be called with a parameter of `0` after opening the audio
  ##  device to start playing sound.  This is so you can safely initialize
  ##  data for your callback procedure after opening the audio device.
  ##  Silence will be written to the audio device during the pause.

proc loadWAV_RW*(
    src: ptr RWops; freesrc: cint; spec: ptr AudioSpec;
    audio_buf: ptr ptr uint8; audio_len: ptr uint32): ptr AudioSpec {.
      cdecl, importc: "SDL_LoadWAV_RW", dynlib: SDL2_LIB.}
  ##  This procedure loads a WAVE from the data source, automatically freeing
  ##  that source if ``freesrc`` is non-zero.  For example, to load a WAVE file,
  ##  you could do:
  ##
  ##      loadWAV_RW(rwFromFile("sample.wav", "rb"), 1, ...)
  ##
  ##
  ##  If this procedure succeeds, it returns the given AudioSpec,
  ##  filled with the audio data format of the wave data, and sets
  ##  ``audio_buf[]`` to a malloc()'d buffer containing the audio data,
  ##  and sets ``audio_len[]`` to the length of that audio buffer, in bytes.
  ##  You need to free the audio buffer with ``freeWAV()`` when you are
  ##  done with it.
  ##
  ##  This procedure returns `nil` and sets the SDL error message if the
  ##  wave file cannot be opened, uses an unknown data format, or is
  ##  corrupt.  Currently raw and MS-ADPCM WAVE files are supported.

template loadWAV*(file, spec, audio_buf, audio_len: untyped): untyped = ##  \
  ##  Loads a WAV from a file.
  ##
  ##  Compatibility convenience template.
  loadWAV_RW(rwFromFile(file, "rb"), 1, spec, audio_buf, audio_len)


proc freeWAV*(audio_buf: ptr uint8) {.
    cdecl, importc: "SDL_FreeWAV", dynlib: SDL2_LIB.}
  ##  This procedure frees data previously allocated with ``loadWAV_RW()``

proc buildAudioCVT*(cvt: ptr AudioCVT;
    src_format: AudioFormat; src_channels: uint8; src_rate: cint; 
    dst_format: AudioFormat; dst_channels: uint8; dst_rate: cint): cint {.
      cdecl, importc: "SDL_BuildAudioCVT", dynlib: SDL2_LIB.}
  ##  This procedure takes a source format and rate and a destination format
  ##  and rate, and initializes the ``cvt`` object with information needed
  ##  by ``convertAudio()`` to convert a buffer of audio data from one format
  ##  to the other.
  ##
  ##  ``Return`` `-1` if the format conversion is not supported,
  ##  `0` if there's no conversion needed, or 1 if the audio filter is set up.

proc convertAudio*(cvt: ptr AudioCVT): cint {.
    cdecl, importc: "SDL_ConvertAudio", dynlib: SDL2_LIB.}
  ##  Once you have initialized the ``cvt`` object using ``buildAudioCVT()``,
  ##  created an audio buffer ``cvt.buf``, and filled it with ``cvt.len`` bytes
  ##  of audio data in the source format, this procedure will convert it
  ##  in-place to the desired format.
  ##
  ##  The data conversion may expand the size of the audio data, so the buffer
  ##  ``cvt.buf`` should be allocated after the ``cvt`` object is initialized
  ##  by ``buildAudioCVT()``, and should be `cvt.len*cvt.len_mult` bytes long.

const
  MIX_MAXVOLUME* = 128

proc mixAudio*(dst: ptr uint8; src: ptr uint8; len: uint32; volume: cint) {.
    cdecl, importc: "SDL_MixAudio", dynlib: SDL2_LIB.}
  ##  This takes two audio buffers of the playing audio format and mixes
  ##  them, performing addition, volume adjustment, and overflow clipping.
  ##  The volume ranges from `0 - 128`, and should be set to `MIX_MAXVOLUME`
  ##  for full audio volume.  Note this does not change hardware volume.
  ##  This is provided for convenience -- you can mix your own audio data.

proc mixAudioFormat*(
    dst: ptr uint8; src: ptr uint8;
    format: AudioFormat; len: uint32; volume: cint) {.
      cdecl, importc: "SDL_MixAudioFormat", dynlib: SDL2_LIB.}
  ##  This works like ``mixAudio()``, but you specify the audio format instead
  ##  of using the format of audio device `1`.
  ##  Thus it can be used when no audio device is open at all.

proc queueAudio*(dev: AudioDeviceID; data: pointer; len: uint32): cint {.
      cdecl, importc: "SDL_QueueAudio", dynlib: SDL2_LIB.}
  ##  Queue more audio on non-callback devices.
  ##
  ##  (If you are looking to retrieve queued audio from a non-callback capture
  ##  device, you want ``sdl.dequeueAudio()`` instead. This will return `-1`
  ##  to signify an error if you use it with capture devices.)
  ##
  ##  SDL offers two ways to feed audio to the device: you can either supply a
  ##  callback that SDL triggers with some frequency to obtain more audio
  ##  (pull method), or you can supply no callback, and then SDL will expect
  ##  you to supply data at regular intervals (push method) with this procedure.
  ##
  ##  There are no limits on the amount of data you can queue, short of
  ##  exhaustion of address space. Queued data will drain to the device as
  ##  necessary without further intervention from you. If the device needs
  ##  audio but there is not enough queued, it will play silence to make up
  ##  the difference. This means you will have skips in your audio playback
  ##  if you aren't routinely queueing sufficient data.
  ##
  ##  This procedure copies the supplied data, so you are safe to free it when
  ##  the procedure returns. This procedure is thread-safe, but queueing to the
  ##  same device from two threads at once does not promise which buffer will
  ##  be queued first.
  ##
  ##  You may not queue audio on a device that is using an application-supplied
  ##  callback; doing so returns an error. You have to use the audio callback
  ##  or queue audio with this procedure, but not both.
  ##
  ##  You should not call ``lockAudio()`` on the device before queueing; SDL
  ##  handles locking internally for this procedure.
  ##
  ##  ``dev`` The device ID to which we will queue audio.
  ##
  ##  ``data`` The data to queue to the device for later playback.
  ##
  ##  ``len`` The number of bytes (not samples!) to which (data) points.
  ##
  ##  ``Return`` `0` on success, `-1` on error.
  ##
  ##  See also:
  ##
  ##  ``getQueuedAudioSize()``
  ##
  ##  ``clearQueuedAudio()``

proc dequeueAudio*(dev: AudioDeviceID; data: pointer; len: uint32): cint {.
      cdecl, importc: "SDL_DequeueAudio", dynlib: SDL2_LIB.}
  ##  Dequeue more audio on non-callback devices.
  ##
  ##  (If you are looking to queue audio for output on a non-callback playback
  ##  device, you want ``sdl.queueAudio()`` instead. This will always return
  ##  `0` if you use it with playback devices.)
  ##
  ##  SDL offers two ways to retrieve audio from a capture device: you can
  ##  either supply a callback that SDL triggers with some frequency as the
  ##  device records more audio data, (push method), or you can supply no
  ##  callback, and then SDL will expect you to retrieve data at regular
  ##  intervals (pull method) with this procedure.
  ##
  ##  There are no limits on the amount of data you can queue, short of
  ##  exhaustion of address space. Data from the device will keep queuing as
  ##  necessary without further intervention from you. This means you will
  ##  eventually run out of memory if you aren't routinely dequeueing data.
  ##
  ##  Capture devices will not queue data when paused; if you are expecting
  ##  to not need captured audio for some length of time, use
  ##  ``sdl.pauseAudioDevice()`` to stop the capture device from queueing more
  ##  data. This can be useful during, say, level loading times. When
  ##  unpaused, capture devices will start queueing data from that point,
  ##  having flushed any capturable data available while paused.
  ##
  ##  This procedure is thread-safe, but dequeueing from the same device from
  ##  two threads at once does not promise which thread will dequeued data
  ##  first.
  ##
  ##  You may not dequeue audio from a device that is using an
  ##  application-supplied callback; doing so returns an error. You have to use
  ##  the audio callback, or dequeue audio with this procedure, but not both.
  ##
  ##  You should not call ``sdl.lockAudio()`` on the device before queueing;
  ##  SDL handles locking internally for this function.
  ##
  ##  ``dev`` The device ID from which we will dequeue audio.
  ##  ``data`` A pointer into where audio data should be copied.
  ##  ``len`` The number of bytes (not samples!) to which (data) points.
  ##  ``Return`` number of bytes dequeued, which could be less than requested.
  ##
  ##  See also:
  ##
  ##  ``getQueuedAudioSize``
  ##  ``clearQueuedAudio``

proc getQueuedAudioSize*(dev: AudioDeviceID): uint32 {.
    cdecl, importc: "SDL_GetQueuedAudioSize", dynlib: SDL2_LIB.}
  ##  Get the number of bytes of still-queued audio.
  ##
  ##  For playback device:
  ##
  ##    This is the number of bytes that have been queued for playback with
  ##    ``sdl.queueAudio()``, but have not yet been sent to the hardware. This
  ##    number may shrink at any time, so this only informs of pending data.
  ##
  ##    Once we've sent it to the hardware, this procedure can not decide the
  ##    exact byte boundary of what has been played. It's possible that we just
  ##    gave the hardware several kilobytes right before you called this
  ##    procedure, but it hasn't played any of it yet, or maybe half of it, etc.
  ##
  ##  For capture device:
  ##
  ##    This is the number of bytes that have been captured by the device and
  ##    are waiting for you to dequeue. This number may grow at any time, so
  ##    this only informs of the lower-bound of available data.
  ##
  ##  You may not queue audio on a device that is using an application-supplied
  ##  callback; calling this procedure on such a device always returns `0`.
  ##  You have to queue audio with ``sdl.queueAudio()`` /
  ##  ``sdl.dequeueAudio()``, or use the audio callback,  but not both.
  ##
  ##  You should not call ``lockAudio()`` on the device before querying; SDL
  ##  handles locking internally for this procedure.
  ##
  ##  ``dev`` The device ID of which we will query queued audio size.
  ##
  ##  ``Return`` number of bytes (not samples!) of queued audio.
  ##
  ##  See also:
  ##
  ##  ``queueAudio()``
  ##
  ##  ``clearQueuedAudio()``

proc clearQueuedAudio*(dev: AudioDeviceID) {.
    cdecl, importc: "SDL_ClearQueuedAudio", dynlib: SDL2_LIB.}
  ##  Drop any queued audio data. For playback devices, this is any queued data
  ##  still waiting to be submitted to the hardware. For capture devices, this
  ##  is any data that was queued by the device that hasn't yet been dequeued
  ##  by the application.
  ##
  ##  Immediately after this call, ``sdl.getQueuedAudioSize()`` will return `0`.
  ##  For playback devices, the hardware will start playing silence if more
  ##  audio isn't queued. Unpaused capture devices will start filling the queue
  ##  again as soon as they have more data available (which, depending on the
  ##  state of the hardware and the thread, could be before this function call
  ##  returns!).
  ##
  ##  This will not prevent playback of queued audio that's already been sent
  ##  to the hardware, as we can not undo that, so expect there to be some
  ##  fraction of a second of audio that might still be heard. This can be
  ##  useful if you want to, say, drop any pending music during a level change
  ##  in your game.
  ##
  ##  You may not queue audio on a device that is using an application-supplied
  ##  callback; calling this procedure on such a device is always a no-op.
  ##  You have to queue audio with ``sdl.queueAudio()`` /
  ##  ``sdl.dequeueAudio()``, or use the audio callback, but not both.
  ##
  ##  You should not call ``lockAudio()`` on the device before clearing the
  ##  queue; SDL handles locking internally for this procedure.
  ##
  ##  This procedure always succeeds and thus returns nothing.
  ##
  ##  ``dev`` The device ID of which to clear the audio queue.
  ##
  ##  See also:
  ##
  ##  ``queueAudio()``
  ##
  ##  ``getQueuedAudioSize()``

proc lockAudio*() {.
    cdecl, importc: "SDL_LockAudio", dynlib: SDL2_LIB.}
  ##  Audio lock procedure.
  ##
  ##  The lock manipulated by these procedures protects the callback procedure.
  ##  During a ``lockAudio()``/``unlockAudio()`` pair, you can be guaranteed
  ##  that the callback procedure is not running.  Do not call these from the
  ##  callback procedure or you will cause deadlock.

proc lockAudioDevice*(dev: AudioDeviceID) {.
    cdecl, importc: "SDL_LockAudioDevice", dynlib: SDL2_LIB.}
  ##  Audio lock procedure.
  ##
  ##  The lock manipulated by these procedures protects the callback procedure.
  ##  During a ``lockAudio()``/``unlockAudio()`` pair, you can be guaranteed
  ##  that the callback procedure is not running.  Do not call these from the
  ##  callback procedure or you will cause deadlock.

proc unlockAudio*() {.
    cdecl, importc: "SDL_UnlockAudio", dynlib: SDL2_LIB.}
  ##  Audio unlock procedure.
  ##
  ##  The lock manipulated by these procedures protects the callback procedure.
  ##  During a ``lockAudio()``/``unlockAudio()`` pair, you can be guaranteed
  ##  that the callback procedure is not running.  Do not call these from the
  ##  callback procedure or you will cause deadlock.

proc unlockAudioDevice*(dev: AudioDeviceID) {.
    cdecl, importc: "SDL_UnlockAudioDevice", dynlib: SDL2_LIB.}
  ##  Audio unlock procedure.
  ##
  ##  The lock manipulated by these procedures protects the callback procedure.
  ##  During a ``lockAudio()``/``unlockAudio()`` pair, you can be guaranteed
  ##  that the callback procedure is not running.  Do not call these from the
  ##  callback procedure or you will cause deadlock.

proc closeAudio*() {.
    cdecl, importc: "SDL_CloseAudio", dynlib: SDL2_LIB.}
  ##  This procedure shuts down audio processing and closes the audio device.

proc closeAudioDevice*(dev: AudioDeviceID) {.
    cdecl, importc: "SDL_CloseAudioDevice", dynlib: SDL2_LIB.}
  ##  This procedure shuts down audio processing and closes the audio device.
