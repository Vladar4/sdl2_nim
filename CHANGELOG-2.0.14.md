cpuinfo.nim
===========
* proc simdRealloc

error.nim
=========
* proc getErrorMsg

events.nim
==========
* type EventType (alias for the EventKind)
* EventKind.LOCALECHANGED
* EventKind.CONTROLLERTOUCHPADDOWN
* EventKind.CONTROLLERTOUCHPADMOTION
* EventKind.CONTROLLERTOUCHPADUP
* EventKind.CONTROLLERSENSORUPDATE
* type ControllerTouchpadEventObj
* type ControllerSensorEventObj

gamecontroller.nim
==================
* GameControllerType.CONTROLLER_TYPE_NINTENDO_SWITCH_PRO
* GameControllerType.CONTROLLER_TYPE_VIRTUAL
* GameControllerType.CONTROLLER_TYPE_PS5
* proc gameControllerGetSerial
* proc gameControllerHasAxis
* GameControllerButton.CONTROLLER_BUTTON_MISC1
* GameControllerButton.CONTROLLER_BUTTON_PADDLE1
* GameControllerButton.CONTROLLER_BUTTON_PADDLE2
* GameControllerButton.CONTROLLER_BUTTON_PADDLE3
* GameControllerButton.CONTROLLER_BUTTON_PADDLE4
* GameControllerButton.CONTROLLER_BUTTON_TOUCHPAD
* proc gameControllerHasButton
* proc gameControllerGetNumTouchpads
* proc gameControllerGetNumTouchpadFingers
* proc gameControllerGetTouchpadFinger
* proc gameControllerHasSensor
* proc gameControllerSetSensorEnabled
* proc gameControllerIsSensorEnabled
* proc gameControllerGetSensorData
* proc gameControllerRumbleTriggers
* proc gameControllerHasLED
* proc gameControllerSetLED

haptic.nim
==========
* const HAPTIC_STEERING_AXIS

hints.nim
=========
* const HINT_MOUSE_RELATIVE_SCALING
* const HINT_JOYSTICK_HIDAPI_PS5
* const HINT_JOYSTICK_HIDAPI_CORRELATE_XINPUT
* const HINT_JOYSTICK_RAWINPUT
* const HINT_JOYSTICK_THREAD
* const HINT_LINUX_JOYSTICK_DEADZONES
* const HINT_THREAD_PRIORITY_POLICY
* const HINT_THREAD_FORCE_REALTIME_TIME_CRITICAL
* const HINT_ANDROID_BLOCK_ON_PAUSE_PAUSEAUDIO
* const HINT_EMSCRIPTEN_ASYNCIFY
* const HINT_AUTO_UPDATE_JOYSTICKS
* const HINT_AUTO_UPDATE_SENSORS
* const HINT_AUDIO_DEVICE_APP_NAME
* const HINT_AUDIO_DEVICE_STREAM_NAME
* const HINT_PREFERRED_LOCALES

joystick.nim
============
* const IPHONE_MAX_GFORCE
* proc joystickAttachVirtual
* proc joystickDetachVirtual
* proc joystickIsVirtual
* proc joystickSetVirtualAxis
* proc joystickSetVirtualButton
* proc joystickSetVirtualHat
* proc joystickGetSerial
* proc joystickRumbleTriggers
* proc joystickHasLED
* proc joystickSetLED

locale.nim
==========
(new module)


misc.nim
========
(new module)

metal.nim
=========
* proc metalGetLayer
* proc metalGetDrawableSize

pixels.nim
==========
* PIXELFORMAT_XRGB4444
* PIXELFORMAT_XBGR4444
* PIXELFORMAT_XRGB1555
* PIXELFORMAT_XBGR1555
* PIXELFORMAT_XRGB8888
* PIXELFORMAT_XBGR8888

rwops.nim
=========
* type RWopsType (alias for the RWopsKind)
* changed type RWopsAndroidio

sensor.nim
==========
* proc lockSensors
* proc unlockSensors

surface.nim
===========
* proc hasSurfaceRLE

system.nim
==========
* proc androidRequestPermission

video.nim
=========
* const WINDOW_METAL
* DisplayEventID.DISPLAYEVENT_CONNECTED
* DisplayEventID.DISPLAYEVENT_DISCONNECTED

sdl_syswm.nim
=============
* OS2 stuff

