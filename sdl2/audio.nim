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
# Access to the raw audio mixing buffer for the SDL library.
#


#
# Audio format flags.
#
# These are what the 16 bits in TAudioFormat currently mean...
# (Unspecified bits are always zero).
#
#
# ++-----------------------sample is signed if set
# ||
# ||       ++-----------sample is bigendian if set
# ||       ||
# ||       ||          ++---sample is float if set
# ||       ||          ||
# ||       ||          || +---sample bit size---+
# ||       ||          || |                     |
# 15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
#


type
  TAudioFormat* = Uint16 ## There are templates in SDL 2.0 and later to query these bits.


# Audio flags

const
  AUDIO_MASK_BITSIZE* = 0xFF
  AUDIO_MASK_DATATYPE* = 1 shl 8
  AUDIO_MASK_ENDIAN* = 1 shl 12
  AUDIO_MASK_SIGNED* = 1 shl 15


template audioBitSize*(x: expr): expr =
  (x and AUDIO_MASK_BITSIZE)


template audioIsFloat*(x: expr): expr =
  (x and AUDIO_MASK_DATATYPE)


template audioIsBigEndian*(x: expr): expr =
  (x and AUDIO_MASK_ENDIAN)


template audioIsSigned*(x: expr): expr =
  (x and AUDIO_MASK_SIGNED)


template audioIsInt*(x: expr): expr =
  (not audioIsFloat(x))


template audioIsLittleEndian*(x: expr): expr =
  (not audioIsBigEndian(x))


template audioIsUnsigned*(x: expr): expr =
  (not audioIsSigned(x))


#
# Audio format flags
#
# Defaults to LSB byte order.
#


const
  AUDIO_U8* = 0x0008 ## Unsigned 8-bit samples
  AUDIO_S8* = 0x8008 ## Signed 8-bit samples
  AUDIO_U16LSB* = 0x0010 ## Unsigned 16-bit samples
  AUDIO_S16LSB* = 0x8010 ## Signed 16-bit samples
  AUDIO_U16MSB* = 0x1010 ## As above, but big-endian byte order
  AUDIO_S16MSB* = 0x9010 ## As above, but big-endian byte order
  AUDIO_U16* = AUDIO_U16LSB
  AUDIO_S16* = AUDIO_S16LSB

  # int32 support

  AUDIO_S32LSB* = 0x8020 ## 32-bit integer samples
  AUDIO_S32MSB* = 0x9020 ## As above, but big-endian byte order
  AUDIO_S32* = AUDIO_S32LSB

  # float32 support

  AUDIO_F32LSB* = 0x8120 ## 32-bit floating point samples
  AUDIO_F32MSB* = 0x9120 ## As above, but big-endian byte order
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
  AUDIO_ALLOW_FORMAT_CHANGE* = 0x00000002
  AUDIO_ALLOW_CHANNELS_CHANGE* = 0x00000004
  AUDIO_ALLOW_ANY_CHANGE* = (AUDIO_ALLOW_FREQUENCY_CHANGE or
                             AUDIO_ALLOW_FORMAT_CHANGE or
                             AUDIO_ALLOW_CHANNELS_CHANGE)


# Audio flags


type
  PAudioCallback* = proc(userdata: pointer, stream: ptr byte, len: int) {.cdecl.}
    ## This function is called when the audio device needs more data.
    ##
    ## ``userdata`` An application-specific parameter saved in
    ## the TAudioSpec structure
    ##
    ## ``stream`` A pointer to the audio data buffer.
    ##
    ##  ``len``    The length of that buffer in bytes.
    ##
    ## Once the callback returns, the buffer will no longer be valid.
    ## Stereo samples are stored in a LRLRLR ordering.

  
  PAudioSpec* = ptr TAudioSpec
  TAudioSpec*{.pure.} = object
    ## The calculated values in this structure are calculated by openAudio().
    freq*: int32 ## DSP frequency -- samples per second
    format*: TAudioFormat ## Audio data format
    channels*: Uint8 ## Number of channels: 1 mono, 2 stereo
    silence*: Uint8 ## Audio buffer silence value (calculated)
    samples*: Uint16 ## Audio buffer size in samples (power of 2)
    padding*: Uint16 ## Necessary for some compile environments
    size*: Uint32 ## Audio buffer size in bytes (calculated)
    callback*: PAudioCallback
    userdata*: pointer


  PAudioFilter* = proc(cvt: PAudioCVT, format: TAudioFormat) {.cdecl.}

  
  PAudioCVT* = ptr TAudioCVT
  TAudioCVT*{.pure.} = object
    ## A structure to hold a set of audio conversion filters and buffers.
    needed*: int32 ## Set to 1 if conversion possible
    src_format*: TAudioFormat ## Source audio format
    dst_format*: TAudioFormat ## Target audio format
    rate_incr*: cdouble ## Rate conversion increment
    buf*: ptr byte ## Buffer to hold entire audio data
    len*: int32 ## Length of original audio buffer
    len_cvt*: int32 ## Length of converted audio buffer
    len_mult*: int32 ## buffer must be len*len_mult big
    len_ratio*: cdouble ## Given len, final size is len*len_ratio
    filters*: array[0..9, PAudioFilter] ## Filter list
    filter_index*: int32 ## Current audio conversion function


# Function prototypes

proc getNumAudioDrivers*(): int {.cdecl, importc: "SDL_GetNumAudioDrivers", dynlib: LibName.}
  ## Driver discovery functions
  ##
  ## These functions return the list of built in audio drivers, in the
  ## order that they are normally initialized by default.


proc getAudioDriver*(index: int): cstring {.cdecl, importc: "SDL_GetAudioDriver", dynlib: LibName.}
  ## Driver discovery functions
  ##
  ## These functions return the list of built in audio drivers, in the
  ## order that they are normally initialized by default.


proc audioInit*(driver_name: cstring): int {.cdecl, importc: "SDL_AudioInit", dynlib: LibName.}
  ## Initialization and cleanup
  ##
  ## These functions are used internally, and should not be used unless
  ## you have a specific need to specify the audio driver you want to
  ## use.  You should normally use init() or initSubSystem().


proc audioQuit*() {.cdecl, importc: "SDL_AudioQuit", dynlib: LibName.}
  ## Initialization and cleanup
  ##
  ## These functions are used internally, and should not be used unless
  ## you have a specific need to specify the audio driver you want to
  ## use.  You should normally use init() or initSubSystem().


proc getCurrentAudioDriver*(): cstring {.cdecl, importc: "SDL_GetCurrentAudioDriver", dynlib: LibName.}
  ## This function returns the name of the current audio driver, or nil
  ## if no driver has been initialized.


proc openAudio*(desired, obtained: PAudioSpec): int {.cdecl, importc: "SDL_OpenAudio", dynlib: LibName.}
  ##  This function opens the audio device with the desired parameters, and
  ## returns 0 if successful, placing the actual hardware parameters in the
  ## structure pointed to by ``obtained``.  If ``obtained`` is nil, the audio
  ## data passed to the callback function will be guaranteed to be in the
  ## requested format, and will be automatically converted to the hardware
  ## audio format if necessary.  This function returns -1 if it failed
  ## to open the audio device, or couldn't set up the audio thread.
  ##
  ## When filling in the desired audio spec structure,
  ##
  ## - ``desired.freq`` should be the desired audio frequency
  ## in samples-per-second.
  ##
  ## - ``desired.format`` should be the desired audio format.
  ##
  ## - ``desired.samples`` is the desired size of the audio buffer, in
  ## samples. This number should be a power of two, and may be adjusted by
  ## the audio driver to a value more suitable for the hardware. Good values
  ## seem to range between 512 and 8096 inclusive, depending on the
  ## application and CPU speed.  Smaller values yield faster response time,
  ## but can lead to underflow if the application is doing heavy processing
  ## and cannot fill the audio buffer in time.  A stereo sample consists of
  ## both right and left channels in LR ordering.
  ##
  ## Note that the number of samples is directly related to time by the
  ## following formula:
  ##
  ## ms = (samples*1000)/freq
  ##
  ## - ``desired.size`` is the size in bytes of the audio buffer, and is
  ## calculated by openAudio().
  ##
  ## - ``desired.silence`` is the value used to set the buffer to silence,
  ## and is calculated by openAudio().
  ##
  ## - ``desired.callback`` should be set to a function that will be called
  ## when the audio device is ready for more data. It is passed a pointer
  ## to the audio buffer, and the length in bytes of the audio buffer.
  ## This function usually runs in a separate thread, and so you should
  ## protect data structures that it accesses by calling lockAudio()
  ## and unlockAudio() in your code.
  ##
  ## - ``desired.userdata`` is passed as the first parameter to your callback
  ## function.
  ##
  ## The audio device starts out playing silence when it's opened, and should
  ## be enabled for playing by calling ``pauseAudio(0)`` when you are ready
  ## for your audio callback function to be called.  Since the audio driver
  ## may modify the requested size of the audio buffer, you should allocate
  ## any local mixing buffers after you open the audio device.


type
  TAudioDeviceID* = Uint32
    ## SDL Audio Device IDs.
    ##
    ## A successful call to openAudio() is always device id 1, and legacy
    ## SDL audio APIs assume you want this device ID. openAudioDevice() calls
    ## always returns devices >= 2 on success. The legacy calls are good both
    ## for backwards compatibility and when you don't care about multiple,
    ## specific, or capture devices.


proc  getNumAudioDevices*(iscapture: int): int {.cdecl, importc: "SDL_GetNumAudioDevices", dynlib: LibName.}
  ## Get the number of available devices exposed by the current driver.
  ## Only valid after a successfully initializing the audio subsystem.
  ## Returns -1 if an explicit list of devices can't be determined; this is
  ## not an error. For example, if SDL is set up to talk to a remote audio
  ## server, it can't list every one available on the Internet, but it will
  ## still allow a specific host to be specified to openAudioDevice().
  ##
  ## In many common cases, when this function returns a value <= 0, it can
  ## still successfully open the default device (nil for first argument of
  ## openAudioDevice()).


proc getAudioDeviceName*(index, iscapture: int): cstring {.cdecl, importc: "SDL_GetAudioDeviceName", dynlib: LibName.}
  ## Get the human-readable name of a specific audio device.
  ## Must be a value between 0 and (number of audio devices-1).
  ## Only valid after a successfully initializing the audio subsystem.
  ## The values returned by this function reflect the latest call to
  ## getNumAudioDevices(); recall that function to redetect available
  ## hardware.
  ##
  ## The string returned by this function is UTF-8 encoded, read-only, and
  ## managed internally. You are not to free it. If you need to keep the
  ## string for any length of time, you should make your own copy of it, as it
  ## will be invalid next time any of several other SDL functions is called.


proc openAudioDevice*(device: cstring, iscapture: int,
    desired, obtained: PAudioSpec, allowed_changes: int): TAudioDeviceID {.cdecl, importc: "SDL_OpenAudioDevice", dynlib: LibName.}
  ## Open a specific audio device. Passing in a device name of nil requests
  ## the most reasonable default (and is equivalent to calling openAudio()).
  ##
  ## The device name is a UTF-8 string reported by getAudioDeviceName(), but
  ## some drivers allow arbitrary and driver-specific strings, such as a
  ## hostname/IP address for a remote audio server, or a filename in the
  ## diskaudio driver.
  ##
  ## Return 0 on error, a valid device ID that is >= 2 on success.
  ##
  ## openAudio(), unlike this function, always acts on device ID 1.


type
  TAudioStatus* = enum ## Audio state
    AUDIO_STOPPED = 0,
    AUDIO_PLAYING,
    AUDIO_PAUSED


proc getAudioStatus*(): TAudioStatus {.cdecl, importc: "SDL_GetAudioStatus", dynlib: LibName.}
  ## Get the current audio state.


proc getAudioDeviceStatus*(dev: TAudioDeviceID): TAudioStatus {.cdecl, importc: "SDL_GetAudioDeviceStatus", dynlib: LibName.}
  ## Get the current audio state.


# Pause audio functions


proc pauseAudio*(pause_on: int) {.cdecl, importc: "SDL_PauseAudio", dynlib: LibName.}
  ## These functions pause and unpause the audio callback processing.
  ## They should be called with a parameter of 0 after opening the audio
  ## device to start playing sound.  This is so you can safely initialize
  ## data for your callback function after opening the audio device.
  ## Silence will be written to the audio device during the pause.


proc pauseAudioDevice*(dev: TAudioDeviceID, pause_on: int) {.cdecl, importc: "SDL_PauseAudioDevice", dynlib: LibName.}
  ## These functions pause and unpause the audio callback processing.
  ## They should be called with a parameter of 0 after opening the audio
  ## device to start playing sound.  This is so you can safely initialize
  ## data for your callback function after opening the audio device.
  ## Silence will be written to the audio device during the pause.


proc loadWAV_RW*(src: PRWops, freesrc: int, spec: PAudioSpec,
    audio_buf: ptr ptr byte, audio_len: ptr Uint32): PAudioSpec {.cdecl, importc: "SDL_LoadWAV_RW", dynlib: LibName.}
  ## This function loads a WAVE from the data source, automatically freeing
  ## that source if ``freesrc`` is non-zero.  For example, to load a WAVE file,
  ## you could do:
  ##
  ##
  ## loadWAV_RW(rwFromFile("sample.wav", "rb"), 1, ...)
  ##
  ##
  ## If this function succeeds, it returns the given PAudioSpec,
  ## filled with the audio data format of the wave data, and sets
  ## ``audio_buf`` to a malloc()'d buffer containing the audio data,
  ## and sets ``audio_len`` to the length of that audio buffer, in bytes.
  ## You need to free the audio buffer with freeWAV() when you are
  ## done with it.
  ##
  ## This function returns nil and sets the SDL error message if the
  ## wave file cannot be opened, uses an unknown data format, or is
  ## corrupt.  Currently raw and MS-ADPCM WAVE files are supported.


template loadWAV*(file: cstring, spec: PAudioSpec,
    audio_buf: ptr ptr byte, audio_len: ptr Uint32): PAudioSpec =
  ## Loads a WAV from a file.
  ## Compatibility convenience function.
  loadWAV_RW(rwFromFile(file, "rb"), 1, spec, audio_buf, audio_len)


proc freeWAV*(audio_buf: ptr byte) {.cdecl, importc: "SDL_FreeWAV", dynlib: LibName.}
  ## This function frees data previously allocated with loadWAV_RW()


proc buildAudioCVT*(cvt: PAudioCVT,
    src_format: TAudioFormat, src_channels: Uint8, src_rate: int,
    dst_format: TAudioFormat, dst_channels: Uint8, dst_rate: int): int {.cdecl, importc: "SDL_BuildAudioCVT", dynlib: LibName.}
  ## This function takes a source format and rate and a destination format
  ## and rate, and initializes the ``cvt`` structure with information needed
  ## by convertAudio() to convert a buffer of audio data from one format
  ## to the other.
  ##
  ## Return -1 if the format conversion is not supported, 0 if there's
  ## no conversion needed, or 1 if the audio filter is set up.


proc convertAudio*(cvt: PAudioCVT): int {.cdecl, importc: "SDL_ConvertAudio", dynlib: LibName.}
  ## Once you have initialized the ``cvt`` structure using buildAudioCVT(),
  ## created an audio buffer ``cvt.buf``, and filled it with ``cvt.len`` bytes
  ## of audio data in the source format, this function will convert it in-place
  ## to the desired format.
  ##
  ## The data conversion may expand the size of the audio data, so the buffer
  ## ``cvt.buf`` should be allocated after the ``cvt`` structure is initialized
  ## by buildAudioCVT(), and should be ``cvt.len*cvt.len_mult`` bytes long.


const
  MIX_MAXVOLUME* = 128


proc mixAudio*(dst: ptr byte, src: ptr byte,
    len: Uint32, volume: int) {.cdecl, importc: "SDL_MixAudio", dynlib: LibName.}
  ## This takes two audio buffers of the playing audio format and mixes
  ## them, performing addition, volume adjustment, and overflow clipping.
  ## The volume ranges from 0 - 128, and should be set to ``MIX_MAXVOLUME``
  ## for full audio volume.  Note this does not change hardware volume.
  ## This is provided for convenience -- you can mix your own audio data.


proc mixAudioFormat*(dst: ptr byte, src: ptr byte, format: TAudioFormat,
    len: Uint32, volume: int) {.cdecl, importc: "SDL_MixAudioFormat", dynlib: LibName.}
  ## This works like mixAudio(), but you specify the audio format instead of
  ## using the format of audio device 1. Thus it can be used when no audio
  ## device is open at all.


# Audio lock functions


proc lockAudio*() {.cdecl, importc: "SDL_LockAudio", dynlib: LibName.}
  ## The lock manipulated by these functions protects the callback function.
  ## During a lockAudio()/unlockAudio() pair, you can be guaranteed that
  ## the callback function is not running.  Do not call these from the callback
  ## function or you will cause deadlock.


proc lockAudioDevice*(dev: TAudioDeviceID) {.cdecl, importc: "SDL_LockAudioDevice", dynlib: LibName.}
  ## The lock manipulated by these functions protects the callback function.
  ## During a lockAudio()/unlockAudio() pair, you can be guaranteed that
  ## the callback function is not running.  Do not call these from the callback
  ## function or you will cause deadlock.


proc unlockAudio*() {.cdecl, importc: "SDL_UnlockAudio", dynlib: LibName.}
  ## The lock manipulated by these functions protects the callback function.
  ## During a lockAudio()/unlockAudio() pair, you can be guaranteed that
  ## the callback function is not running.  Do not call these from the callback
  ## function or you will cause deadlock.


proc unlockAudioDevice*(dev: TAudioDeviceID) {.cdecl, importc: "SDL_UnlockAudioDevice", dynlib: LibName.}
  ## The lock manipulated by these functions protects the callback function.
  ## During a lockAudio()/unlockAudio() pair, you can be guaranteed that
  ## the callback function is not running.  Do not call these from the callback
  ## function or you will cause deadlock.


proc closeAudio*() {.cdecl, importc: "SDL_CloseAudio", dynlib: LibName.}
  ## This function shuts down audio processing and closes the audio device.


proc closeAudioDevice*(dev: TAudioDeviceID) {.cdecl, importc: "SDL_CloseAudioDevice", dynlib: LibName.}
  ## This function shuts down audio processing and closes the audio device.


proc audioDeviceConnected*(dev: TAudioDeviceID): int {.cdecl, importc: "SDL_AudioDeviceConnected", dynlib: LibName.}
  ## Return 1 if audio device is still functioning, zero if not, -1 on error.

