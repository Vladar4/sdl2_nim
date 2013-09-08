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
# Include file for SDL event handling.
#


# General keyboard/mouse state definitions
const 
  RELEASED* = 0
  PRESSED* = 1
  TEXTEDITINGEVENT_TEXT_SIZE* = 32
  TEXTINPUTEVENT_TEXT_SIZE* = 32


  # The types of events that can be delivered.
 
type
  TEventKind* = int32

const

  FIRSTEVENT*: TeventKind = 0 ## Unused (do not remove)
  
  # Application events
  
  QUITEVENT*: TeventKind = 0x100 ## User-requested quit
  
  # These application events have special meaning on iOS, see README.iOS for details
  
  APP_TERMINATING*: TeventKind = 0x101
    ## The application is being terminated by the OS
    ## Called on iOS in applicationWillTerminate()
    ## Called on Android in onDestroy()

  APP_LOWMEMORY*: TeventKind = 0x102
    ## The application is low on memory, free memory if possible.
    ## Called on iOS in applicationDidReceiveMemoryWarning()
    ## Called on Android in onLowMemory()

  APP_WILLENTERBACKGROUND*: TeventKind = 0x103
    ## The application is about to enter the background
    ## Called on iOS in applicationWillResignActive()
    ## Called on Android in onPause()

  APP_DIDENTERBACKGROUND*: TeventKind = 0x104
    ## The application did enter the background and may not get CPU for some time
    ## Called on iOS in applicationDidEnterBackground()
    ## Called on Android in onPause()

  APP_WILLENTERFOREGROUND*: TeventKind = 0x105
    ## The application is about to enter the foreground
    ## Called on iOS in applicationWillEnterForeground()
    ## Called on Android in onResume()

  APP_DIDENTERFOREGROUND*: TeventKind = 0x106
    ## The application is now interactive
    ## Called on iOS in applicationDidBecomeActive()
    ## Called on Android in onResume()
    
  # Window events
  
  WINDOWEVENT*: TeventKind = 0x200 ## Window state change

  SYSWMEVENT*: TeventKind = 0x201 ## System specific event
    
  # Keyboard events
  
  KEYDOWN*: TeventKind = 0x300 ## Key pressed

  KEYUP*: TeventKind = 0x301 ## Key released

  TEXTEDITING*: TeventKind = 0x302 ## Keyboard text editing (composition)

  TEXTINPUT*: TeventKind = 0x303 ## Keyboard text input
  
  # Mouse events
  
  MOUSEMOTION*: TeventKind = 0x400 ## Mouse moved

  MOUSEBUTTONDOWN*: TeventKind = 0x401 ## Mouse button pressed

  MOUSEBUTTONUP*: TeventKind = 0x402 ## Mouse button released

  MOUSEWHEEL*: TeventKind = 0x403 ## Mouse wheel motion
  
  # Joystick events

  JOYAXISMOTION*: TeventKind = 0x600 ## Joystick axis motion

  JOYBALLMOTION*: TeventKind = 0x601 ## Joystick trackball motion

  JOYHATMOTION*: TeventKind = 0x602 ## Joystick hat position change

  JOYBUTTONDOWN*: TeventKind = 0x603 ## Joystick button pressed

  JOYBUTTONUP*: TeventKind = 0x604 ## Joystick button released

  JOYDEVICEADDED*: TeventKind = 0x605 ## A new joystick has been inserted into the system

  JOYDEVICEREMOVED*: TeventKind = 0x606 ## An opened joystick has been removed
  
  # Game controller events
  
  CONTROLLERAXISMOTION*: TeventKind = 0x650 ## Game controller axis motion

  CONTROLLERBUTTONDOWN*: TeventKind = 0x651 ## Game controller button pressed

  CONTROLLERBUTTONUP*: TeventKind = 0x652 ## Game controller button released

  CONTROLLERDEVICEADDED*: TeventKind = 0x653 ## A new Game controller has been inserted into the system

  CONTROLLERDEVICEREMOVED*: TeventKind = 0x654 ## An opened Game controller has been removed

  CONTROLLERDEVICEREMAPPED*: TeventKind = 0x655 ## The controller mapping was updated
  
  # Touch events
  
  FINGERDOWN*: TeventKind = 0x700

  FINGERUP*: TeventKind = 0x701

  FINGERMOTION*: TeventKind = 0x702
  
  # Gesture events

  DOLLARGESTURE*: TeventKind = 0x800

  DOLLARRECORD*: TeventKind = 0x801

  MULTIGESTURE*: TeventKind = 0x802
  
  # Clipboard events

  CLIPBOARDUPDATE*: TeventKind = 0x900 ## The clipboard changed
  
  # Drag and drop events

  DROPFILE*: TeventKind = 0x1000 ## The system requests a file open
  
  USEREVENT*: TeventKind = 0x8000 ## Events USEREVENT through LASTEVENT are for your use, and should be allocated with registerEvents()

  LASTEVENT*: TeventKind = 0xFFFF ## This last event is only for bounding internal arrays


type

  PCommonEvent* = ptr TCommonEvent
  TCommonEvent* = object
    ## Fields shared by every event
    kind*: TEventKind
    timestamp*: Uint32


  PWindowEvent* = ptr TWindowEvent
  TWindowEvent* = object
    ## Window state change event data (event.window.*)
    kind*: TEventKind ## WINDOWEVENT
    timestamp*: Uint32
    windowID*: Uint32 ## The associated window
    event*: Uint8 ## TWindowEventID
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    data1*: int32 ## event dependent data
    data2*: int32 ## event dependent data


  PKeyboardEvent* = ptr TKeyboardEvent
  TKeyboardEvent* = object
    ## Keyboard button event structure (event.key.*)
    kind*: TEventKind ## KEYDOWN or KEYUP
    timestamp*: Uint32
    windowID*: Uint32 ## The window with keyboard focus, if any
    state*: Uint8 ## PRESSED or RELEASED
    repeat*: Uint8 ## Non-zero if this is a key repeat
    padding2*: Uint8
    padding3*: Uint8
    keysym*: TKeysym ## The key that was pressed or released


  PTextEditingEvent* = ptr TTextEditingEvent
  TTextEditingEvent* = object
    ## Keyboard text editing event structure (event.edit.*)
    kind*: TEventKind ## TEXTEDITING
    timestamp*: Uint32
    windowID*: Uint32 ## The window with keyboard focus, if any
    text*: array[0..TEXTEDITINGEVENT_TEXT_SIZE-1, char] ## The editing text
    start*: int32 ## The start cursor of selected editing text
    length*: int32 ## The length of selected editing text


  PTextInputEvent* = ptr TTextInputEvent
  TTextInputEvent* = object
    ## Keyboard text input event structure (event.text.*)
    kind*: TEventKind ## TEXTINPUT
    timestamp*: Uint32
    windowID*: Uint32 ## The window with keyboard focus, if any
    text*: array[0..TEXTINPUTEVENT_TEXT_SIZE-1, char] ## The input text


  PMouseMotionEvent* = ptr TMouseMotionEvent
  TMouseMotionEvent* = object
    ## Mouse motion event structure (event.motion.*)
    kind*: TEventKind ## MOUSEMOTION
    timestamp*: Uint32
    windowID*: Uint32 ## The window with mouse focus, if any
    which*: Uint32 ## The mouse instance id, or TOUCH_MOUSEID
    state*: Uint32 ## The current button state
    x*: int32 ## X coordinate, relative to window
    y*: int32 ## Y coordinate, relative to window
    xrel*: int32 ## The relative motion in the X direction
    yrel*: int32 ## The relative motion in the Y direction


  PMouseButtonEvent* = ptr TMouseButtonEvent
  TMouseButtonEvent* = object
    ## Mouse button event structure (event.button.*)
    kind*: TEventKind ## MOUSEBUTTONDOWN or MOUSEBUTTONUP
    timestamp*: Uint32
    windowID*: Uint32 ## The window with mouse focus, if any
    which*: Uint32 ## The mouse instance id, or TOUCH_MOUSEID
    button*: Uint8 ## The mouse button index
    state*: Uint8 ## PRESSED or RELEASED
    padding1*: Uint8
    padding2*: Uint8
    x*: int32 ## X coordinate, relative to window
    y*: int32 ## Y coordinate, relative to window


  PMouseWheelEvent* = ptr TMouseWheelEvent
  TMouseWheelEvent* = object
    ## Mouse wheel event structure (event.wheel.*)
    kind*: TEventKind ## MOUSEWHEEL
    timestamp*: Uint32
    windowID*: Uint32 ## The window with mouse focus, if any
    which*: Uint32 ## The mouse instance id, or TOUCH_MOUSEID
    x*: int32 ## The amount scrolled horizontally
    y*: int32 ## The amount scrolled vertically


  PJoyAxisEvent* = ptr TJoyAxisEvent
  TJoyAxisEvent* = object
    ## Joystick axis motion event structure (event.jaxis.*)
    kind*: TEventKind ## JOYAXISMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    axis*: Uint8 ## The joystick axis index
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    value*: int16 ## The axis value (range: -32768 to 32767)
    padding4*: int16


  PJoyBallEvent* = ptr TJoyBallEvent
  TJoyBallEvent* = object
    ## Joystick trackball motion event structure (event.jball.*)
    kind*: TEventKind ## JOYBALLMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    ball*: Uint8 ## The joystick trackball index
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    xrel*: int16 ## The relative motion in the X direction
    yrel*: int16 ## The relative motion in the Y direction


  PJoyHatEvent* = ptr TJoyHatEvent
  TJoyHatEvent* = object
    ## Joystick hat position change event structure (event.jhat.*)
    kind*: TEventKind ## JOYHATMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    hat*: Uint8 ## The joystick hat index
    value*: Uint8 ## The hat position value. See also: HAT_LEFTUP, HAT_UP, HAT_RIGHTUP, HAT_LEFT, HAT_CENTERED, HAT_RIGHT, HAT_LEFTDOWN, HAT_DOWN, HAT_RIGHTDOWN. Note that zero means the POV is centered.
    padding1*: Uint8
    padding2*: Uint8


  PJoyButtonEvent* = ptr TJoyButtonEvent
  TJoyButtonEvent* = object
    ## Joystick button event structure (event.jbutton.*)
    kind*: TEventKind ## JOYBUTTONDOWN or JOYBUTTONUP
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    button*: Uint8 ## The joystick button index
    state*: Uint8 ## PRESSED or RELEASED
    padding1*: Uint8
    padding2*: Uint8


  PJoyDeviceEvent* = ptr TJoyDeviceEvent
  TJoyDeviceEvent* = object
    ## Joystick device event structure (event.jdevice.*)
    kind*: TEventKind ## JOYDEVICEADDED or JOYDEVICEREMOVED
    timestamp*: Uint32
    which*: int32 ## The joystick device index for the ADDED event, instance id for the REMOVED event


  PControllerAxisEvent* = ptr TControllerAxisEvent
  TControllerAxisEvent* = object
    ## Game controller axis motion event structure (event.caxis.*)
    kind*: TEventKind ## CONTROLLERAXISMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    axis*: Uint8 ## The controller axis (TGameControllerAxis)
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    value*: int16 ## The axis value (range: -32768 to 32767)
    padding4*: int16


  PControllerButtonEvent* = ptr TControllerButtonEvent
  TControllerButtonEvent* = object
    ## Game controller button event structure (event.cbutton.*)
    kind*: TEventKind ## CONTROLLERBUTTONDOWN or CONTROLLERBUTTONUP
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    button*: Uint8 ## The controller button (TGameControllerButton)
    state*: Uint8 ## PRESSED or RELEASED
    padding1*: Uint8
    padding2*: Uint8


  PControllerDeviceEvent* = ptr TcontrollerDeviceEvent
  TControllerDeviceEvent* = object
    ## Controller device event structure (event.cdevice.*)
    kind*: TEventKind ## CONTROLLERDEVICEADDED, CONTROLLERDEVICEREMOVED, or CONTROLLERDEVICEREMAPPED
    timestamp*: Uint32
    which*: int32 ## The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event


  PTouchFingerEvent* = ptr TTouchFingerEvent
  TTouchFingerEvent* = object
    ## Touch finger event structure (event.finger.*)
    kind*: TEventKind ## FINGERMOTION or FINGERDOWN or FINGERUP
    timestamp*: Uint32
    touchId*: TTouchID ## The touch device id
    fingerID*: TFingerID
    x*: cfloat ## Normalized in the range 0...1
    y*: cfloat ## Normalized in the range 0...1
    dx*: cfloat ## Normalized in the range 0...1
    dy*: cfloat ## Normalized in the range 0...1
    pressure*: cfloat ## Normalized in the range 0...1


  PMultiGestureEvent* = ptr TMultiGestureEvent
  TMultiGestureEvent* = object
    ## Multiple Finger Gesture Event (event.mgesture.*)
    kind*: TEventKind ## MULTIGESTURE
    timestamp*: Uint32
    touchId*: TTouchID ## The touch device index
    dTheta*: cfloat
    dDist*: cfloat
    x*: cfloat
    y*: cfloat
    numFingers*: Uint16
    padding*: Uint16


  PDollarGestureEvent* = ptr TDollarGestureEvent
  TDollarGestureEvent* = object
    ## EvDollarGesture(event.dgesture.*)
    kind*: TEventKind ## DOLLARGESTURE
    timestamp*: Uint32
    touchId*: TTouchID ## The touch device id
    gestureId*: TGestureID
    numFingers*: Uint32
    error*: cfloat
    x*: cfloat ## Normalized center of gesture
    y*: cfloat ## Normalized center of gesture


  PDropEvent* = ptr TDropEvent
  TDropEvent* = object
    ## An event used to request a file open by the system (event.drop.*)
    ##
    ## This event is disabled by default, you can enable it with eventState()
    ##
    ##If you enable this event, you must free the filename in the event.
    kind*: TEventKind ## DROPFILE
    timestamp*: Uint32
    file*: cstring ## The file name, which should be freed with free()


  PQuitEvent* = ptr TQuitEvent
  TQuitEvent* = object
    ## The "quit requested" event
    kind*: TEventKind ## QUIT
    timestamp*: Uint32


  POSEvent* = ptr TOSEvent
  TOSEvent* = object
    ## OS Specific event
    kind*: TEventKind ## QUIT
    timestamp*: Uint32


  PUserEvent* = ptr TUserEvent
  TUserEvent* = object
    ## A user-defined event type (event.user.*)
    kind*: TEventKind ## USEREVENT through NUMEVENTS-1
    timestamp*: Uint32
    windowID*: Uint32 ## The associated window if any
    code*: int32 ## User defined event code
    data1*: pointer ## User defined data pointer
    data2*: pointer ## User defined data pointer


  PSysWMmsg* = pointer


  PSysWMEvent* = ptr TSysWMEvent
  TSysWMEvent* = object
    ## A video driver dependent system event (event.syswm.*)
    ##
    ## This event is disabled by default, you can enable it with eventState()
    ##
    ## If you want to use this event, you should include syswm.h.
    kind*: TEventKind ## SYSWMEVENT
    timestamp*: Uint32
    msg*: PSysWMmsg ## driver dependent data, defined in syswm.h

  
  PEvent* = ptr TEvent
  TEvent* = object
    kind*: TEventKind
    timestamp*: Uint32
    data: array[0..47, byte]


template evconv(procName: expr, ptrName: typeDesc, assertions: seq[TEventKind]): stmt {.immediate.} =
  template `procName`*(event: PEvent): ptrName =
    assert(contains(assertions, event.kind)); cast[ptrName](event)

evconv(EvWindow, PWindowEvent, @[WINDOWEVENT])
evconv(EvKeyboard, PKeyboardEvent, @[KEYDOWN, KEYUP])
evconv(EvTextEditing, PTextEditingEvent, @[TEXTEDITING])
evconv(EvTextInput, PTextInputEvent, @[TEXTINPUT])
evconv(EvMouseMotion, PMouseMotionEvent, @[MOUSEMOTION])
evconv(EvMouseButton, PMouseButtonEvent, @[MOUSEBUTTONDOWN, MOUSEBUTTONUP])
evconv(EvMouseWheel, PMouseWheelEvent, @[MOUSEWHEEL])
evconv(EvJoyAxis, PJoyAxisEvent, @[JOYAXISMOTION])
evconv(EvJoyBall, PJoyBallEvent, @[JOYBALLMOTION])
evconv(EvJoyHat, PJoyHatEvent, @[JOYHATMOTION])
evconv(EvJoyButton, PJoyButtonEvent, @[JOYBUTTONDOWN, JOYBUTTONUP])
evconv(EvJoyDevice, PJoyDeviceEvent, @[JOYDEVICEADDED, JOYDEVICEREMOVED])
evconv(EvControllerAxis, PControllerAxisEvent, @[CONTROLLERAXISMOTION])
evconv(EvControllerButton, PControllerButtonEvent, @[CONTROLLERBUTTONDOWN, CONTROLLERBUTTONUP])
evconv(EvControllerDevice, PControllerDeviceEvent, @[CONTROLLERDEVICEADDED, CONTROLLERDEVICEREMOVED, CONTROLLERDEVICEREMAPPED])
evconv(EvTouchFinger, PTouchFingerEvent, @[FINGERMOTION, FINGERDOWN, FINGERUP])
evconv(EvMultiGesture, PMultiGestureEvent, @[MULTIGESTURE])
evconv(EvDollarGestute, PDollarGestureEvent, @[DOLLARGESTURE])
evconv(EvDrop, PDropEvent, @[DROPFILE])
evconv(EvQuit, PQuitEvent, @[QUITEVENT])
evconv(EvUser, PUserEvent, @[USEREVENT])
evconv(EvSysWM, PSysWMEvent, @[SYSWMEVENT])


template evconv_alt(procName: expr, ptrName: typeDesc, assertions: seq[TEventKind]): stmt {.immediate.} =
  template `procName`*(event: TEvent): ptrName =
    assert(contains(assertions, event.kind)); cast[ptrName](addr(event))

evconv_alt(window, PWindowEvent, @[WINDOWEVENT])
evconv_alt(key, PKeyboardEvent, @[KEYDOWN, KEYUP])
evconv_alt(edit, PTextEditingEvent, @[TEXTEDITING])
evconv_alt(text, PTextInputEvent, @[TEXTINPUT])
evconv_alt(motion, PMouseMotionEvent, @[MOUSEMOTION])
evconv_alt(button, PMouseButtonEvent, @[MOUSEBUTTONDOWN, MOUSEBUTTONUP])
evconv_alt(wheel, PMouseWheelEvent, @[MOUSEWHEEL])
evconv_alt(jaxis, PJoyAxisEvent, @[JOYAXISMOTION])
evconv_alt(jball, PJoyBallEvent, @[JOYBALLMOTION])
evconv_alt(jhat, PJoyHatEvent, @[JOYHATMOTION])
evconv_alt(jbutton, PJoyButtonEvent, @[JOYBUTTONDOWN, JOYBUTTONUP])
evconv_alt(jdevice, PJoyDeviceEvent, @[JOYDEVICEADDED, JOYDEVICEREMOVED])
evconv_alt(caxis, PControllerAxisEvent, @[CONTROLLERAXISMOTION])
evconv_alt(cbutton, PControllerButtonEvent, @[CONTROLLERBUTTONDOWN, CONTROLLERBUTTONUP])
evconv_alt(cdevice, PControllerDeviceEvent, @[CONTROLLERDEVICEADDED, CONTROLLERDEVICEREMOVED, CONTROLLERDEVICEREMAPPED])
evconv_alt(finger, PTouchFingerEvent, @[FINGERMOTION, FINGERDOWN, FINGERUP])
evconv_alt(mgesture, PMultiGestureEvent, @[MULTIGESTURE])
evconv_alt(dgestute, PDollarGestureEvent, @[DOLLARGESTURE])
evconv_alt(drop, PDropEvent, @[DROPFILE])
evconv_alt(quit, PQuitEvent, @[QUITEVENT])
evconv_alt(user, PUserEvent, @[USEREVENT])
evconv_alt(sysvm, PSysWMEvent, @[SYSWMEVENT])


# Function prototypes


proc pumpEvents*() {.cdecl, importc: "SDL_PumpEvents", dynlib: LibName.}
  ## Pumps the event loop, gathering events from the input devices.
  ##
  ## This function updates the event queue and internal input device state.
  ##
  ##  This should only be run in the thread that sets the video mode.


type
  TEventAction* = enum
    ADDEVENT,
    PEEKEVENT,
    GETEVENT

proc peepEvents*(events: PEvent, numevents: int, action: TEventAction,
    minKind, maxKind: TEventKind): int {.cdecl, importc: "SDL_PeepEvents", dynlib: LibName.}
  ## Checks the event queue for messages and optionally returns them.
  ##
  ## If ``action`` is ADDEVENT, up to ``numevents`` events will be added to
  ## the back of the event queue.
  ##
  ## If ``action`` is PEEKEVENT, up to ``numevents`` events at the front
  ## of the event queue, within the specified minimum and maximum type,
  ## will be returned and will not be removed from the queue.
  ##
  ## If ``action`` is GETEVENT, up to ``numevents`` events at the front
  ## of the event queue, within the specified minimum and maximum type,
  ## will be returned and will be removed from the queue.
  ##
  ## Return The number of events actually stored, or -1 if there was an error.
  ##
  ## This function is thread-safe.


proc hasEvent*(kind: TEventKind): bool {.cdecl, importc: "SDL_HasEvent", dynlib: LibName.}
  ## checks to see if certain event types are in the event queue.


proc hasEvents*(minKind, maxType: TEventKind): bool {.cdecl, importc: "SDL_HasEvents", dynlib: LibName.}
  ## Checks to see if certain event types are in the event queue.


proc flushEvent*(kind: TEventKind) {.cdecl, importc: "SDL_FlushEvent", dynlib: LibName.}
  ## This function clears events from the event queue


proc flushEvents*(minKind, maxKind: TEventKind) {.cdecl, importc: "SDL_FlushEvents", dynlib: LibName.}
  ## This function clears events from the event queue


proc pollEvent*(event: PEvent): int {.cdecl, importc: "SDL_PollEvent", dynlib: LibName.}
  ## Polls for currently pending events.
  ##
  ## Return 1 if there are any pending events, or 0 if there are none available.
  ##
  ## ``event`` If not nil, the next event is removed from the queue and
  ## stored in that area.


proc waitEvent*(event: PEvent): int {.cdecl, importc: "SDL_WaitEvent", dynlib: LibName.}
  ## Waits indefinitely for the next available event.
  ##
  ## Return 1, or 0 if there was an error while waiting for events.
  ##
  ## ``event`` If not nil, the next event is removed from the queue and
  ## stored in that area.


proc waitEventTimeout*(event: PEvent, timeout: int): int {.cdecl, importc: "SDL_WaitEventTimeout", dynlib: LibName.}
  ## Waits until the specified timeout (in milliseconds) for the next
  ## available event.
  ##
  ## Return 1, or 0 if there was an error while waiting for events.
  ##
  ## ``event`` If not nil, the next event is removed from the queue and
  ## stored in that area.
  ##
  ## ``timeout`` The timeout (in milliseconds) to wait for next event.


proc pushEvent*(event: PEvent): int {.cdecl, importc: "SDL_PushEvent", dynlib: LibName.}
  ## Add an event to the event queue.
  ##
  ## Return 1 on success, 0 if the event was filtered, or -1 if the event queue
  ## was full or there was some other error.


type
  PEventFilter* = proc(userdata: pointer, event: PEvent): int {.cdecl.}


proc setEventFilter*(filter: PEventFilter,
    userdata: pointer) {.cdecl, importc: "SDL_SetEventFilter", dynlib: LibName.}
  ## Sets up a filter to process all events before they change internal state
  ## and are posted to the internal event queue.
  ##
  ## The filter is prototyped as:
  ##
  ## proc eventFilter(userdata: pointer, event: PEvent): int
  ##
  ##
  ## If the filter returns 1, then the event will be added to the internal queue.
  ## If it returns 0, then the event will be dropped from the queue, but the
  ## internal state will still be updated.  This allows selective filtering of
  ## dynamically arriving events.
  ##
  ## Warning: Be very careful of what you do in the event filter function, as
  ## it may run in a different thread!
  ##
  ## There is one caveat when dealing with the QUITEVENT event type. The
  ## event filter is only called when the window manager desires to close the
  ## application window.  If the event filter returns 1, then the window will
  ## be closed, otherwise the window will remain open if possible.
  ##
  ## If the quit event is generated by an interrupt signal, it will bypass the
  ## internal queue and be delivered to the application at the next event poll.


proc getEventFilter*(filter: ptr PEventFilter,
    userdata: ptr pointer): bool {.cdecl, importc: "SDL_GetEventFilter", dynlib: LibName.}
  ## Return the current event filter - can be used to "chain" filters.
  ## If there is no event filter set, this function returns FALSE.


proc addEventWatch*(filter: PEventFilter,
    userdata: pointer) {.cdecl, importc: "SDL_AddEventWatch", dynlib: LibName.}
  ## Add a function which is called when an event is added to the queue.


proc delEventWatch*(filter: PEventFilter,
    userdata: pointer) {.cdecl, importc: "SDL_DelEventWatch", dynlib: LibName.}
  ## Remove an event watch function added with addEventWatch()


proc filterEvents*(filter: PEventFilter,
  userdata: pointer) {.cdecl, importc: "SDL_FilterEvents", dynlib: LibName.}
  ## Run the filter function on the current event queue, removing any
  ##  events for which the filter returns 0.


const
  QUERY* = -1
  IGNORE* = 0
  DISABLE* = 0
  ENABLE* = 1


proc eventState*(kind: TEventKind, state: int): Uint8 {.cdecl, importc: "SDL_EventState", dynlib: LibName.}
  ## This function allows you to set the state of processing certain events.
  ##
  ## - If ``state`` is set to IGNORE, that event will be automatically
  ## dropped from the event queue and will not event be filtered.
  ##
  ## - If ``state`` is set to ENABLE, that event will be processed normally.
  ##
  ## - If ``state`` is set to QUERY, eventState() will return the
  ## current processing state of the specified event.


template getEventState*(kind: TEventKind): Uint8 =
  eventState(kind, SDL_QUERY)


proc registerEvents*(numevents: int): TEventKind {.cdecl, importc: "SDL_RegisterEvents", dynlib: LibName.}
  ## This function allocates a set of user-defined events, and returns
  ## the beginning event number for that set of events.
  ##
  ## If there aren't enough user-defined events left, this function
  ## returns Uint32(-1)

