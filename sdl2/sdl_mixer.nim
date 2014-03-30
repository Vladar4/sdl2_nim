#
# SDL_mixer:  An audio mixer library based on the SDL library
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


import
  sdl, unsigned


# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 0

template version*(x: PVersion) =
  ## This template can be used to fill a version structure with the compile-time
  ## version of the mixer library.
  x.major = MAJOR_VERSION
  x.minor = MINOR_VERSION
  x.patch = PATCHLEVEL


template version*(x: TVersion) =
  version(addr(x))


proc linkedVersion*(): PVersion {.cdecl, importc: "Mix_Linked_Version", dynlib: LibMixName.}
  ## This function gets the version of the dynamically linked mixer library.
  ## it should NOT be used to fill a version structure, instead you should
  ## use the version() template.


# MixInitFlags
const
    INIT_FLAC*       = 0x00000001
    INIT_MOD*        = 0x00000002
    INIT_MODPLUG*    = 0x00000004
    INIT_MP3*        = 0x00000008
    INIT_OGG*        = 0x00000010
    INIT_FLUIDSYNTH* = 0x00000020


proc init*(flags: int): int {.cdecl, importc: "Mix_Init", dynlib: LibMixName.}
  ## Loads dynamic libraries and prepares them for use. Flags should be
  ## one or more flags from TMixInitFlags OR'd together.
  ## It returns the flags successfully initialized, or 0 on failure.


proc quit*() {.cdecl, importc: "Mix_Quit", dynlib: LibMixName.}
  ## Unloads libraries loaded with init


when not defined(CHANNELS):
  const
    CHANNELS* = 8 ## The default mixer has 8 simultaneous mixing channels


# Good default values for a PC soundcard

const
  DEFAULT_FREQUENCY* = 22050


when cpuEndian == littleEndian:
  const
    DEFAULT_FORMAT* = AUDIO_S16LSB
else:
  const
    DEFAULT_FORMAT* = AUDIO_S16MSB


const
  DEFAULT_CHANNELS* = 2
  MAX_VOLUME* = 128 ## Volume of a chunk


type

  PChunk* = ptr TChunk
  TChunk*{.pure.} = object
    ## The internal format for an audio chunk
    allocated*: int32
    abuf*: ptr byte
    alen*: Uint32
    volume*: Uint8 ## Per-sample volume, 0-128


  TFading* = enum ## The different fading types supported
    NO_FADING,
    FADING_OUT,
    FADING_IN


  TMusicKind* = enum
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


  PMusic* = pointer
    ## The internal format for a music chunk interpreted via mikmod


proc openAudio*(frequency: int, format: Uint16, channels: int, chunksize: int): int {.cdecl, importc: "Mix_OpenAudio", dynlib: LibMixName.}
  ## Open the mixer with a certain audio format


proc allocateChannels*(numchans: int): int {.cdecl, importc: "Mix_AllocateChannels", dynlib: LibMixName.}
  ## Dynamically change the number of channels managed by the mixer.
  ## If decreasing the number of channels, the upper channels are
  ## stopped.
  ##
  ## This function returns the new number of allocated channels.


proc querySpec*(frequency: ptr int, format: ptr Uint16, channels: ptr int): int {.cdecl, importc: "Mix_QuerySpec", dynlib: LibMixName.}
  ## Find out what the actual audio device parameters are.
  ## This function returns 1 if the audio has been opened, 0 otherwise.


proc loadWAV_RW*(src: PRWops, freesrc: int): PChunk {.cdecl, importc: "Mix_LoadWAV_RW", dynlib: LibMixName.}
  ## Load a wave file or a music (.mod .s3m .it .xm) file


template loadWAV*(file: cstring): PChunk =
  loadWAV_RW(rwFromFile(file, "rb"), 1)


proc loadMUS*(file: cstring): PMusic {.cdecl, importc: "Mix_LoadMUS", dynlib: LibMixName.}


proc loadMUS_RW*(src: PRWops, freesrc: int): PMusic {.cdecl, importc: "Mix_LoadMUS_RW", dynlib: LibMixName.}
  ## Load a music file from an PRWops object (Ogg and MikMod specific currently)
  ## Matt Campbell (matt@campbellhome.dhs.org) April 2000


proc loadMUSType_RW*(src: PRWops, kind: TMusicKind, freesrc: int): PMusic {.cdecl, importc: "Mix_LoadMUSType_RW", dynlib: LibMixName.}
  ## Load a music file from an PRWops object assuming a specific format


proc quickLoad_WAV*(mem: ptr byte): PChunk {.cdecl, importc: "Mix_QuickLoad_WAV", dynlib: LibMixName.}
  ## Load a wave file of the mixer format from a memory buffer


proc quickLoad_RAW*(mem: ptr byte, len: Uint32): PChunk {.cdecl, importc: "Mix_QuickLoad_RAW", dynlib: LibMixName.}
  ## Load raw audio data of the mixer format from a memory buffer


proc freeChunk*(chunk: PChunk) {.cdecl, importc: "Mix_FreeChunk", dynlib: LibMixName.}
  ## Free an audio chunk previously loaded

proc freeMusic*(music: PMusic) {.cdecl, importc: "Mix_FreeMusic", dynlib: LibMixName.}
  ## Free a music file previously loaded


proc getNumChunkDecoders*(): int {.cdecl, importc: "Mix_GetNumChunkDecoders", dynlib: LibMixName.}


proc getChunkDecoder*(index: int): cstring {.cdecl, importc: "Mix_GetChunkDecoder", dynlib: LibMixName.}
  ## Get a list of chunk/music decoders that this build of SDL_mixer provides.
  ## This list can change between builds AND runs of the program, if external
  ## libraries that add functionality become available.
  ## You must successfully call openAudio() before calling these functions.
  ## This API is only available in SDL_mixer 1.2.9 and later.
  ##
  ##
  ## # usage...
  ##
  ## var i: int
  ##
  ## const
  ##
  ##   total: int = getNumChunkDecoders()
  ##
  ## for i in 0..total-1:
  ##
  ##   echo("Supported chunk decoder: [$1]" % [getChunkDecoder(i)])
  ##
  ##
  ## Appearing in this list doesn't promise your specific audio file will
  ## decode...but it's handy to know if you have, say, a functioning Timidity
  ## install.
  ##
  ## These return values are static, read-only data; do not modify or free it.
  ## The pointers remain valid until you call closeAudio().


proc getNumMusicDecoders*(): int {.cdecl, importc: "Mix_GetNumMusicDecoders", dynlib: LibMixName.}


proc getMusicDecoder*(index: int): cstring {.cdecl, importc: "Mix_GetMusicDecoder", dynlib: LibMixName.}


proc getMusicType*(music: PMusic): TMusicKind {.cdecl, importc: "Mix_GetMusicType", dynlib: LibMixName.}
  ## Find out the music format of a mixer music, or the currently playing
  ## music, if ``music`` is nil.


type
  PMixFunc* = proc(udata: pointer, stream: ptr byte, len: int)


proc setPostMix*(mix_func: PMixFunc, arg: pointer) {.cdecl, importc: "Mix_SetPostMix", dynlib: LibMixName.}
  ## Set a function that is called after all mixing is performed.
  ## This can be used to provide real-time visual display of the audio stream
  ## or add a custom mixer filter for the stream data.


proc hookMusic*(mix_func: PMixFunc, arg: pointer) {.cdecl, importc: "Mix_HookMusic", dynlib: LibMixName.}
  ## Add your own music player or additional mixer function.
  ## If ``mix_func`` is nil, the default music player is re-enabled.


proc hookMusicFinished*(music_finished: proc()) {.cdecl, importc: "Mix_HookMusicFinished", dynlib: LibMixName.}
  ## Add your own callback when the music has finished playing.
  ## This callback is only called if the music finishes naturally.


proc getMusicHookData*(): pointer {.cdecl, importc: "Mix_GetMusicHookData", dynlib: LibMixName.}
  ## Get a pointer to the user data for the current music hook


proc channelFinished*(channel_finished: proc(channel: int)) {.cdecl, importc: "Mix_ChannelFinished", dynlib: LibMixName.}
  ## Add your own callback when a channel has finished playing.
  ## nil to disable callback. The callback may be called from the mixer's audio
  ## callback or it could be called as a result of haltChannel(), etc.
  ## do not call lockAudio() from this callback; you will either be
  ## inside the audio callback, or SDL_mixer will explicitly lock the audio
  ## before calling your callback.


# Special Effects API by ryan c. gordon. (icculus@icculus.org)


const
  CHANNEL_POST* = -2


type
  
  PEffectFunc* = proc(chan: int, stream: pointer, len: int, udata: pointer)
    ## This is the format of a special effect callback:
    ##
    ## myeffect(chan: int, stream: pointer, len: int, udata: pointer)
    ##
    ## ``chan`` is the channel number that your effect is affecting.
    ##
    ## ``stream`` is the buffer of data to work upon.
    ##
    ## ``len`` is the size of ``stream``
    ##
    ## ``udata`` is a user-defined bit of data, which you pass as the last arg
    ## of registerEffect(), and is passed back unmolested to your callback.
    ##
    ## Your effect changes the contents of ``stream`` based on whatever
    ## parameters are significant, or just leaves it be, if you prefer.
    ## You can do whatever you like to the buffer, though, and it will
    ## continue in its changed state down the mixing pipeline, through
    ## any other effect functions, then finally to be mixed with the rest
    ## of the channels and music for the final output stream.
    ##
    ## DO NOT EVER call lockAudio() from your callback function!
    

  PEffectDone* = proc(chan: int, udata: pointer)
    ## This is a callback that signifies that a channel has finished all its
    ## loops and has completed playback. This gets called if the buffer
    ## plays out normally, or if you call haltChannel(), implicitly stop
    ## a channel via allocateChannels(), or unregister a callback while
    ## it's still playing.
    ##
    ## DO NOT EVER call lockAudio() from your callback function!


proc registerEffect*(chan: int,
    f: PEffectFunc, d: PEffectDone,
    arg: pointer): int {.cdecl, importc: "Mix_RegisterEffect", dynlib: LibMixName.}
  ## Register a special effect function. At mixing time, the channel data is
  ## copied into a buffer and passed through each registered effect function.
  ## After it passes through all the functions, it is mixed into the final
  ## output stream. The copy to buffer is performed once, then each effect
  ## function performs on the output of the previous effect. Understand that
  ## this extra copy to a buffer is not performed if there are no effects
  ## registered for a given chunk, which saves CPU cycles, and any given
  ## effect will be extra cycles, too, so it is crucial that your code run
  ## fast. Also note that the data that your function is given is in the
  ## format of the sound device, and not the format you gave to openAudio(),
  ## although they may in reality be the same. This is an unfortunate but
  ## necessary speed concern. Use querySpec() to determine if you can
  ## handle the data before you register your effect, and take appropriate
  ## actions.
  ##
  ## You may also specify a callback ``PEffectDone`` that is called when
  ## the channel finishes playing. This gives you a more fine-grained control
  ## than channelFinished(), in case you need to free effect-specific
  ## resources, etc. If you don't need this, you can specify nil.
  ## You may set the callbacks before or after calling playChannel().
  ## Things like setPanning() are just internal special effect functions,
  ## so if you are using that, you've already incurred the overhead of a copy
  ## to a separate buffer, and that these effects will be in the queue with
  ## any functions you've registered. The list of registered effects for a
  ## channel is reset when a chunk finishes playing, so you need to explicitly
  ## set them with each call to playChannel*().
  ## You may also register a special effect function that is to be run after
  ## final mixing occurs. The rules for these callbacks are identical to those
  ## in registerEffect, but they are run after all the channels and the
  ## music have been mixed into a single stream, whereas channel-specific
  ## effects run on a given channel before any other mixing occurs. These
  ## global effect callbacks are call "posteffects". Posteffects only have
  ## their PEffectDone function called when they are unregistered (since
  ## the main output stream is never "done" in the same sense as a channel).
  ## You must unregister them manually when you've had enough. Your callback
  ## will be told that the channel being mixed is (CHANNEL_POST) if the
  ## processing is considered a posteffect.
  ##
  ## After all these effects have finished processing, the callback registered
  ## through setPostMix() runs, and then the stream goes to the audio device.
  ##
  ## DO NOT EVER call lockAudio() from your callback function!
  ##
  ## Returns zero if error (no such channel), nonzero if added.
  ## Error messages can be retrieved from getError().


proc unregisterEffect*(channel: int, f: PEffectFunc): int {.cdecl, importc: "Mix_UnregisterEffect", dynlib: LibMixName.}
  ## You may not need to call this explicitly, unless you need to stop an
  ## effect from processing in the middle of a chunk's playback.
  ## Posteffects are never implicitly unregistered as they are for channels,
  ## but they may be explicitly unregistered through this function by
  ## specifying CHANNEL_POST for a channel.
  ##
  ## Returns zero if error (no such channel or effect), nonzero if removed.
  ## Error messages can be retrieved from getError().


proc unregisterAllEffects*(channel: int): int {.cdecl, importc: "Mix_UnregisterAllEffects", dynlib: LibMixName.}
 ## You may not need to call this explicitly, unless you need to stop all
 ## effects from processing in the middle of a chunk's playback. Note that
 ## this will also shut off some internal effect processing, since
 ## setPanning() and others may use this API under the hood. This is
 ## called internally when a channel completes playback.
 ## Posteffects are never implicitly unregistered as they are for channels,
 ## but they may be explicitly unregistered through this function by
 ## specifying CHANNEL_POST for a channel.
 ##
 ## Returns zero if error (no such channel), nonzero if all effects removed.
 ## Error messages can be retrieved from getError().
 

const
  EFFECTSMAXSPEED* = "MIX_EFFECTSMAXSPEED"


#
# These are the internally-defined mixing effects. They use the same API that
# effects defined in the application use, but are provided here as a
# convenience. Some effects can reduce their quality or use more memory in
# the name of speed; to enable this, make sure the environment variable
# MIX_EFFECTSMAXSPEED (see above) is defined before you call
# openAudio().
#


proc setPanning*(channel: int, left, right: Uint8): int {.cdecl, importc: "Mix_SetPanning", dynlib: LibMixName.}
  ## Set the panning of a channel. The left and right channels are specified
  ## as integers between 0 and 255, quietest to loudest, respectively.
  ##
  ## Technically, this is just individual volume control for a sample with
  ## two (stereo) channels, so it can be used for more than just panning.
  ## If you want real panning, call it like this:
  ##
  ## setPanning(channel, left, 255 - left)
  ##
  ## ...which isn't so hard.
  ##
  ## Setting ``channel`` to MIX_CHANNEL_POST registers this as a posteffect,
  ## and the panning will be done to the final mixed stream before passing it
  ## on to the audio device.
  ##
  ## This uses the registerEffect() API internally, and returns without
  ## registering the effect function if the audio device is not configured
  ## for stereo output. Setting both ``left`` and ``right`` to 255 causes
  ## this effect to be unregistered, since that is the data's normal state.
  ##
  ## Returns zero if error (no such channel or registerEffect() fails),
  ## nonzero if panning effect enabled. Note that an audio device in mono
  ## mode is a no-op, but this call will return successful in that case.
  ## Error messages can be retrieved from getError().


proc setPosition*(channel: int , angle: int16, distance: Uint8): int {.cdecl, importc: "Mix_SetPosition", dynlib: LibMixName.}
  ## Set the position of a channel. ``angle`` is an integer from 0 to 360, that
  ## specifies the location of the sound in relation to the listener.
  ##
  ## ``angle`` will be reduced as neccesary (540 becomes 180 degrees,
  ## -100 becomes 260). Angle 0 is due north, and rotates clockwise as the
  ## value increases.
  ##
  ## For efficiency, the precision of this effect may be limited (angles 1
  ## through 7 might all produce the same effect, 8 through 15 are equal, etc).
  ##
  ## ``distance`` is an integer between 0 and 255 that specifies the space
  ## between the sound and the listener. The larger the number, the further
  ## away the sound is. Using 255 does not guarantee that the channel will be
  ## culled from the mixing process or be completely silent. For efficiency,
  ## the precision of this effect may be limited (distance 0 through 5 might
  ## all produce the same effect, 6 through 10 are equal, etc). Setting
  ## ``angle`` and ``distance`` to 0 unregisters this effect, since the data
  ## would be unchanged.
  ##
  ## If you need more precise positional audio, consider using OpenAL for
  ## spatialized effects instead of SDL_mixer. This is only meant to be a
  ## basic effect for simple "3D" games.
  ##
  ## If the audio device is configured for mono output, then you won't get
  ## any effectiveness from the angle; however, distance attenuation on the
  ## channel will still occur. While this effect will function with stereo
  ## voices, it makes more sense to use voices with only one channel of sound,
  ## so when they are mixed through this effect, the positioning will sound
  ## correct. You can convert them to mono through SDL before giving them to
  ## the mixer in the first place if you like.
  ##
  ## Setting ``channel`` to CHANNEL_POST registers this as a posteffect, and
  ## the positioning will be done to the final mixed stream before passing it
  ## on to the audio device.
  ##
  ## This is a convenience wrapper over setDistance() and setPanning().
  ##
  ## Returns zero if error (no such channel or registerEffect() fails),
  ## nonzero if position effect is enabled.
  ## Error messages can be retrieved from getError().


proc setDistance*(channel: int, distance: Uint8): int {.cdecl, importc: "Mix_SetDistance", dynlib: LibMixName.}
  ## Set the ``distance`` of a channel. ``distance`` is an integer
  ## from 0 to 255 that specifies the location of the sound in relation
  ## to the listener.
  ##
  ## Distance 0 is overlapping the listener, and 255 is as far away as possible
  ## A distance of 255 does not guarantee silence; in such a case, you might
  ## want to try changing the chunk's volume, or just cull the sample from the
  ## mixing process with haltChannel().
  ##
  ## For efficiency, the precision of this effect may be limited (distances 1
  ## through 7 might all produce the same effect, 8 through 15 are equal, etc).
  ## ``distance`` is an integer between 0 and 255 that specifies the space
  ## between the sound and the listener. The larger the number, the further
  ## away the sound is.
  ##
  ## Setting (distance) to 0 unregisters this effect, since the data would be
  ## unchanged.
  ##
  ## If you need more precise positional audio, consider using OpenAL for
  ## spatialized effects instead of SDL_mixer. This is only meant to be a
  ## basic effect for simple "3D" games.
  ##
  ## Setting ``channel`` to CHANNEL_POST registers this as a posteffect, and
  ## the distance attenuation will be done to the final mixed stream before
  ## passing it on to the audio device.
  ##
  ## This uses the registerEffect() API internally.
  ##
  ## Returns zero if error (no such channel or registerEffect() fails),
  ## nonzero if position effect is enabled.
  ## Error messages can be retrieved from getError().


#
# !!! FIXME : Haven't implemented, since the effect goes past the
#              end of the sound buffer. Will have to think about this.
#               --ryan.
#
when(false):
  proc setReverb*(channel: int, echo: Uint8): int {.cdecl, importc: "Mix_SetReverb", dynlib: LibMixName.}
    ## Causes an echo effect to be mixed into a sound. ``echo`` is the amount
    ## of echo to mix. 0 is no echo, 255 is infinite (and probably not
    ## what you want).
    ##
    ## Setting ``channel`` to CHANNEL_POST registers this as a posteffect, and
    ## the reverbing will be done to the final mixed stream before passing it
    ## on to the audio device.
    ##
    ## This uses the registerEffect() API internally. If you specify an echo of
    ## zero, the effect is unregistered, as the data is already in that state.
    ##
    ## Returns zero if error (no such channel or registerEffect() fails),
    ## nonzero if reversing effect is enabled.
    ## Error messages can be retrieved from getError().


proc setReverseStereo*(channel: int, flip: int): int {.cdecl, importc: "Mix_SetReverseStereo", dynlib: LibMixName.}
  ## Causes a channel to reverse its stereo. This is handy if the user has his
  ## speakers hooked up backwards, or you would like to have a minor bit of
  ## psychedelia in your sound code.  :)  Calling this function with ``flip``
  ## set to non-zero reverses the chunks's usual channels. If ``flip`` is zero,
  ## the effect is unregistered.
  ##
  ## This uses the registerEffect() API internally, and thus is probably
  ## more CPU intensive than having the user just plug in his speakers
  ## correctly. setReverseStereo() returns without registering the effect
  ## function if the audio device is not configured for stereo output.
  ##
  ## If you specify CHANNEL_POST for ``channe``), then this the effect is used
  ## on the final mixed stream before sending it on to the audio device (a
  ## posteffect).
  ##
  ## Returns zero if error (no such channel or registerEffect() fails),
  ## nonzero if reversing effect is enabled. Note that an audio device in mono
  ## mode is a no-op, but this call will return successful in that case.
  ## Error messages can be retrieved from getError().


# end of effects API. --ryan.


proc reserveChannels*(num: int): int {.cdecl, importc: "Mix_ReserveChannels", dynlib: LibMixName.}
  ## Reserve the first channels (0 -> n-1) for the application,
  ## i.e. don't allocate them dynamically to the next sample
  ## if requested with a -1 value below.
  ##
  ## Returns the number of reserved channels.


# Channel grouping functions


proc groupChannel*(which, tag: int): int {.cdecl, importc: "Mix_GroupChannel", dynlib: LibMixName.}
  ## Attach a tag to a channel. A tag can be assigned to several mixer
  ## channels, to form groups of channels.
  ## If ``tag`` is -1, the tag is removed (actually -1 is the tag used to
  ## represent the group of all the channels).
  ##
  ## Returns true if everything was OK.


proc groupChannels*(`from`, `to`, tag: int): int {.cdecl, importc: "Mix_GroupChannels", dynlib: LibMixName.}
  ## Assign several consecutive channels to a group


proc groupAvailable*(tag: int): int {.cdecl, importc: "Mix_GroupAvailable", dynlib: LibMixName.}
  ## Finds the first available channel in a group of channels,
  ## returning -1 if none are available.


proc groupCount*(tag: int): int {.cdecl, importc: "Mix_GroupCount", dynlib: LibMixName.}
  ## Returns the number of channels in a group. This is also a subtle
  ## way to get the total number of channels when ``tag`` is -1


proc groupOldest*(tag: int): int {.cdecl, importc: "Mix_GroupOldest", dynlib: LibMixName.}
  ## Finds the "oldest" sample playing in a group of channels


proc groupNewer*(tag: int): int {.cdecl, importc: "Mix_GroupNewer", dynlib: LibMixName.}
  ## Finds the "most recent" (i.e. last) sample playing in a group of channels


proc playChannelTimed*(channel: int, chunk: PChunk, loops, ticks: int): int {.cdecl, importc: "Mix_PlayChannelTimed", dynlib: LibMixName.}
  ## The same as playChannel, but the sound is played at most ``ticks`` milliseconds


proc playMusic*(music: PMusic, loops: int): int {.cdecl, importc: "Mix_PlayMusic", dynlib: LibMixName.}


template playChannel*(channel: int, chunk: PChunk, loops: int)=
  ## Play an audio chunk on a specific channel.
  ##
  ## If the specified channel is -1, play on the first free channel.
  ##
  ## If ``loops`` is greater than zero, loop the sound that many times.
  ##
  ## If ``loops`` is -1, loop inifinitely (~65000 times).
  ##
  ## Returns which channel was used to play the sound.
  playChannelTimed(channel, chunk, loops, -1)


proc fadeInMusic*(music: PMusic, loops, ms: int): int {.cdecl, importc: "Mix_FadeInMusic", dynlib: LibMixName.}
  ## Fade in music or a channel over ``ms`` milliseconds, same semantics as the "play" functions


proc fadeInMusicPos*(music: PMusic, loops, ms: int, position: cdouble): int {.cdecl, importc: "Mix_FadeInMusicPos", dynlib: LibMixName.}
  ## Fade in music over ``ms`` milliseconds, same semantics as the "play" functions


proc fadeInChannelTimed*(channel: int, chunk: PChunk, loops, ms, ticks: int): int {.cdecl, importc: "Mix_FadeInChannelTimed", dynlib: LibMixName.}
  ## Fade in channel over ``ms`` milliseconds, same semantics as the "play" functions


template fadeInChannel*(channel: int, chunk: PChunk, loops, ms: int) =
  fadeInChannelTimed(channel, chunk, loops, ms, -1)


proc volume*(channel, volume: int): int {.cdecl, importc: "Mix_Volume", dynlib: LibMixName.}
  ## Set the volume in the range of 0-128 of a specific channel.
  ## If the specified channel is -1, set volume for all channels.
  ##
  ## Returns the original volume.
  ## If the specified volume is -1, just return the current volume.


proc volumeChunk*(chunk: PChunk, volume: int): int {.cdecl, importc: "Mix_VolumeChunk", dynlib: LibMixName.}
  ## Set the volume in the range of 0-128 of a specific chunk.
  ##
  ## Returns the original volume.
  ## If the specified volume is -1, just return the current volume.


proc volumeMusic*(volume: int): int {.cdecl, importc: "Mix_VolumeMusic", dynlib: LibMixName.}



proc haltChannel*(channel: int): int {.cdecl, importc: "Mix_HaltChannel", dynlib: LibMixName.}
  ## Halt playing of a particular channel


proc haltGroup*(tag: int): int {.cdecl, importc: "Mix_HaltGroup", dynlib: LibMixName.}


proc haltMusic*(): int {.cdecl, importc: "Mix_HaltMusic", dynlib: LibMixName.}


proc expireChannel*(channel, ticks: int): int {.cdecl, importc: "Mix_ExpireChannel", dynlib: LibMixName.}
  ## Change the expiration delay for a particular channel.
  ## The sample will stop playing after the ``ticks`` milliseconds
  ## have elapsed, or remove the expiration if ``ticks`` is -1.


proc fadeOutChannel*(which, ms: int): int {.cdecl, importc: "Mix_FadeOutChannel", dynlib: LibMixName.}
  ## Halt a channel, fading it out progressively till it's silent
  ## The ms parameter indicates the number of milliseconds the fading
  ## will take.


proc fadeOutGroup*(tag, ms: int): int {.cdecl, importc: "Mix_FadeOutGroup", dynlib: LibMixName.}


proc fadeOutMusic*(ms: int): int {.cdecl, importc: "Mix_FadeOutMusic", dynlib: LibMixName.}


proc fadingMusic*(): TFading {.cdecl, importc: "Mix_FadingMusic", dynlib: LibMixName.}


proc fadingChannel*(which: int): TFading {.cdecl, importc: "Mix_FadingChannel", dynlib: LibMixName.}
  ## Query the fading status of a channel


proc pause*(channel: int) {.cdecl, importc: "Mix_Pause", dynlib: LibMixName.}
  ## Pause a particular channel


proc resume*(channel: int) {.cdecl, importc: "Mix_Resume", dynlib: LibMixName.}
  ## Resume a particular channel


proc paused*(channel: int): int {.cdecl, importc: "Mix_Paused", dynlib: LibMixName.}


proc pauseMusic*() {.cdecl, importc: "Mix_PauseMusic", dynlib: LibMixName.}
  ## Pause the music stream


proc resumeMusic*() {.cdecl, importc: "Mix_ResumeMusic", dynlib: LibMixName.}
  ## Resume the music stream


proc rewindMusic*() {.cdecl, importc: "Mix_RewindMusic", dynlib: LibMixName.}


proc pausedMusic*(): int {.cdecl, importc: "Mix_PausedMusic", dynlib: LibMixName.}


proc setMusicPosition*(position: cdouble): int {.cdecl, importc: "Mix_SetMusicPosition", dynlib: LibMixName.}
  ## Set the current position in the music stream.
  ##
  ## This returns 0 if successful, or -1 if it failed or isn't implemented.
  ##
  ## This function is only implemented for MOD music formats (set pattern
  ## order number) and for OGG, FLAC, MP3_MAD, and MODPLUG music (set
  ## position in seconds), at the moment.


proc playing*(channel: int): int {.cdecl, importc: "Mix_Playing", dynlib: LibMixName.}
  ## Check the status of a specific channel.
  ## If the specified channel is -1, check all channels.


proc playingMusic*(): int {.cdecl, importc: "Mix_PlayingMusic", dynlib: LibMixName.}


proc setMusicCMD*(command: cstring): int {.cdecl, importc: "Mix_SetMusicCMD", dynlib: LibMixName.}
  ## Stop music and set external music playback command


proc setSynchroValue*(value: int): int {.cdecl, importc: "Mix_SetSynchroValue", dynlib: LibMixName.}
  ## Synchro value is set by MikMod from modules while playing


proc getSynchroValue*(): int {.cdecl, importc: "Mix_GetSynchroValue", dynlib: LibMixName.}
  ## Synchro value is set by MikMod from modules while playing


proc setSoundFonts*(paths: cstring): int {.cdecl, importc: "Mix_SetSoundFonts", dynlib: LibMixName.}
  ## Set SoundFonts paths to use by supported MIDI backends


proc getSoundFonts*(): cstring {.cdecl, importc: "Mix_GetSoundFonts", dynlib: LibMixName.}
  ## Get SoundFonts paths to use by supported MIDI backends


proc eachSoundFont*(func: proc(str: cstring, pntr: pointer): int, data: pointer): int {.cdecl, importc: "Mix_EachSoundFont", dynlib: LibMixName.}
  ## Iterate SoundFonts paths to use by supported MIDI backends


proc getChunk*(channel: int): PChunk {.cdecl, importc: "Mix_GetChunk", dynlib: LibMixName.}
  ## Get the PChunk currently associated with a mixer channel
  ##
  ## Returns nil if it's an invalid channel, or there's no chunk associated.


proc closeAudio*() {.cdecl, importc: "Mix_CloseAudio", dynlib: LibMixName.}
  ## Close the mixer, halting all playing audio


# We'll use SDL for reporting errors

proc mixSetError*(fmt: cstring): int {.cdecl, importc: "SDL_SetError", varargs, dynlib: LibName.}


proc mixGetError*(): cstring {.cdecl, importc: "SDL_GetError", dynlib: LibName.}

