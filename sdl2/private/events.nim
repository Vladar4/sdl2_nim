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

##  events.nim
##  ==========
##
##  Include file for SDL event handling.

# General keyboard/mouse state definitions
const
  RELEASED* = 0
  PRESSED*  = 1

type
  EventKind* {.size: sizeof(uint32).} = enum ##  \
    ##  The types of events that can be delivered.

    FIRSTEVENT = 0, ##  Unused (do not remove)

    # Application events

    QUIT = 0x00000100,  ##  User-requested quit

    # These application events have special meaning on iOS,
    # see README-ios.md for details.

    APP_TERMINATING,  ##  \
      ##  The application is being terminated by the OS
      ##
      ##  Called on iOS in ``applicationWillTerminate()``
      ##
      ##  Called on Android in ``onDestroy()``
    APP_LOWMEMORY,  ##  \
      ##  The application is low on memory, free memory if possible.
      ##
      ##  Called on iOS in ``applicationDidReceiveMemoryWarning()``
      ##
      ##  Called on Android in ``onLowMemory()``
    APP_WILLENTERBACKGROUND,  ##  \
      ##  The application is about to enter the background
      ##
      ##  Called on iOS in ``applicationWillResignActive()``
      ##
      ##  Called on Android in ``onPause()``
    APP_DIDENTERBACKGROUND, ##  \
      ##  The application did enter the background
      ##  and may not get CPU for some time
      ##
      ##  Called on iOS in ``applicationDidEnterBackground()``
      ##
      ##  Called on Android in ``onPause()``
    APP_WILLENTERFOREGROUND,  ##  \
      ##  The application is about to enter the foreground
      ##
      ##  Called on iOS in ``applicationWillEnterForeground()``
      ##
      ##  Called on Android in ``onResume()``
    APP_DIDENTERFOREGROUND,   ##  \
      ##  The application is now interactive
      ##
      ##  Called on iOS in ``applicationDidBecomeActive()``
      ##
      ##  Called on Android ``in onResume()``

    # Window events

    WINDOWEVENT = 0x00000200, ##  Window state change
    SYSWMEVENT,               ##  System specific event

    # Keyboard events

    KEYDOWN = 0x00000300,     ##  Key pressed
    KEYUP,                    ##  Key released
    TEXTEDITING,              ##  Keyboard text editing (composition)
    TEXTINPUT,                ##  Keyboard text input
    KEYMAPCHANGED,            ##  Keymap changed due to a system event such as \
                              ##  an input language or keyboard layout change.

    # Mouse events

    MOUSEMOTION = 0x00000400, ##  Mouse moved
    MOUSEBUTTONDOWN,          ##  Mouse button pressed
    MOUSEBUTTONUP,            ##  Mouse button released
    MOUSEWHEEL,               ##  Mouse wheel motion

    # Joystick events

    JOYAXISMOTION = 0x00000600, ##  Joystick axis motion
    JOYBALLMOTION,    ##  Joystick trackball motion
    JOYHATMOTION,     ##  Joystick hat position change
    JOYBUTTONDOWN,    ##  Joystick button pressed
    JOYBUTTONUP,      ##  Joystick button released
    JOYDEVICEADDED,   ##  A new joystick has been inserted into the system
    JOYDEVICEREMOVED, ## An opened joystick has been removed

    # Game controller events

    CONTROLLERAXISMOTION = 0x00000650,  ##  Game controller axis motion
    CONTROLLERBUTTONDOWN,     ##  Game controller button pressed
    CONTROLLERBUTTONUP,       ##  Game controller button released
    CONTROLLERDEVICEADDED,    ##  \
      ##  A new Game controller has been inserted into the system
    CONTROLLERDEVICEREMOVED,  ##  An opened Game controller has been removed
    CONTROLLERDEVICEREMAPPED, ##  The controller mapping was updated

    # Touch events

    FINGERDOWN = 0x00000700,
    FINGERUP,
    FINGERMOTION,

    # Gesture events

    DOLLARGESTURE = 0x00000800,
    DOLLARRECORD,
    MULTIGESTURE,

    # Clipboard events

    CLIPBOARDUPDATE = 0x00000900, ##  The clipboard changed

    # Drag and drop events

    DROPFILE = 0x00001000,  ##  The system requests a file open
    DROPTEXT,       ##  Text/plain drag-and-drop event
    DROPBEGIN,      ##  A new set of drops is beginning (``nil`` filename)
    DROPCOMPLETE,   ##  Current set of drops is now complete (``nil`` filename)

    # Audio hotplug events

    AUDIODEVICEADDED = 0x1100,  ##  A new audio device is available
    AUDIODEVICEREMOVED,         ##  An audio device has been removed

    # Render events

    RENDER_TARGETS_RESET = 0x00002000,  ##  The render targets have been reset \
      ##  and their contents need to be updated
    RENDER_DEVICE_RESET,  ##  The device has beed reset and all textures need \
      ## to be recreated

    USEREVENT = 0x00008000, ##  \
      ##  Events `USEREVENT` through `LASTEVENT` are for your use,
      ##  and should be allocated with ``registerEvents()``

    LASTEVENT = 0x0000FFFF  ##  \
      ##  This last event is only for bounding internal arrays

type
  CommonEventObj* = object ##  \
    ##  Fields shared by every event
    kind*: EventKind
    timestamp*: uint32

type
  WindowEventObj* = object ##  \
    ##  Window state change event data (`event.window.*`)
    kind*: EventKind        ##  `WINDOWEVENT`
    timestamp*: uint32
    windowID*: uint32       ##  The associated window
    event*: WindowEventID   ##  WindowEventID
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
    data1*: int32           ##  event dependent data
    data2*: int32           ##  event dependent data

type
  KeyboardEventObj* = object ##  \
    ##  Keyboard button event structure (`event.key.*`)
    kind*: EventKind        ##  `KEYDOWN` or `KEYUP`
    timestamp*: uint32
    windowID*: uint32       ##  The window with keyboard focus, if any
    state*: uint8           ##  `PRESSED` or `RELEASED`
    repeat*: uint8          ##  Non-zero if this is a key repeat
    padding2*: uint8
    padding3*: uint8
    keysym*: Keysym         ##  The key that was pressed or released

const
  TEXTEDITINGEVENT_TEXT_SIZE* = 32

type
  TextEditingEventObj* = object ##  \
    ##  Keyboard text editing event structure (`event.edit.*`)
    kind*: EventKind        ##  `TEXTEDITING`
    timestamp*: uint32
    windowID*: uint32       ##  The window with keyboard focus, if any
    text*: array[TEXTEDITINGEVENT_TEXT_SIZE, char]  ##  The editing text
    start*: int32           ##  The start cursor of selected editing text
    length*: int32          ##  The length of selected editing text

const
  TEXTINPUTEVENT_TEXT_SIZE* = 32

type
  TextInputEventObj* = object ##  \
    ##  Keyboard text input event structure (`event.text.*`)
    kind*: EventKind        ##  `TEXTINPUT`
    timestamp*: uint32
    windowID*: uint32       ##  The window with keyboard focus, if any
    text*: array[TEXTINPUTEVENT_TEXT_SIZE, char]  ##  The input text

type
  MouseMotionEventObj* = object ##  \
    ##  Mouse motion event structure (`event.motion.*`)
    kind*: EventKind        ##  `MOUSEMOTION`
    timestamp*: uint32
    windowID*: uint32       ##  The window with mouse focus, if any
    which*: uint32          ##  The mouse instance id, or `TOUCH_MOUSEID`
    state*: uint32          ##  The current button state
    x*: int32               ##  X coordinate, relative to window
    y*: int32               ##  Y coordinate, relative to window
    xrel*: int32            ##  The relative motion in the X direction
    yrel*: int32            ##  The relative motion in the Y direction

type
  MouseButtonEventObj* = object ##  \
    ##  Mouse button event structure (`event.button.*`)
    kind*: EventKind        ##  `MOUSEBUTTONDOWN` or `MOUSEBUTTONUP`
    timestamp*: uint32
    windowID*: uint32       ##  The window with mouse focus, if any
    which*: uint32          ##  The mouse instance id, or `TOUCH_MOUSEID`
    button*: uint8          ##  The mouse button index
    state*: uint8           ##  `PRESSED` or `RELEASED`
    clicks*: uint8          ##  `1` for single-click, `2` for double-click, etc.
    padding1*: uint8
    x*: int32               ##  X coordinate, relative to window
    y*: int32               ##  Y coordinate, relative to window

type
  MouseWheelEventObj* = object ##  \
    ##  Mouse wheel event structure (`event.wheel.*`)
    kind*: EventKind        ##  `MOUSEWHEEL`
    timestamp*: uint32
    windowID*: uint32       ##  The window with mouse focus, if any
    which*: uint32          ##  The mouse instance id, or `TOUCH_MOUSEID`
    x*: int32               ##  \
      ##  The amount scrolled horizontally,
      ##  positive to the right and negative to the left
    y*: int32               ##  \
      ##  The amount scrolled vertically,
      ##  positive away from the user and negative toward the user
    direction*: MouseWheelDirection ##  \
      ##  Set to one of the `MOUSEWHEEL_*`.
      ##  When `MOUSEWHEEL_FLIPPED` the values in X and Y will be opposite.
      ##  Multiply by `-1` to change them back.

type
  JoyAxisEventObj* = object ##  \
    ##  Joystick axis motion event structure (`event.jaxis.*`)
    kind*: EventKind        ##  `JOYAXISMOTION`
    timestamp*: uint32
    which*: JoystickID      ##  The joystick instance id
    axis*: uint8            ##  The joystick axis index
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
    value*: int16           ##  The axis value (range: `-32768` to `32767`)
    padding4*: uint16

type
  JoyBallEventObj* = object ##  \
    ##  Joystick trackball motion event structure (`event.jball.*`)
    kind*: EventKind        ##  `JOYBALLMOTION`
    timestamp*: uint32
    which*: JoystickID      ##  The joystick instance id
    ball*: uint8            ##  The joystick trackball index
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
    xrel*: int16            ##  The relative motion in the X direction
    yrel*: int16            ##  The relative motion in the Y direction

type
  JoyHatEventObj* = object ##  \
    ##  Joystick hat position change event structure (`event.jhat.*`)
    kind*: EventKind        ##  `JOYHATMOTION`
    timestamp*: uint32
    which*: JoystickID      ##  The joystick instance id
    hat*: uint8             ##  The joystick hat index
    value*: uint8           ##  \
      ##  The hat position value.
      ##
      ##  See also:
      ##
      ##  `HAT_LEFTUP`, `HAT_UP`, `SDL_HAT_RIGHTUP`, `HAT_LEFT`, `HAT_CENTERED`,
      ##  `HAT_RIGHT`, `HAT_LEFTDOWN`, `HAT_DOWN`, `HAT_RIGHTDOWN`
      ##
      ##  Note that zero means the POV is centered.
    padding1*: uint8
    padding2*: uint8

type
  JoyButtonEventObj* = object ##  \
    ##  Joystick button event structure (`event.jbutton.*`)
    kind*: EventKind        ##  `JOYBUTTONDOWN` or `JOYBUTTONUP`
    timestamp*: uint32
    which*: JoystickID      ##  The joystick instance id
    button*: uint8          ##  The joystick button index
    state*: uint8           ##  `PRESSED` or `RELEASED`
    padding1*: uint8
    padding2*: uint8

type
  JoyDeviceEventObj* = object ##  \
    ##  Joystick device event structure (`event.jdevice.*`)
    kind*: EventKind        ##  `JOYDEVICEADDED` or `JOYDEVICEREMOVED`
    timestamp*: uint32
    which*: int32           ##  \
      ##  The joystick device index for the `ADDED` event,
      ##  instance id for the `REMOVED` event

type
  ControllerAxisEventObj* = object ##  \
    ##  Game controller axis motion event structure (`event.caxis.*`)
    kind*: EventKind        ##  `CONTROLLERAXISMOTION`
    timestamp*: uint32
    which*: JoystickID      ##  The joystick instance id
    axis*: GameControllerAxis ##  The controller axis (``GameControllerAxis``)
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8
    value*: int16           ##  The axis value (range: `-32768` to `32767`)
    padding4*: uint16

type
  ControllerButtonEventObj* = object ##  \
    ##  Game controller button event structure (`event.cbutton.*`)
    kind*: EventKind        ##  `CONTROLLERBUTTONDOWN` or `CONTROLLERBUTTONUP`
    timestamp*: uint32
    which*: JoystickID      ##  The joystick instance id
    button*: GameControllerButton ##  The controller button (``GameControllerButton``)
    state*: uint8           ##  `PRESSED` or `RELEASED`
    padding1*: uint8
    padding2*: uint8

type
  ControllerDeviceEventObj* = object ##  \
    ##  Controller device event structure (`event.cdevice.*`)
    kind*: EventKind        ##  \
      ##  `CONTROLLERDEVICEADDED`,
      ##  `CONTROLLERDEVICEREMOVED, or
      ##  `CONTROLLERDEVICEREMAPPED`
    timestamp*: uint32
    which*: int32           ##  \
      ##  The joystick device index for the `ADDED` event,
      ##  instance id for the `REMOVED` or `REMAPPED` event 

type
  AudioDeviceEventObj* = object ##  \
    ##  Audio device event structure (`event.adevice.*`)
    kind*: EventKind        ##  `AUDIODEVICEADDED`, or `AUDIODEVICEREMOVED`
    timestamp*: uint32
    which*: uint32          ##  \
      ##  The audio device index for the `ADDED` event (valid until next
      ##  ``getNumAudioDevices()`` call),
      ##  ``AudioDeviceID`` for the `REMOVED` event.
    iscapture*: uint8        ##  \
      ##  `0` if an output device,
      ##  non-zero if a capture device.
    padding1*: uint8
    padding2*: uint8
    padding3*: uint8

type
  TouchFingerEventObj* = object ##  \
    ##  Touch finger event structure (`event.tfinger.*`)
    kind*: EventKind        ##  `FINGERMOTION` or `FINGERDOWN` or `FINGERUP`
    timestamp*: uint32
    touchId*: TouchID       ##  The touch device id
    fingerId*: FingerID
    x*: cfloat              ##  Normalized in the range 0...1
    y*: cfloat              ##  Normalized in the range 0...1
    dx*: cfloat             ##  Normalized in the range -1...1
    dy*: cfloat             ##  Normalized in the range -1...1
    pressure*: cfloat       ##  Normalized in the range 0...1

type
  MultiGestureEventObj* = object
    ##  Multiple Finger Gesture Event (`event.mgesture.*`)
    kind*: EventKind        ##  `MULTIGESTURE`
    timestamp*: uint32
    touchId*: TouchID       ##  The touch device index
    dTheta*: cfloat
    dDist*: cfloat
    x*: cfloat
    y*: cfloat
    numFingers*: uint16
    padding*: uint16

type
  DollarGestureEventObj* = object
    ##  Dollar Gesture Event (`event.dgesture.*`)
    kind*: EventKind        ##  `DOLLARGESTURE` or `DOLLARRECORD`
    timestamp*: uint32
    touchId*: TouchID       ##  The touch device id
    gestureId*: GestureID
    numFingers*: uint32
    error*: cfloat
    x*: cfloat              ##  Normalized center of gesture
    y*: cfloat              ##  Normalized center of gesture

type
  DropEventObj* = object ##  \
    ##  An event used to request a file open by the system (`event.drop.*`)
    ##
    ##  This event is enabled by default,
    ##  you can disable it with ``eventState()``
    ##
    ##  ``Note:`` If this event is enabled,
    ##  you must free the filename in the event.
    kind*: EventKind  ##  `DROPBEGIN` or `DROPFILE`
                      ##  or `DROPTEXT` or `DROPCOMPLETE`
    timestamp*: uint32
    file*: cstring    ##  The file name, which should be freed with ``free()``,
                      ##  is ``nil`` on begin/complete
    windowID: uint32  ##  The window that was dropped on, if any

type
  QuitEventObj* = object ##  \
    ##  The "quit requested" event
    kind*: EventKind        ## `QUIT`
    timestamp*: uint32

type
  OSEventObj* = object ##  \
    ##  OS Specific event
    kind*: EventKind        ##  `QUIT`
    timestamp*: uint32

type
  UserEventObj* = object ##  \
    ##  A user-defined event type (`event.user.*`)
    kind*: EventKind        ##  `USEREVENT` through `LASTEVENT-1`
    timestamp*: uint32
    windowID*: uint32       ##  The associated window if any
    code*: int32            ##  User defined event code
    data1*: pointer         ##  User defined data pointer
    data2*: pointer         ##  User defined data pointer

type
  SysWMmsg* = pointer ##  declared in sdl_syswm.nim

type
  SysWMEventObj* = object ##  \
    ##  A video driver dependent system event (`event.syswm.*`)
    ##
    ##  This event is disabled by default,
    ##  you can enable it with `eventState()`
    ##
    ##  ``Note:`` If you want to use this event,
    ##  you should include ``syswm.nim``.
    kind*: EventKind        ##  `SYSWMEVENT`
    timestamp*: uint32
    msg*: SysWMmsg          ##  driver dependent data, defined in ``syswm.nim``

type
  Event* = object {.union.} ##  \
    ##  General event structure
    kind*: EventKind                    ## Event type, shared with all events
    common*: CommonEventObj             ##  Common event data
    window*: WindowEventObj             ##  Window event data
    key*: KeyboardEventObj              ##  Keyboard event data
    edit*: TextEditingEventObj          ##  Text editing event data
    text*: TextInputEventObj            ##  Text input event data
    motion*: MouseMotionEventObj        ##  Mouse motion event data
    button*: MouseButtonEventObj        ##  Mouse button event data
    wheel*: MouseWheelEventObj          ##  Mouse wheel event data
    jaxis*: JoyAxisEventObj             ##  Joystick axis event data
    jball*: JoyBallEventObj             ##  Joystick ball event data
    jhat*: JoyHatEventObj               ##  Joystick hat event data
    jbutton*: JoyButtonEventObj         ##  Joystick button event data
    jdevice*: JoyDeviceEventObj         ##  Joystick device change event data
    caxis*: ControllerAxisEventObj      ##  Game Controller axis event data
    cbutton*: ControllerButtonEventObj  ##  Game Controller button event data
    cdevice*: ControllerDeviceEventObj  ##  Game Controller device event data
    adevice*: AudioDeviceEventObj       ##  Audio device event data
    quit*: QuitEventObj                 ##  Quit request event data
    user*: UserEventObj                 ##  Custom event data
    syswm*: SysWMEventObj               ##  System dependent window event data
    tfinger*: TouchFingerEventObj       ##  Touch finger event data
    mgesture*: MultiGestureEventObj     ##  Gesture event data
    dgesture*: DollarGestureEventObj    ##  Gesture event data
    drop*: DropEventObj                 ##  Drag and drop event data
    padding*: array[56, uint8]          ##  \
      ##  This is necessary for ABI compatibility between Visual C++ and GCC.
      ##  Visual C++ will respect the push pack pragma and use 52 bytes for
      ##  this structure, and GCC will use the alignment of the largest
      ##  datatype within the union, which is 8 bytes.
      ##
      ##  So... we'll add padding to force the size to be 56 bytes for both.

# Procedures

proc pumpEvents*() {.
    cdecl, importc: "SDL_PumpEvents", dynlib: SDL2_LIB.}
  ##  Pumps the event loop, gathering events from the input devices.
  ##
  ##  This procedure updates the event queue and internal input device state.
  ##
  ##  This should only be run in the thread that sets the video mode.


type
  EventAction* {.size: sizeof(cint).} = enum
    ADDEVENT, PEEKEVENT, GETEVENT

proc peepEvents*(
    events: ptr Event; numevents: cint; action: EventAction;
    minKind: EventKind; maxKind: EventKind): cint {.
      cdecl, importc: "SDL_PeepEvents", dynlib: SDL2_LIB.}
  ##  Checks the event queue for messages and optionally returns them.
  ##
  ##  If ``action`` is `ADDEVENT`, up to ``numevents`` events will be added to
  ##  the back of the event queue.
  ##
  ##  If ``action`` is `PEEKEVENT`, up to ``numevents`` events at the front
  ##  of the event queue, within the specified minimum and maximum type,
  ##  will be returned and will not be removed from the queue.
  ##
  ##  If ``action`` is `GETEVENT`, up to ``numevents`` events at the front
  ##  of the event queue, within the specified minimum and maximum type,
  ##  will be returned and will be removed from the queue.
  ##
  ##  ``Return`` the number of events actually stored,
  ##  or `-1` if there was an error.
  ##
  ##  This procedure is thread-safe.

proc hasEvent*(kind: EventKind): bool {.
    cdecl, importc: "SDL_HasEvent", dynlib: SDL2_LIB.}
  ##  Checks to see if certain event types are in the event queue.

proc hasEvents*(minKind: EventKind; maxKind: EventKind): bool {.
    cdecl, importc: "SDL_HasEvents", dynlib: SDL2_LIB.}

proc flushEvent*(kind: EventKind) {.
    cdecl, importc: "SDL_FlushEvent", dynlib: SDL2_LIB.}
  ##  This procedure clears events from the event queue.
  ##
  ##  This procedure only affects currently queued events.
  ##  If you want to make sure that all pending OS events are flushed,
  ##  you can call ``pumpEvents()`` on the main thread immediately before
  ##  flush call.

proc flushEvents*(minKind: EventKind; maxKind: EventKind) {.
    cdecl, importc: "SDL_FlushEvents", dynlib: SDL2_LIB.}

proc pollEvent*(event: ptr Event): cint {.
    cdecl, importc: "SDL_PollEvent", dynlib: SDL2_LIB.}
  ##  Polls for currently pending events.
  ##
  ##  ``Return`` `1` if there are any pending events,
  ##  or `0` if there are none available.
  ##
  ##  ``event`` If not `nil`, the next event is removed from the queue
  ##  and stored in that area.

proc waitEvent*(event: ptr Event): cint {.
    cdecl, importc: "SDL_WaitEvent", dynlib: SDL2_LIB.}
  ##  Waits indefinitely for the next available event.
  ##
  ##  ``Return`` `1`, or `0` if there was an error while waiting for events.
  ##
  ##  ``event`` If not `nil`, the next event is removed from the queue
  ##  and stored in that area.

proc waitEventTimeout*(event: ptr Event; timeout: cint): cint {.
    cdecl, importc: "SDL_WaitEventTimeout", dynlib: SDL2_LIB.}
  ##  Waits until the specified timeout (in milliseconds)
  ##  for the next available event.
  ##
  ##  ``Return`` `1`, or `0` if there was an error while waiting for events.
  ##
  ##  ``event`` If not `nil`, the next event is removed from the queue
  ##  and stored in that area.
  ##
  ##  ``timeout`` The timeout (in milliseconds)
  ##  to wait for next event.

proc pushEvent*(event: ptr Event): cint {.
    cdecl, importc: "SDL_PushEvent", dynlib: SDL2_LIB.}
  ##  Add an event to the event queue.
  ##
  ##  ``Return`` `1` on success, `0` if the event was filtered,
  ##  or `-1` if the event queue was full or there was some other error.

type
  EventFilter* = proc (userdata: pointer; event: ptr Event): cint {.cdecl.}

proc setEventFilter*(filter: EventFilter; userdata: pointer) {.
    cdecl, importc: "SDL_SetEventFilter", dynlib: SDL2_LIB.}
  ##  Sets up a filter to process all events before they change internal state
  ##  and are posted to the internal event queue.
  ##
  ##  The filter is prototyped as:
  ##
  ##    proc EventFilter(userdata: pointer; event: ptr Event): cint {.cdecl.}
  ##
  ##  If the filter returns `1`, then the event will be added
  ##  to the internal queue.
  ##  If it returns `0`, then the event will be dropped from the queue,
  ##  but the internal state will still be updated.  This allows selective
  ##  filtering of dynamically arriving events.
  ##
  ##  ``Warning:`` Be very careful of what you do in the event filter procedure,
  ##  as it may run in a different thread!
  ##
  ##  There is one caveat when dealing with the ``QuitEvent`` event type.  The
  ##  event filter is only called when the window manager desires to close the
  ##  application window.  If the event filter returns `1`, then the window
  ##  will be closed, otherwise the window will remain open if possible.
  ##
  ##  If the quit event is generated by an interrupt signal, it will bypass the
  ##  internal queue and be delivered to the application at the next event poll.

proc getEventFilter*(filter: ptr EventFilter; userdata: ptr pointer): bool {.
    cdecl, importc: "SDL_GetEventFilter", dynlib: SDL2_LIB.}
  ##  Return the current event filter - can be used to "chain" filters.
  ##  If there is no event filter set, this procedure returns `false`.

proc addEventWatch*(filter: EventFilter; userdata: pointer) {.
    cdecl, importc: "SDL_AddEventWatch", dynlib: SDL2_LIB.}
  ##  Add a procedure which is called when an event is added to the queue.

proc delEventWatch*(filter: EventFilter; userdata: pointer) {.
    cdecl, importc: "SDL_DelEventWatch", dynlib: SDL2_LIB.}
  ##  Remove an event watch procedure added with ``addEventWatch()``

proc filterEvents*(filter: EventFilter; userdata: pointer) {.
    cdecl, importc: "SDL_FilterEvents", dynlib: SDL2_LIB.}
  ##  Run the filter procedure on the current event queue, removing any
  ##  events for which the filter returns `0`.

const
  QUERY*   = -1
  IGNORE*  =  0
  DISABLE* =  0
  ENABLE*  =  1

proc eventState*(kind: EventKind; state: cint): uint8 {.
    cdecl, importc: "SDL_EventState", dynlib: SDL2_LIB.}
  ##  This procedure allows you to set the state of processing certain events.
  ##
  ##  * If ``state`` is set to `IGNORE`, that event will be automatically \
  ##  dropped from the event queue and will not event be filtered.
  ##  * If ``state`` is set to `ENABLE`, that event will be processed normally.
  ##  * If ``state`` is set to `QUERY`, ``eventState()`` will return the \
  ##  current processing state of the specified event.

template getEventState*(kind: untyped): untyped =
  eventState(kind, QUERY)

proc registerEvents*(numevents: cint): uint32 {.
    cdecl, importc: "SDL_RegisterEvents", dynlib: SDL2_LIB.}
  ##  This procedure allocates a set of user-defined events, and returns
  ##  the beginning event number for that set of events.
  ##
  ##  If there aren't enough user-defined events left, this procedure
  ##  returns `-1'u32`.
