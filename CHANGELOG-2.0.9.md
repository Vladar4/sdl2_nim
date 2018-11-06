audio.nim
=========
* const AUDIO_ALLOW_SAMPLES_CHANGE

cpuinfo.nim
===========
* proc hasAVX512F

events.nim
==========
* type DisplayEventObj
* type SensorEventObj

gamecontroller.nim
==================
proc gameControllerMappingForDeviceIndex
proc gameControllerGetPlayerIndex
proc gameControllerRumble

hints.nim
=========
* const HINT_MOUSE_DOUBLE_CLICK_TIME
* const HINT_MOUSE_DOUBLE_CLICK_RADIUS
* const HINT_JOYSTICK_HIDAPI
* const HINT_JOYSTICK_HIDAPI_PS4
* const HINT_JOYSTICK_HIDAPI_PS4_RUMBLE
* const HINT_JOYSTICK_HIDAPI_STEAM
* const HINT_JOYSTICK_HIDAPI_SWITCH
* const HINT_JOYSTICK_HIDAPI_XBOX
* const HINT_ENABLE_STEAM_CONTROLLERS
* const HINT_ANDROID_TRAP_BACK_BUTTON

joystick.nim
============
* proc joystickGetDevicePlayerIndex
* proc joystickGetPlayerIndex
* proc joystickRumble

surface.nim
===========
* proc hasColorKey

sensor.nim
==========
NEW MODULE

system.nim
==========
* const ANDROID_EXTERNAL_STORAGE_WRITE
* proc linuxSetThreadPriority
* proc isChromebook
* proc isDeXMode
* proc androidBackButton
* proc isTablet

thread.nim
==========
* proc createThreadWithStackSize

video.nim
=========
* type DisplayEventID
* type DisplayOrientation
* proc getDisplayOrientation


