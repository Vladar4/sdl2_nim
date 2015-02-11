#
#  SDL_mixer:  An audio mixer library based on the SDL library
#  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>
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

import
  sdl

# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 0

proc linkedVersion*(): ptr Version {.
    cdecl, importc: "Mix_Linked_Version", dynlib: SDL2_MIX_LIB.}
  ##  This function gets the version of the dynamically linked SDL_mixer
  ##  library. It should NOT be used to fill a version structure, instead you
  ##  should use the ``version()`` template.

#type
#  InitFlags* {.size: sizeof(cint).} = enum
#    INIT_FLAC = 0x00000001,
#    INIT_MOD = 0x00000002,
#    INIT_MODPLUG = 0x00000004,
#    INIT_MP3 = 0x00000008,
#    INIT_OGG = 0x00000010,
#    INIT_FLUIDSYNTH = 0x00000020

# InitFlags
const
  INIT_FLAC* = 0x00000001
  INIT_MOD* = 0x00000002
  INIT_MODPLUG* = 0x00000004
  INIT_MP3* = 0x00000008
  INIT_OGG* = 0x00000010
  INIT_FLUIDSYNTH* = 0x00000020

proc init*(flags: cint): cint {.
    cdecl, importc: "Mix_Init", dynlib: SDL2_MIX_LIB.}
  ##  Loads dynamic libraries and prepares them for use.
  ##
  ##  ``flags`` should be one or more flags from ``InitFlags`` OR'd together.
  ##
  ##  ``Return`` the flags successfully initialized, or `0` on failure.

proc quit*() {.
    cdecl, importc: "Mix_Quit", dynlib: SDL2_MIX_LIB.}
  ##  Unloads libraries loaded with ``init()``

when not declared(CHANNELS):
  const
    CHANNELS* = 8 ##  The default mixer has 8 simultaneous mixing channels

const
  DEFAULT_FREQUENCY* = 22050  ##  Good default values for a PC soundcard

when cpuEndian == littleEndian:
  const
    DEFAULT_FORMAT* = AUDIO_S16LSB
else:
  const
    DEFAULT_FORMAT* = AUDIO_S16MSB

const
  DEFAULT_CHANNELS* = 2
  MAX_VOLUME* = 128 ##  Volume of a chunk

type
  Chunk* = object ##  \
    ##  The internal format for an audio chunk
    allocated*: cint
    abuf*: ptr uint8
    alen*: uint32
    volume*: uint8  ##  Per-sample volume, 0-128

type
  Fading* {.size: sizeof(cint).} = enum ##  \
    ##  The different fading types supported 
    NO_FADING,
    FADING_OUT,
    FADING_IN

  MusicType* {.size: sizeof(cint).} = enum
    MUS_NONE,
    MUS_CMD,
    MUS_WAV,
    MUS_MOD,
    MUS_MID,
    MUS_OGG,
    MUS_MP3,
    MUS_MP3_MAD,
    MUS_FLAC,
    MUS_MODPLUG

type
  Music* = pointer ##  \
    ##  The internal format for a music chunk interpreted via mikmod

proc openAudio*(
    frequency: cint; format: uint16; channels: cint; chunksize: cint): cint {.
      cdecl, importc: "Mix_OpenAudio", dynlib: SDL2_MIX_LIB.}
  ##  Open the mixer with a certain audio format.

proc allocateChannels*(numchans: cint): cint {.
    cdecl, importc: "Mix_AllocateChannels", dynlib: SDL2_MIX_LIB.}
  ##  Dynamically change the number of channels managed by the mixer.
  ##  If decreasing the number of channels, the upper channels are stopped.
  ##
  ##  ``Return`` the new number of allocated channels.

proc querySpec*(
    frequency: ptr cint; format: ptr uint16; channels: ptr cint): cint {.
      cdecl, importc: "Mix_QuerySpec", dynlib: SDL2_MIX_LIB.}
  ##  Find out what the actual audio device parameters are.
  ##
  ##  ``Return`` `1` if the audio has been opened, `0` otherwise.

proc loadWAV_RW*(src: ptr RWops; freesrc: cint): ptr Chunk {.
    cdecl, importc: "Mix_LoadWAV_RW", dynlib: SDL2_MIX_LIB.}
  ##  Load a wave file or a music (.mod .s3m .it .xm) file.

template loadWAV*(file: expr): expr =
  loadWAV_RW(rwFromFile(file, "rb"), 1)

proc loadMUS*(file: cstring): Music {.
    cdecl, importc: "Mix_LoadMUS", dynlib: SDL2_MIX_LIB.}

proc loadMUS_RW*(src: ptr RWops; freesrc: cint): Music {.
    cdecl, importc: "Mix_LoadMUS_RW", dynlib: SDL2_MIX_LIB.}
  ##  Load a music file from an RWop object (Ogg and MikMod specific currently).
  ##
  ##  Matt Campbell (matt@campbellhome.dhs.org) April 2000

proc loadMUSType_RW*(src: ptr RWops; kind: MusicType; freesrc: cint): Music {.
    cdecl, importc: "Mix_LoadMUSType_RW", dynlib: SDL2_MIX_LIB.}
  ##  Load a music file from an RWop object assuming a specific format.

proc quickLoad_WAV*(mem: ptr uint8): ptr Chunk {.
    cdecl, importc: "Mix_QuickLoad_WAV", dynlib: SDL2_MIX_LIB.}
  ##  Load a wave file of the mixer format from a memory buffer.

proc quickLoad_RAW*(mem: ptr uint8; len: uint32): ptr Chunk {.
    cdecl, importc: "Mix_QuickLoad_RAW", dynlib: SDL2_MIX_LIB.}
  ##  Load raw audio data of the mixer format from a memory buffer.

proc freeChunk*(chunk: ptr Chunk) {.
    cdecl, importc: "Mix_FreeChunk", dynlib: SDL2_MIX_LIB.}
  ##  Free an audio chunk previously loaded.

proc freeMusic*(music: Music) {.
    cdecl, importc: "Mix_FreeMusic", dynlib: SDL2_MIX_LIB.}

proc getNumChunkDecoders*(): cint {.
    cdecl, importc: "Mix_GetNumChunkDecoders", dynlib: SDL2_MIX_LIB.}
  ##  Get a list of chunk/music decoders that this build of SDL_mixer provides.
  ##  This list can change between builds AND runs of the program, if external
  ##  libraries that add functionality become available.
  ##  You must successfully call ``openAudio()`` before calling these functions.
  ##  This API is only available in SDL_mixer 1.2.9 and later.
  ##
  ##  Usage:
  ##
  ##    var i: cint
  ##
  ##    const total: cint = getNumChunkDecoders()
  ##
  ##    for i in 0..total-1:
  ##
  ##      echo "Supported chunk decoder: [$1]" % [getChunkDecoder(i)]
  ##
  ##  Appearing in this list doesn't promise your specific audio file will
  ##  decode...but it's handy to know if you have, say, a functioning Timidity
  ##  install.
  ##
  ##  These return values are static, read-only data; do not modify or free it.
  ##  The pointers remain valid until you call ``closeAudio()``.

proc getChunkDecoder*(index: cint): cstring {.
    cdecl, importc: "Mix_GetChunkDecoder", dynlib: SDL2_MIX_LIB.}

proc getNumMusicDecoders*(): cint {.
    cdecl, importc: "Mix_GetNumMusicDecoders", dynlib: SDL2_MIX_LIB.}

proc getMusicDecoder*(index: cint): cstring {.
    cdecl, importc: "Mix_GetMusicDecoder", dynlib: SDL2_MIX_LIB.}

proc getMusicType*(music: Music): MusicType {.
    cdecl, importc: "Mix_GetMusicType", dynlib: SDL2_MIX_LIB.}
  ##  Find out the music format of a mixer music, or the currently playing
  ##  music, if ``music`` is `nil`.

proc setPostMix*(
    mix_func: proc (udata: pointer; stream: ptr uint8; len: cint) {.cdecl.};
    arg: pointer) {.
      cdecl, importc: "Mix_SetPostMix", dynlib: SDL2_MIX_LIB.}
  ##  Set a function that is called after all mixing is performed.
  ##  This can be used to provide real-time visual display of the audio stream
  ##  or add a custom mixer filter for the stream data.

proc hookMusic*(
    mix_func: proc (udata: pointer; stream: ptr uint8; len: cint) {.cdecl.};
    arg: pointer) {.
      cdecl, importc: "Mix_HookMusic", dynlib: SDL2_MIX_LIB.}
  ##  Add your own music player or additional mixer function.
  ##  If 'mix_func' is NULL, the default music player is re-enabled.

proc hookMusicFinished*(music_finished: proc () {.cdecl.}) {.
    cdecl, importc: "Mix_HookMusicFinished", dynlib: SDL2_MIX_LIB.}
  ##  Add your own callback when the music has finished playing.
  ##  This callback is only called if the music finishes naturally.

proc getMusicHookData*(): pointer {.
    cdecl, importc: "Mix_GetMusicHookData", dynlib: SDL2_MIX_LIB.}
  ##  Get a pointer to the user data for the current music hook.

proc channelFinished*(channel_finished: proc (channel: cint) {.cdecl.}) {.
    cdecl, importc: "Mix_ChannelFinished", dynlib: SDL2_MIX_LIB.}
  ##  Add your own callback when a channel has finished playing. `nil`
  ##  to disable callback. The callback may be called from the mixer's audio
  ##  callback or it could be called as a result of ``haltChannel()``, etc.
  ##  do not call ``lockAudio()`` from this callback; you will either be
  ##  inside the audio callback, or SDL_mixer will explicitly lock the audio
  ##  before calling your callback.

# Special Effects API by ryan c. gordon. (icculus@icculus.org)

const
  CHANNEL_POST* = - 2

type
  EffectFunc_t* = proc (
      chan: cint; stream: pointer; len: cint; udata: pointer) {.cdecl.} ##  \
    ##  This is the format of a special effect callback:
    ##
    ##    myeffect(chan: cint; stream: pointer; len: cint; udata: pointer)
    ##
    ##    ``chan`` is the channel number that your effect is affecting.
    ##
    ##    ``stream`` is the buffer of data to work upon.
    ##
    ##    ``len`` is the size of ``stream``.
    ##
    ##    ``udata`` is a user-defined bit of data,
    ##    which you pass as the last arg of ``registerEffect()``,
    ##    and is passed back unmolested to your callback.
    ##
    ##  Your effect changes the contents of ``stream`` based on whatever
    ##  parameters are significant, or just leaves it be, if you prefer.
    ##  You can do whatever you like to the buffer, though, and it will
    ##  continue in its changed state down the mixing pipeline, through
    ##  any other effect functions, then finally to be mixed with the rest
    ##  of the channels and music for the final output stream.
    ##
    ##  ``DO NOT EVER`` call ``lockAudio()`` from your callback function!


type 
  EffectDone_t* = proc (chan: cint; udata: pointer) {.cdecl.} ##  \
    ##  This is a callback that signifies that a channel has finished all its
    ##  loops and has completed playback. This gets called if the buffer
    ##  plays out normally, or if you call ``haltChannel()``, implicitly stop
    ##  a channel via ``allocateChannels()``, or unregister a callback while
    ##  it's still playing.
    ##
    ##  ``DO NOT EVER`` call ``lockAudio()`` from your callback function!

proc registerEffect*(
    chan: cint; f: EffectFunc_t; d: EffectDone_t; arg: pointer): cint {.
      cdecl, importc: "Mix_RegisterEffect", dynlib: SDL2_MIX_LIB.}
  ##  Register a special effect function. At mixing time, the channel data is
  ##  copied into a buffer and passed through each registered effect function.
  ##  After it passes through all the functions, it is mixed into the final
  ##  output stream. The copy to buffer is performed once, then each effect
  ##  function performs on the output of the previous effect. Understand that
  ##  this extra copy to a buffer is not performed if there are no effects
  ##  registered for a given chunk, which saves CPU cycles, and any given
  ##  effect will be extra cycles, too, so it is crucial that your code run
  ##  fast. Also note that the data that your function is given is in the
  ##  format of the sound device, and not the format you gave to
  ##  ``openAudio()``, although they may in reality be the same. This is an
  ##  unfortunate but necessary speed concern. Use ``querySpec()`` to determine
  ##  if you can handle the data before you register your effect, and take
  ##  appropriate actions.
  ##
  ##  You may also specify a callback (``EffectDone_t``) that is called when
  ##  the channel finishes playing. This gives you a more fine-grained control
  ##  than ``channelFinished()``, in case you need to free effect-specific
  ##  resources, etc. If you don't need this, you can specify `nil`.
  ##
  ##  You may set the callbacks before or after calling ``playChannel()``.
  ##
  ##  Things like ``setPanning()`` are just internal special effect functions,
  ##  so if you are using that, you've already incurred the overhead of a copy
  ##  to a separate buffer, and that these effects will be in the queue with
  ##  any functions you've registered. The list of registered effects for a
  ##  channel is reset when a chunk finishes playing, so you need to explicitly
  ##  set them with each call to ``playChannel()``.
  ##
  ##  You may also register a special effect function that is to be run after
  ##  final mixing occurs. The rules for these callbacks are identical to those
  ##  in ``registerEffect()``, but they are run after all the channels and the
  ##  music have been mixed into a single stream, whereas channel-specific
  ##  effects run on a given channel before any other mixing occurs. These
  ##  global effect callbacks are call "posteffects". Posteffects only have
  ##  their ``EffectDone_t`` function called when they are unregistered (since
  ##  the main output stream is never "done" in the same sense as a channel).
  ##  You must unregister them manually when you've had enough. Your callback
  ##  will be told that the channel being mixed is (`CHANNEL_POST`) if the
  ##  processing is considered a posteffect.
  ##
  ##  After all these effects have finished processing, the callback registered
  ##  through ``setPostMix()`` runs, and then the stream goes to the audio
  ##  device.
  ##
  ##  ``DO NOT EVER`` call ``lockAudio()`` from your callback function!
  ##
  ##  ``Return`` `0` if error (no such channel), nonzero if added.
  ##
  ##  Error messages can be retrieved from ``getError()``.

proc unregisterEffect*(channel: cint; f: EffectFunc_t): cint {.
    cdecl, importc: "Mix_UnregisterEffect", dynlib: SDL2_MIX_LIB.}
  ##  You may not need to call this explicitly, unless you need to stop an
  ##  effect from processing in the middle of a chunk's playback.
  ##
  ##  Posteffects are never implicitly unregistered as they are for channels,
  ##  but they may be explicitly unregistered through this function by
  ##  specifying `CHANNEL_POST` for a channel.
  ##
  ##  ``Return`` `0` if error (no such channel or effect), nonzero if removed.
  ##
  ##  Error messages can be retrieved from ``getError()``.

proc unregisterAllEffects*(channel: cint): cint {.cdecl, 
    importc: "Mix_UnregisterAllEffects", dynlib: SDL2_MIX_LIB.}
  ##  You may not need to call this explicitly, unless you need to stop all
  ##  effects from processing in the middle of a chunk's playback. Note that
  ##  this will also shut off some internal effect processing, since
  ##  ``setPanning()`` and others may use this API under the hood. This is
  ##  called internally when a channel completes playback.
  ##
  ##  Posteffects are never implicitly unregistered as they are for channels,
  ##  but they may be explicitly unregistered through this function by
  ##  specifying `CHANNEL_POST` for a channel.
  ##
  ##  ``Return`` `0` if error (no such channel), nonzero if all effects removed.
  ##
  ##  Error messages can be retrieved from ``getError()``.

const
  EFFECTSMAXSPEED* = "MIX_EFFECTSMAXSPEED"  ##  \
    ##  These are the internally-defined mixing effects. They use the same
    ##  API that effects defined in the application use, but are provided here
    ##  as a convenience. Some effects can reduce their quality or use more
    ##  memory in the name of speed; to enable this, make sure the environment
    ##  variable `EFFECTSMAXSPEED` (see above) is defined before you call
    ##  ``openAudio()``.

proc setPanning*(channel: cint; left: uint8; right: uint8): cint {.
    cdecl, importc: "Mix_SetPanning", dynlib: SDL2_MIX_LIB.}
  ##  Set the panning of a ``channel``.
  ##
  ##  The ``left`` and ``right`` channels are specified as integers
  ##  between `0` and `255`, quietest to loudest, respectively.
  ##
  ##  Technically, this is just individual volume control for a sample with
  ##  two (stereo) channels, so it can be used for more than just panning.
  ##  If you want real panning, call it like this:
  ##
  ##    setPanning(channel, left, 255 - left)
  ##
  ##  ...which isn't so hard.
  ##
  ##  Setting ``channel`` to `CHANNEL_POST` registers this as a posteffect, and
  ##  the panning will be done to the final mixed stream before passing it on
  ##  to the audio device.
  ##
  ##  This uses the ``registerEffect()`` API internally, and returns without
  ##  registering the effect function if the audio device is not configured
  ##  for stereo output. Setting both ``left`` and ``right`` to `255` causes
  ##  this effect to be unregistered, since that is the data's normal state.
  ##
  ##  ``Return`` `0` if error (no such channel or ``registerEffect()`` fails),
  ##  nonzero if panning effect enabled. Note that an audio device in mono
  ##  mode is a no-op, but this call will return successful in that case.
  ##
  ##  Error messages can be retrieved from ``getError()``.

proc setPosition*(channel: cint; angle: int16; distance: uint8): cint {.
    cdecl, importc: "Mix_SetPosition", dynlib: SDL2_MIX_LIB.}
  ##  Set the position of a ``channel``.
  ##
  ##  ``angle`` is an integer from `0` to `360`, that specifies the location
  ##  of the sound in relation to the listener. ``angle`` will be reduced as
  ##  neccesary (`540` becomes `180` degrees, `-100` becomes `260`).
  ##  Angle `0` is due north, and rotates clockwise as the value increases.
  ##  For efficiency, the precision of this effect may be limited
  ##  (angles `1` through `7` might all produce the same effect,
  ##  `8` through `15` are equal, etc).
  ##
  ##  ``distance`` is an integer between `0` and `255` that specifies the space
  ##  between the sound and the listener. The larger the number, the further
  ##  away the sound is. Using `255` does not guarantee that the channel will
  ##  be culled from the mixing process or be completely silent.
  ##  For efficiency, the precision of this effect may be limited
  ##  (distance `0` through `5` might all produce the same effect,
  ##  `6` through `10` are equal, etc).
  ##
  ##  Setting ``angle`` and ``distance`` to `0` unregisters this effect,
  ##  since the data would be unchanged.
  ##
  ##  If you need more precise positional audio, consider using OpenAL for
  ##  spatialized effects instead of SDL_mixer. This is only meant to be a
  ##  basic effect for simple "3D" games.
  ##
  ##  If the audio device is configured for mono output, then you won't get
  ##  any effectiveness from the ``angle``; however, distance attenuation on
  ##  the channel will still occur. While this effect will function with stereo
  ##  voices, it makes more sense to use voices with only one channel of sound,
  ##  so when they are mixed through this effect, the positioning will sound
  ##  correct. You can convert them to mono through SDL before giving them to
  ##  the mixer in the first place if you like.
  ##
  ##  Setting ``channel`` to `CHANNEL_POST` registers this as a posteffect, and
  ##  the positioning will be done to the final mixed stream before passing it
  ##  on to the audio device.
  ##
  ##  This is a convenience wrapper over ``setDistance()`` and ``setPanning()``.
  ##
  ##  ``Return`` `0` if error (no such channel or ``registerEffect()`` fails),
  ##  nonzero if position effect is enabled.
  ##
  ##  Error messages can be retrieved from ``getError()``.

proc setDistance*(channel: cint; distance: uint8): cint {.
    cdecl, importc: "Mix_SetDistance", dynlib: SDL2_MIX_LIB.}
  ##  Set the ``distance`` of a ``channel``.
  ##
  ##  ``distance`` is an integer from `0` to `255` that specifies the location
  ##  of the sound in relation to the listener. Distance `0` is overlapping the
  ##  listener, and `255` is as far away as possible. A distance of `255` does
  ##  not guarantee silence; in such a case, you might want to try changing the
  ##  chunk's volume, or just cull the sample from the mixing process with
  ##  ``haltChannel()``.
  ##
  ##  For efficiency, the precision of this effect may be limited
  ##  (distances `1` through `7` might all produce the same effect,
  ##  `8` through `15` are equal, etc).
  ##
  ##  ``distance`` is an integer between `0` and `255` that specifies the space
  ##  between the sound and the listener. The larger the number, the further
  ##  away the sound is.
  ##
  ##  Setting ``distance`` to `0` unregisters this effect,
  ##  since the data would be unchanged.
  ##
  ##  If you need more precise positional audio, consider using OpenAL for
  ##  spatialized effects instead of SDL_mixer. This is only meant to be a
  ##  basic effect for simple "3D" games.
  ##
  ##  Setting ``channel`` to `CHANNEL_POST` registers this as a posteffect, and
  ##  the distance attenuation will be done to the final mixed stream before
  ##  passing it on to the audio device.
  ##
  ##  This uses the ``registerEffect()`` API internally.
  ##
  ##  ``Return`` `0` if error (no such channel or ``registerEffect()`` fails),
  ##  nonzero if position effect is enabled.
  ##
  ##  Error messages can be retrieved from ``getError()``.

when false:
  #  !!! FIXME : Haven't implemented, since the effect goes past the
  #             end of the sound buffer. Will have to think about this.
  #               --ryan.
  proc setReverb*(channel: cint; echo: uint8): cint {.
      cdecl, importc: "Mix_SetReverb", dynlib: SDL2_MIX_LIB.}
    ##  Causes an echo effect to be mixed into a sound.
    ##
    ##  ``echo`` is the amount of echo to mix.
    ##  `0` is no echo, `255` is infinite (and probably not what you want).
    ##
    ##  Setting ``channel`` to `CHANNEL_POST` registers this as a posteffect,
    ##  and the reverbing will be done to the final mixed stream before passing
    ##  it on to the audio device.
    ##
    ##  This uses the ``registerEffect()`` API internally.
    ##
    ##  If you specify an echo of zero, the effect is unregistered,
    ##  as the data is already in that state.
    ##
    ##  ``Returns`` `0` if error (no such channel or ``registerEffect()``
    ##  fails), nonzero if reversing effect is enabled.
    ##
    ##  Error messages can be retrieved from ``getError()``.

proc setReverseStereo*(channel: cint; flip: cint): cint {.
    cdecl, importc: "Mix_SetReverseStereo", dynlib: SDL2_MIX_LIB.}
  ##  Causes a ``channel`` to reverse its stereo. This is handy if the user has
  ##  his speakers hooked up backwards, or you would like to have a minor bit
  ##  of psychedelia in your sound code.  :)
  ##
  ##  Calling this function with ``flip`` set to non-zero reverses the chunks's
  ##  usual channels. If ``flip`` is zero, the effect is unregistered.
  ##
  ##  This uses the ``registerEffect()`` API internally, and thus is probably
  ##  more CPU intensive than having the user just plug in his speakers
  ##  correctly. ``setReverseStereo()`` returns without registering the effect
  ##  function if the audio device is not configured for stereo output.
  ##
  ##  If you specify `CHANNEL_POST` for ``channel``, then this the effect is
  ##  used on the final mixed stream before sending it on to the audio device
  ##  (a posteffect).
  ##
  ##  ``Return`` `0` if error (no such channel or ``registerEffect()`` fails),
  ##  nonzero if reversing effect is enabled. Note that an audio device in mono
  ##  mode is a no-op, but this call will return successful in that case.
  ##
  ##  Error messages can be retrieved from ``getError()``.

# end of effects API. --ryan.

proc reserveChannels*(num: cint): cint {.
    cdecl, importc: "Mix_ReserveChannels", dynlib: SDL2_MIX_LIB.}
  ##  Reserve the first channels (`0` -> `n-1`) for the application,
  ##  i.e. don't allocate them dynamically to the next sample if requested
  ##  with a `-1` value below.
  ##
  ##  ``Return`` the number of reserved channels.

# Channel grouping functions

proc groupChannel*(which: cint; tag: cint): cint {.
    cdecl, importc: "Mix_GroupChannel", dynlib: SDL2_MIX_LIB.}
  ##  Attach a ``tag`` to a ``channel``. A tag can be assigned to several
  ##  mixer channels, to form groups of channels.
  ##
  ##  If ``tag`` is `-1`, the tag is removed (actually `-1` is the tag used to
  ##  represent the group of all the channels).
  ##
  ##  ``Return`` `true` if everything was OK.

proc groupChannels*(ch_from: cint; ch_to: cint; tag: cint): cint {.
    cdecl, importc: "Mix_GroupChannels", dynlib: SDL2_MIX_LIB.}
  ##  Assign several consecutive channels to a group.

proc groupAvailable*(tag: cint): cint {.
    cdecl, importc: "Mix_GroupAvailable", dynlib: SDL2_MIX_LIB.}
  ##  Finds the first available channel in a group of channels,
  ##  returning `-1` if none are available.

proc groupCount*(tag: cint): cint {.
    cdecl, importc: "Mix_GroupCount", dynlib: SDL2_MIX_LIB.}
  ##  ``Return`` the number of channels in a group. This is also a subtle
  ##  way to get the total number of channels when ``tag`` is `-1`.

proc groupOldest*(tag: cint): cint {.
    cdecl, importc: "Mix_GroupOldest", dynlib: SDL2_MIX_LIB.}
  ##  Finds the "oldest" sample playing in a group of channels.

proc groupNewer*(tag: cint): cint {.
    cdecl, importc: "Mix_GroupNewer", dynlib: SDL2_MIX_LIB.}
  ##  Finds the "most recent" (i.e. last) sample playing in a group of channels.

template playChannel*(channel, chunk, loops: expr): expr =  ##  \
  ##  Play an audio chunk on a specific channel.
  ##
  ##  If the specified channel is `-1`, play on the first free channel.
  ##
  ##  If ``loops`` is greater than zero, loop the sound that many times.
  ##
  ##  If ``loops`` is `-1`, loop inifinitely (~65000 times).
  ##
  ##  ``Return`` which channel was used to play the sound.
  playChannelTimed(channel, chunk, loops, - 1)

proc playChannelTimed*(
    channel: cint; chunk: ptr Chunk; loops: cint; ticks: cint): cint {.
      cdecl, importc: "Mix_PlayChannelTimed", dynlib: SDL2_MIX_LIB.}
  ##  The same as above, but the sound is played at most ``ticks`` milliseconds.

proc playMusic*(music: Music; loops: cint): cint {.
    cdecl, importc: "Mix_PlayMusic", dynlib: SDL2_MIX_LIB.}

proc fadeInMusic*(music: Music; loops: cint; ms: cint): cint {.
    cdecl, importc: "Mix_FadeInMusic", dynlib: SDL2_MIX_LIB.}
  ##  Fade in music or a channel over ``ms`` milliseconds,
  ##  same semantics as the "play" functions.

proc fadeInMusicPos*(
      music: Music; loops: cint; ms: cint; position: cdouble): cint {.
        cdecl, importc: "Mix_FadeInMusicPos", dynlib: SDL2_MIX_LIB.}

template fadeInChannel*(channel, chunk, loops, ms: expr): expr =
  fadeInChannelTimed(channel, chunk, loops, ms, - 1)

proc fadeInChannelTimed*(
  channel: cint; chunk: ptr Chunk; loops: cint; ms: cint; ticks: cint): cint {.
    cdecl, importc: "Mix_FadeInChannelTimed", dynlib: SDL2_MIX_LIB.}

proc volume*(channel: cint; volume: cint): cint {.
    cdecl, importc: "Mix_Volume", dynlib: SDL2_MIX_LIB.}
  ##  Set the ``volume`` in the range of `0`-`128`
  ##  of a specific channel or chunk.
  ##
  ##  If the specified ``channel`` is ``-1``, set volume for all channels.
  ##
  ##  ``Return`` the original volume.
  ##
  ##  If the specified ``volume`` is `-1`, just return the current volume.

proc volumeChunk*(chunk: ptr Chunk; volume: cint): cint {.
    cdecl, importc: "Mix_VolumeChunk", dynlib: SDL2_MIX_LIB.}

proc volumeMusic*(volume: cint): cint {.
    cdecl, importc: "Mix_VolumeMusic", dynlib: SDL2_MIX_LIB.}

proc haltChannel*(channel: cint): cint {.
    cdecl, importc: "Mix_HaltChannel", dynlib: SDL2_MIX_LIB.}
  ##  Halt playing of a particular channel.

proc haltGroup*(tag: cint): cint {.
    cdecl, importc: "Mix_HaltGroup", dynlib: SDL2_MIX_LIB.}

proc haltMusic*(): cint {.
    cdecl, importc: "Mix_HaltMusic", dynlib: SDL2_MIX_LIB.}

proc expireChannel*(channel: cint; ticks: cint): cint {.
    cdecl, importc: "Mix_ExpireChannel", dynlib: SDL2_MIX_LIB.}
  ##  Change the expiration delay for a particular channel.
  ##
  ##  The sample will stop playing after the ``ticks`` milliseconds have
  ##  elapsed, or remove the expiration if ``ticks`` is `-1`.

proc fadeOutChannel*(which: cint; ms: cint): cint {.
    cdecl, importc: "Mix_FadeOutChannel", dynlib: SDL2_MIX_LIB.}
  ##  Halt a channel, fading it out progressively till it's silent.
  ##
  ##  The ``ms`` parameter indicates the number of milliseconds the fading
  ##  will take.

proc fadeOutGroup*(tag: cint; ms: cint): cint {.
    cdecl, importc: "Mix_FadeOutGroup", dynlib: SDL2_MIX_LIB.}

proc fadeOutMusic*(ms: cint): cint {.
    cdecl, importc: "Mix_FadeOutMusic", dynlib: SDL2_MIX_LIB.}

proc fadingMusic*(): Fading {.
    cdecl, importc: "Mix_FadingMusic", dynlib: SDL2_MIX_LIB.}
  ##  Query the fading status of a channel.

proc fadingChannel*(which: cint): Fading {.
    cdecl, importc: "Mix_FadingChannel", dynlib: SDL2_MIX_LIB.}

proc pause*(channel: cint) {.
    cdecl, importc: "Mix_Pause", dynlib: SDL2_MIX_LIB.}
  ##  Pause a particular channel.

proc resume*(channel: cint) {.
    cdecl, importc: "Mix_Resume", dynlib: SDL2_MIX_LIB.}
  ##  Resume a particular channel.

proc paused*(channel: cint): cint {.
    cdecl, importc: "Mix_Paused", dynlib: SDL2_MIX_LIB.}

proc pauseMusic*() {.
    cdecl, importc: "Mix_PauseMusic", dynlib: SDL2_MIX_LIB.}
  ##  Pause the music stream.

proc resumeMusic*() {.
    cdecl, importc: "Mix_ResumeMusic", dynlib: SDL2_MIX_LIB.}
  ##  Resume the music stream.

proc rewindMusic*() {.
    cdecl, importc: "Mix_RewindMusic", dynlib: SDL2_MIX_LIB.}

proc pausedMusic*(): cint {.
  cdecl, importc: "Mix_PausedMusic", dynlib: SDL2_MIX_LIB.}

proc setMusicPosition*(position: cdouble): cint {.
    cdecl, importc: "Mix_SetMusicPosition", dynlib: SDL2_MIX_LIB.}
  ##  Set the current ``position`` in the music stream.
  ##
  ##  ``Return`` `0` if successful, or `-1` if it failed or isn't implemented.
  ##
  ##  This function is only implemented for MOD music formats (set pattern
  ##  order number) and for OGG, FLAC, MP3_MAD, and MODPLUG music (set
  ##  position in seconds), at the moment.

proc playing*(channel: cint): cint {.
    cdecl, importc: "Mix_Playing", dynlib: SDL2_MIX_LIB.}
  ##  Check the status of a specific ``channel``.
  ##
  ##  If the specified ``channel`` is `-1`, check all channels.

proc playingMusic*(): cint {.
    cdecl, importc: "Mix_PlayingMusic", dynlib: SDL2_MIX_LIB.}

proc setMusicCMD*(command: cstring): cint {.
    cdecl, importc: "Mix_SetMusicCMD", dynlib: SDL2_MIX_LIB.}
  ##  Stop music and set external music playback command.

proc setSynchroValue*(value: cint): cint {.
    cdecl, importc: "Mix_SetSynchroValue", dynlib: SDL2_MIX_LIB.}
  ##  Synchro value is set by MikMod from modules while playing.

proc getSynchroValue*(): cint {.
    cdecl, importc: "Mix_GetSynchroValue", dynlib: SDL2_MIX_LIB.}

proc setSoundFonts*(paths: cstring): cint {.
    cdecl, importc: "Mix_SetSoundFonts", dynlib: SDL2_MIX_LIB.}
  ##  Set SoundFonts paths to use by supported MIDI backends.

proc getSoundFonts*(): cstring {.
    cdecl, importc: "Mix_GetSoundFonts", dynlib: SDL2_MIX_LIB.}
  ##  Get SoundFonts paths to use by supported MIDI backends.

proc eachSoundFont*(
    function: proc (a2: cstring; a3: pointer): cint {.cdecl.};
    data: pointer): cint {.
      cdecl, importc: "Mix_EachSoundFont", dynlib: SDL2_MIX_LIB.}
  ##  Iterate SoundFonts paths to use by supported MIDI backends.

proc getChunk*(channel: cint): ptr Chunk {.
    cdecl, importc: "Mix_GetChunk", dynlib: SDL2_MIX_LIB.}
  ##  Get the ``Chunk`` currently associated with a mixer ``channel``.
  ##
  ##  ``Return`` `nil` if it's an invalid channel,
  ##  or there's no chunk associated.

proc closeAudio*() {.
    cdecl, importc: "Mix_CloseAudio", dynlib: SDL2_MIX_LIB.}
  ##  Close the mixer, halting all playing audio.
