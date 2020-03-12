blendmode.nim
=============
* BlendMode.BLENDMODE_MUL

cpuinfo.nim
===========
* proc hasARMSIMD

events.nim
==========
* TouchFingerEventObj.windowID

gamecontroller.nim
==================
* type GameControllerType
* proc gameControllerTypeForIndex
* proc gameControllerFromPlayerIndex
* proc GameControllerGetType
* proc gameControllerSetPlayerIndex

hints.nim
=========
* const HINT_VIDEO_EXTERNAL_CONTEXT
* const HINT_VIDEO_X11_WINDOW_VISUALID
* const HINT_VIDEO_X11_FORCE_EGL
* const HINT_GAMECONTROLLERTYPE
* const HINT_GAMECONTROLLER_USE_BUTTON_LABELS
* const HINT_JOYSTICK_HIDAPI_GAMECUBE
* const HINT_DISPLAY_USABLE_BOUNDS

joystick.nim
============
* proc joystickFromPlayerIndex
* proc joystickSetPlayerIndex

messagebox.nim
==============
* const MESSAGEBOX_BUTTONS_LEFT_TO_RIGHT
* const MESSAGEBOX_BUTTONS_RIGHT_TO_LEFT

metal.nim
=========
(new module)
* type MetalView
* proc metalCreateView
* proc metalDestroyView

pixels.nim
==========
* const PIXELFORMAT_BGR444

render.nim
==========
* type ScaleMode
* proc setTextureScaleMode
* proc getTextureScaleMode
* proc lockTextureToSurface

system.nim
==========
* proc getAndroidSDKVersion
* proc onApplicationWillTerminate
* proc onApplicationDidReceiveMemoryWarning
* proc onApplicationWillResignActive
* proc onApplicationDidEnterBackground
* proc onApplicationWillEnterForeground
* proc onApplicationDidBecomeActive
* proc onApplicationDidChangeStatusBarOrientation

syswm.nim
=========
* SysWMKind.SYSWM_HAIKU

