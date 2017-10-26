audio.nim
=========
* type AudioStream
* proc newAudioStream
* proc audioStreamPut
* proc audioStreamGet
* proc audioStreamAvailable
* proc audioStreamFlush
* proc audioStreamClear
* proc freeAudioStream


joystick.nim
============
* proc lockJoysticks
* proc unlockJoysticks

sdl_image.nim
=============
* template compiledVersion
* template versionAtLeast
* proc isSVG
* proc loadSVG_RW
* proc saveJPG
* proc saveJPG_RW

sdl_mixer.nim
=============
* template compiledVersion
* template versionAtLeast
* changed init flags (see [diff](https://github.com/Vladar4/sdl2_nim/commit/4effb0a833a1488ea7e5656b24480ad86799b8ed#diff-71cd2704d0ccd28f013226d9720da586R90))
* changed MusicType enum (see [diff](https://github.com/Vladar4/sdl2_nim/commit/4effb0a833a1488ea7e5656b24480ad86799b8ed#diff-71cd2704d0ccd28f013226d9720da586R199))
* proc openAudioDevide
* proc hasChunkDecoder
* proc hasMusicDecoder
* template clearError

