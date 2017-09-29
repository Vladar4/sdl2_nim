audio.nim
=========
const AudioCVTMaxFilters

blendmode.nim
=============
enum BlendOperation
enum BlendFactor
proc composeCustomBlendMode

cpuinfo.nim
===========
proc hasNEON

gamecontroller.nim
==================
proc gameControllerNumMappings
proc gameControllerMappingForIndex
proc gameControllerGetVendor
proc gameControllerGetProduct
proc gameControllerGetProductVersion

hints.nim
=========
const HINT_RENDER_LOGICAL_SIZE_MODE
const HINT_WINDOWS_INTRESOURCE_ICON
const HINT_WINDOWS_INTRESOURCE_ICON_SMALL
const HINT_MOUSE_NORMAL_SPEED_SCALE
const HINT_MOUSE_RELATIVE_SPEED_SCALE
const HINT_TOUCH_MOUSE_EVENTS
const HINT_GAMECONTROLLER_IGNORE_DEVICES
const HINT_GAMECONTROLLER_IGNORE_DEVICES_EXCEPT
const HINT_QTWAYLAND_CONTENT_ORIENTATION
const HINT_QTWAYLAND_WINDOW_FLAGS
const HINT_OPENGL_ES_DRIVER
const HINT_AUDIO_RESAMPLING_MODE
const HINT_AUDIO_CATEGORY

joystick.nim
============
enum JoystickType
proc joystickGetDeviceVendor
proc joystickGetDeviceProduct
proc joystickGetDeviceProductVersion
proc joystickGetDeviceType
proc joystickGetDeviceInstanceID
proc joystickGetVendor
proc joystickGetProduct
proc joystickGetProductVersion
proc joystickGetType
const JOYSTICK_AXIS_MAX
const JOYSTICK_AXIS_MIN
proc joystickGetAxisInitialState

keycode.nim
===========
Keycode.K_APP1
Keycode.K_APP2
Keycode.K_AUDIOREWIND
Keycode.K_AUDIOFASTFORWARD

rwops.nim
=========
proc loadFileRW
template loadFile

scancode.nim
============
Scancode.SCANCODE_AUDIOREWIND
Scancode.SCANCODE_AUDIOFASTFORWARD

surface.nim
===========
proc duplicateSurface

video.nim
=========
const WINDOW_VULKAN
GLattr.GL_CONTEXT_RESET_NOTIFICATION
GLattr.GL_CONTEXT_NO_ERROR
enum GLcontextResetNotification

vulkan.nim
==========
type VulkanInstance
type VulkanSurface
proc vulkanLoadLibrary
proc vulkanGetVkGetInstanceProcAddr
proc vulkanUnloadLibrary
proc vulkanGetInstanceExtensions
proc vulkanCreateSurface
proc vulkanGetDrawableSize

