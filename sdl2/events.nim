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
  
  FIRSTEVENT* = 0 ## Unused (do not remove)
  
  # Application events
  
  QUITEVENT* = 0x100 ## User-requested quit
  
  # These application events have special meaning on iOS, see README.iOS for details
  
  APP_TERMINATING* = 0x101
    ## The application is being terminated by the OS
    ## Called on iOS in applicationWillTerminate()
    ## Called on Android in onDestroy()

  APP_LOWMEMORY* = 0x102
    ## The application is low on memory, free memory if possible.
    ## Called on iOS in applicationDidReceiveMemoryWarning()
    ## Called on Android in onLowMemory()

  APP_WILLENTERBACKGROUND* = 0x103
    ## The application is about to enter the background
    ## Called on iOS in applicationWillResignActive()
    ## Called on Android in onPause()

  APP_DIDENTERBACKGROUND* = 0x104
    ## The application did enter the background and may not get CPU for some time
    ## Called on iOS in applicationDidEnterBackground()
    ## Called on Android in onPause()

  APP_WILLENTERFOREGROUND* = 0x105
    ## The application is about to enter the foreground
    ## Called on iOS in applicationWillEnterForeground()
    ## Called on Android in onResume()

  APP_DIDENTERFOREGROUND* = 0x106
    ## The application is now interactive
    ## Called on iOS in applicationDidBecomeActive()
    ## Called on Android in onResume()
    
  # Window events
  
  WINDOWEVENT* = 0x200 ## Window state change

  SYSWMEVENT* = 0x201 ## System specific event
    
  # Keyboard events
  
  KEYDOWN* = 0x300 ## Key pressed

  KEYUP* = 0x301 ## Key released

  TEXTEDITING* = 0x302 ## Keyboard text editing (composition)

  TEXTINPUT* = 0x303 ## Keyboard text input
  
  # Mouse events
  
  MOUSEMOTION* = 0x400 ## Mouse moved

  MOUSEBUTTONDOWN* = 0x401 ## Mouse button pressed

  MOUSEBUTTONUP* = 0x402 ## Mouse button released

  MOUSEWHEEL* = 0x403 ## Mouse wheel motion
  
  # Joystick events

  JOYAXISMOTION* = 0x600 ## Joystick axis motion

  JOYBALLMOTION* = 0x601 ## Joystick trackball motion

  JOYHATMOTION* = 0x602 ## Joystick hat position change

  JOYBUTTONDOWN* = 0x603 ## Joystick button pressed

  JOYBUTTONUP* = 0x604 ## Joystick button released

  JOYDEVICEADDED* = 0x605 ## A new joystick has been inserted into the system

  JOYDEVICEREMOVED* = 0x606 ## An opened joystick has been removed
  
  # Game controller events
  
  CONTROLLERAXISMOTION* = 0x650 ## Game controller axis motion

  CONTROLLERBUTTONDOWN* = 0x651 ## Game controller button pressed

  CONTROLLERBUTTONUP* = 0x652 ## Game controller button released

  CONTROLLERDEVICEADDED* = 0x653 ## A new Game controller has been inserted into the system

  CONTROLLERDEVICEREMOVED* = 0x654 ## An opened Game controller has been removed

  CONTROLLERDEVICEREMAPPED* = 0x655 ## The controller mapping was updated
  
  # Touch events
  
  FINGERDOWN* = 0x700

  FINGERUP* = 0x701

  FINGERMOTION* = 0x702
  
  # Gesture events

  DOLLARGESTURE* = 0x800

  DOLLARRECORD* = 0x801

  MULTIGESTURE* = 0x802
  
  # Clipboard events

  CLIPBOARDUPDATE* = 0x900 ## The clipboard changed
  
  # Drag and drop events

  DROPFILE* = 0x1000 ## The system requests a file open
  
  USEREVENT* = 0x8000 ## Events USEREVENT through LASTEVENT are for your use, and should be allocated with registerEvents()

  LASTEVENT* = 0xFFFF ## This last event is only for bounding internal arrays


type

  TCommonEvent*{.bycopy.} = object
    ## Fields shared by every event
    kind*: Uint32
    timestamp*: Uint32


  TWindowEvent*{.bycopy.} = object
    ## Window state change event data (event.window.*)
    kind*: Uint32 ## WINDOWEVENT
    timestamp*: Uint32
    windowID*: Uint32 ## The associated window
    event*: Uint8 ## TWindowEventID
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    data1*: int32 ## event dependent data
    data2*: int32 ## event dependent data


  TKeyboardEvent*{.bycopy.} = object
    ## Keyboard button event structure (event.key.*)
    kind*: Uint32 ## KEYDOWN or KEYUP
    timestamp*: Uint32
    windowID*: Uint32 ## The window with keyboard focus, if any
    state*: Uint8 ## PRESSED or RELEASED
    repeat*: Uint8 ## Non-zero if this is a key repeat
    padding2*: Uint8
    padding3*: Uint8
    keysym*: TKeysym ## The key that was pressed or released


  TTextEditingEvent*{.bycopy.} = object
    ## Keyboard text editing event structure (event.edit.*)
    kind*: Uint32 ## TEXTEDITING
    timestamp*: Uint32
    windowID*: Uint32 ## The window with keyboard focus, if any
    text*: array[0..TEXTEDITINGEVENT_TEXT_SIZE-1, char] ## The editing text
    start*: int32 ## The start cursor of selected editing text
    length*: int32 ## The length of selected editing text


  TTextInputEvent*{.bycopy.} = object
    ## Keyboard text input event structure (event.text.*)
    kind*: Uint32 ## TEXTINPUT
    timestamp*: Uint32
    windowID*: Uint32 ## The window with keyboard focus, if any
    text*: array[0..TEXTINPUTEVENT_TEXT_SIZE-1, char] ## The input text


  TMouseMotionEvent*{.bycopy.} = object
    ## Mouse motion event structure (event.motion.*)
    kind*: Uint32 ## MOUSEMOTION
    timestamp*: Uint32
    windowID*: Uint32 ## The window with mouse focus, if any
    which*: Uint32 ## The mouse instance id, or TOUCH_MOUSEID
    state*: Uint32 ## The current button state
    x*: int32 ## X coordinate, relative to window
    y*: int32 ## Y coordinate, relative to window
    xrel*: int32 ## The relative motion in the X direction
    yrel*: int32 ## The relative motion in the Y direction


  TMouseButtonEvent*{.bycopy.} = object
    ## Mouse button event structure (event.button.*)
    kind*: Uint32 ## MOUSEBUTTONDOWN or MOUSEBUTTONUP
    timestamp*: Uint32
    windowID*: Uint32 ## The window with mouse focus, if any
    which*: Uint32 ## The mouse instance id, or TOUCH_MOUSEID
    button*: Uint8 ## The mouse button index
    state*: Uint8 ## PRESSED or RELEASED
    padding1*: Uint8
    padding2*: Uint8
    x*: int32 ## X coordinate, relative to window
    y*: int32 ## Y coordinate, relative to window


  TMouseWheelEvent*{.bycopy.} = object
    ## Mouse wheel event structure (event.wheel.*)
    kind*: Uint32 ## MOUSEWHEEL
    timestamp*: Uint32
    windowID*: Uint32 ## The window with mouse focus, if any
    which*: Uint32 ## The mouse instance id, or TOUCH_MOUSEID
    x*: int32 ## The amount scrolled horizontally
    y*: int32 ## The amount scrolled vertically


  TJoyAxisEvent*{.bycopy.} = object
    ## Joystick axis motion event structure (event.jaxis.*)
    kind*: Uint32 ## JOYAXISMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    axis*: Uint8 ## The joystick axis index
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    value*: int16 ## The axis value (range: -32768 to 32767)
    padding4*: int16


  TJoyBallEvent*{.bycopy.} = object
    ## Joystick trackball motion event structure (event.jball.*)
    kind*: Uint32 ## JOYBALLMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    ball*: Uint8 ## The joystick trackball index
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    xrel*: int16 ## The relative motion in the X direction
    yrel*: int16 ## The relative motion in the Y direction


  TJoyHatEvent*{.bycopy.} = object
    ## Joystick hat position change event structure (event.jhat.*)
    kind*: Uint32 ## JOYHATMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    hat*: Uint8 ## The joystick hat index
    value*: Uint8 ## The hat position value. See also: HAT_LEFTUP, HAT_UP, HAT_RIGHTUP, HAT_LEFT, HAT_CENTERED, HAT_RIGHT, HAT_LEFTDOWN, HAT_DOWN, HAT_RIGHTDOWN. Note that zero means the POV is centered.
    padding1*: Uint8
    padding2*: Uint8


  TJoyButtonEvent*{.bycopy.} = object
    ## Joystick button event structure (event.jbutton.*)
    kind*: Uint32 ## JOYBUTTONDOWN or JOYBUTTONUP
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    button*: Uint8 ## The joystick button index
    state*: Uint8 ## PRESSED or RELEASED
    padding1*: Uint8
    padding2*: Uint8


  TJoyDeviceEvent*{.bycopy.} = object
    ## Joystick device event structure (event.jdevice.*)
    kind*: Uint32 ## JOYDEVICEADDED or JOYDEVICEREMOVED
    timestamp*: Uint32
    which*: int32 ## The joystick device index for the ADDED event, instance id for the REMOVED event


  TControllerAxisEvent*{.bycopy.} = object
    ## Game controller axis motion event structure (event.caxis.*)
    kind*: Uint32 ## CONTROLLERAXISMOTION
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    axis*: Uint8 ## The controller axis (TGameControllerAxis)
    padding1*: Uint8
    padding2*: Uint8
    padding3*: Uint8
    value*: int16 ## The axis value (range: -32768 to 32767)
    padding4*: int16


  TControllerButtonEvent*{.bycopy.} = object
    ## Game controller button event structure (event.cbutton.*)
    kind*: Uint32 ## CONTROLLERBUTTONDOWN or CONTROLLERBUTTONUP
    timestamp*: Uint32
    which*: TJoystickID ## The joystick instance id
    button*: Uint8 ## The controller button (TGameControllerButton)
    state*: Uint8 ## PRESSED or RELEASED
    padding1*: Uint8
    padding2*: Uint8


  TControllerDeviceEvent*{.bycopy.} = object
    ## Controller device event structure (event.cdevice.*)
    kind*: Uint32 ## CONTROLLERDEVICEADDED, CONTROLLERDEVICEREMOVED, or CONTROLLERDEVICEREMAPPED
    timestamp*: Uint32
    which*: int32 ## The joystick device index for the ADDED event, instance id for the REMOVED or REMAPPED event


  TTouchFingerEvent*{.bycopy.} = object
    ## Touch finger event structure (event.tfinger.*)
    kind*: Uint32 ## FINGERMOTION or FINGERDOWN or FINGERUP
    timestamp*: Uint32
    touchId*: TTouchID ## The touch device id
    fingerID*: TFingerID
    x*: float ## Normalized in the range 0...1
    y*: float ## Normalized in the range 0...1
    dx*: float ## Normalized in the range 0...1
    dy*: float ## Normalized in the range 0...1
    pressure*: float ## Normalized in the range 0...1


  TMultiGestureEvent*{.bycopy.} = object
    ## Multiple Finger Gesture Event (event.mgesture.*)
    kind*: Uint32 ## MULTIGESTURE
    timestamp*: Uint32
    touchId*: TTouchID ## The touch device index
    dTheta*: float
    dDist*: float
    x*: float
    y*: float
    numFingers*: Uint16
    padding*: Uint16


  TDollarGestureEvent*{.bycopy.} = object
    ## (event.dgesture.*)
    kind*: Uint32 ## DOLLARGESTURE
    timestamp*: Uint32
    touchId*: TTouchID ## The touch device id
    gestureId*: TGestureID
    numFingers*: Uint32
    error*: float
    x*: float ## Normalized center of gesture
    y*: float ## Normalized center of gesture


  TDropEvent*{.bycopy.} = object
    ## An event used to request a file open by the system (event.drop.*)
    ##
    ## This event is disabled by default, you can enable it with eventState()
    ##
    ##If you enable this event, you must free the filename in the event.
    kind*: Uint32 ## DROPFILE
    timestamp*: Uint32
    file*: cstring ## The file name, which should be freed with free()


  TQuitEvent*{.bycopy.} = object
    ## The "quit requested" event
    kind*: Uint32 ## QUIT
    timestamp*: Uint32


  TOSEvent*{.bycopy.} = object
    ## OS Specific event
    kind*: Uint32 ## QUIT
    timestamp*: Uint32


  TUserEvent*{.bycopy.} = object
    ## A user-defined event type (event.user.*)
    kind*: Uint32 ## USEREVENT through NUMEVENTS-1
    timestamp*: Uint32
    windowID*: Uint32 ## The associated window if any
    code*: int32 ## User defined event code
    data1*: pointer ## User defined data pointer
    data2*: pointer ## User defined data pointer


  PSysWMmsg* = pointer


  TSysWMEvent*{.bycopy.} = object
    ## A video driver dependent system event (event.syswm.*)
    ##
    ## This event is disabled by default, you can enable it with eventState()
    ##
    ## If you want to use this event, you should include syswm.h.
    kind*: Uint32 ## SYSWMEVENT
    timestamp*: Uint32
    msg*: PSysWMmsg ## driver dependent data, defined in syswm.h

  
  PEvent* = ptr TEvent
  TEvent*{.bycopy.} = object
    kind*: Uint32
    timestamp*: Uint32
    data*: array[0..47, byte]


#typedef union SDL_Event
# *  \brief General event structure
#{
#    Uint32 type;                    /**< Event type, shared with all events */
#    SDL_CommonEvent common;         /**< Common event data */
#    SDL_WindowEvent window;         /**< Window event data */
#    SDL_KeyboardEvent key;          /**< Keyboard event data */
#    SDL_TextEditingEvent edit;      /**< Text editing event data */
#    SDL_TextInputEvent text;        /**< Text input event data */
#    SDL_MouseMotionEvent motion;    /**< Mouse motion event data */
#    SDL_MouseButtonEvent button;    /**< Mouse button event data */
#    SDL_MouseWheelEvent wheel;      /**< Mouse wheel event data */
#    SDL_JoyAxisEvent jaxis;         /**< Joystick axis event data */
#    SDL_JoyBallEvent jball;         /**< Joystick ball event data */
#    SDL_JoyHatEvent jhat;           /**< Joystick hat event data */
#    SDL_JoyButtonEvent jbutton;     /**< Joystick button event data */
#    SDL_JoyDeviceEvent jdevice;     /**< Joystick device change event data */
#    SDL_ControllerAxisEvent caxis;      /**< Game Controller axis event data */
#    SDL_ControllerButtonEvent cbutton;  /**< Game Controller button event data */
#    SDL_ControllerDeviceEvent cdevice;  /**< Game Controller device event data */
#    SDL_QuitEvent quit;             /**< Quit request event data */
#    SDL_UserEvent user;             /**< Custom event data */
#    SDL_SysWMEvent syswm;           /**< System dependent window event data */
#    SDL_TouchFingerEvent tfinger;   /**< Touch finger event data */
#    SDL_MultiGestureEvent mgesture; /**< Gesture event data */
#    SDL_DollarGestureEvent dgesture; /**< Gesture event data */
#    SDL_DropEvent drop;             /**< Drag and drop event data */
#
#    /* This is necessary for ABI compatibility between Visual C++ and GCC
#       Visual C++ will respect the push pack pragma and use 52 bytes for
#       this structure, and GCC will use the alignment of the largest datatype
#       within the union, which is 8 bytes.
#
#       So... we'll add padding to force the size to be 56 bytes for both.
#    */
#    Uint8 padding[56];
#} SDL_Event;







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
    minType, maxType: Uint32): int {.cdecl, importc: "SDL_PeepEvents", dynlib: LibName.}
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


proc hasEvent*(kind: Uint32): bool {.cdecl, importc: "SDL_HasEvent", dynlib: LibName.}
  ## checks to see if certain event types are in the event queue.


proc hasEvents*(minType, maxType: Uint32): bool {.cdecl, importc: "SDL_HasEvents", dynlib: LibName.}
  ## Checks to see if certain event types are in the event queue.


proc flushEvent*(kind: Uint32) {.cdecl, importc: "SDL_FlushEvent", dynlib: LibName.}
  ## This function clears events from the event queue


proc flushEvents*(minType, maxType: Uint32) {.cdecl, importc: "SDL_FlushEvents", dynlib: LibName.}
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


proc eventState*(kind: Uint32, state: int): Uint8 {.cdecl, importc: "SDL_EventState", dynlib: LibName.}
  ## This function allows you to set the state of processing certain events.
  ##
  ## - If ``state`` is set to IGNORE, that event will be automatically
  ## dropped from the event queue and will not event be filtered.
  ##
  ## - If ``state`` is set to ENABLE, that event will be processed normally.
  ##
  ## - If ``state`` is set to QUERY, eventState() will return the
  ## current processing state of the specified event.


template getEventState*(kind: Uint32): Uint8 =
  eventState(kind, SDL_QUERY)


proc registerEvents*(numevents: int): Uint32 {.cdecl, importc: "SDL_RegisterEvents", dynlib: LibName.}
  ## This function allocates a set of user-defined events, and returns
  ## the beginning event number for that set of events.
  ##
  ## If there aren't enough user-defined events left, this function
  ## returns Uint32(-1)

