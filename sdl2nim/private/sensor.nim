#
#  Simple DirectMedia Layer
#  Copyright (C) 1997-2020 Sam Lantinga <slouken@libsdl.org>
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

##  sensor.nim
##  ==========
##
##  Include file for SDL sensor event handling.
##
##  In order to use these procedures, ``sdl.init()`` must have been called
##  with the `INIT_SENSOR` flag. This causes SDL to scan the system
##  for sensors, and load appropriate drivers.

type
  Sensor* = pointer

type
  SensorID* = int32 ##  \
    ##  This is a unique ID for a sensor for the time it is connected to the
    ##  system, and is never reused for the lifetime of the application.
    ##
    ##  The ID value starts at `0` and increments from there.
    ##  The value `-1` is an invalid ID.

type
  SensorType* {.size: sizeof(cint).} = enum ##  \
    ##  The different sensors defined by SDL
    ##
    ##  Additional sensors may be available, using platform dependent semantics.
    ##
    ##  Hare are the additional Android sensors:
    ##  https://developer.android.com/reference/android/hardware/SensorEvent.html#values
    SENSOR_INVALID = -1,      ##  Returned for an invalid sensor
    SENSOR_UNKNOWN,           ##  Unknown sensor type
    SENSOR_ACCEL,             ##  Accelerometer
    SENSOR_GYRO               ##  Gyroscope

const
  STANDARD_GRAVITY* = 9.806649999999999

##  Accelerometer sensor
##  --------------------
##
##  The accelerometer returns the current acceleration in SI meters per
##  second squared. This measurement includes the force of gravity, so
##  a device at rest will have an value of `STANDARD_GRAVITY` away
##  from the center of the earth.
##
##  * `values[0]`: Acceleration on the x axis
##  * `values[1]`: Acceleration on the y axis
##  * `values[2]`: Acceleration on the z axis
##
##  For phones held in portrait mode and game controllers held in front of you,
##  the axes are defined as follows:
##  * `-X ... +X`: left ... right
##  * `-Y ... +Y`: bottom ... top
##  * `-Z ... +Z`: farther ... closer
##
##  The axis data is not changed when the phone is rotated.
##
##  See also:
##
##  ``getDisplayOrientation()``
##

##  Gyroscope sensor
##  ----------------
##
##  The gyroscope returns the current rate of rotation in radians per second.
##  The rotation is positive in the counter-clockwise direction. That is,
##  an observer looking from a positive location on one of the axes would
##  see positive rotation on that axis when it appeared to be rotating
##  counter-clockwise.
##
##  * `values[0]`: Angular speed around the x axis (pitch)
##  * `values[1]`: Angular speed around the y axis (yaw)
##  * `values[2]`: Angular speed around the z axis (roll)
##
##  For phones held in portrait mode and game controllers held in front of you,
##  the axes are defined as follows:
##  * `-X ... +X`: left ... right
##  * `-Y ... +Y`: bottom ... top
##  * `-Z ... +Z`: farther ... closer
##
##  The axis data is not changed when the phone or controller is rotated.
##
##  See also:
##
##  ``getDisplayOrientation()``
##

proc lockSensors*() {.cdecl, importc: "SDL_LockSensors", dynlib: SDL2_LIB.}
  ##  Locking for multi-threaded access to the sensor API.
  ##
  ##  If you are using the sensor API or handling events from multiple threads
  ##  you should use these locking procedures to protect access to the sensors.
  ##
  ##  In particular, you are guaranteed that the sensor list won't change, so
  ##  the API procedures that take a sensor index will be valid, and sensor
  ##  events will not be delivered.

proc unlockSensors*() {.cdecl, importc: "SDL_UnlockSensors", dynlib: SDL2_LIB.}
  ##  See ``lockSensors()``

proc numSensors*(): cint {.
    cdecl, importc: "SDL_NumSensors", dynlib: SDL2_LIB.}
  ##  Count the number of sensors attached to the system right now.

proc sensorGetDeviceName*(deviceIndex: cint): cstring {.
    cdecl, importc: "SDL_SensorGetDeviceName", dynlib: SDL2_LIB.}
  ##  Get the implementation dependent name of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Return`` the sensor name, or `nil` if ``device_index`` is out of range.

proc sensorGetDeviceType*(deviceIndex: cint): SensorType {.
    cdecl, importc: "SDL_SensorGetDeviceType", dynlib: SDL2_LIB.}
  ##  Get the type of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Return`` the sensor type,
  ##  or `SENSOR_INVALID` if ``device_index`` is out of range.

proc sensorGetDeviceNonPortableType*(deviceIndex: cint): cint {.
    cdecl, importc: "SDL_SensorGetDeviceNonPortableType", dynlib: SDL2_LIB.}
  ##  Get the platform dependent type of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Return`` the sensor platform dependent type,
  ##  or `-1` if ``device_index`` is out of range.

proc sensorGetDeviceInstanceID*(deviceIndex: cint): SensorID {.
    cdecl, importc: "SDL_SensorGetDeviceInstanceID", dynlib: SDL2_LIB.}
  ##  Get the instance ID of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Return`` the sensor instance ID,
  ##  or `-1` if ``device_index`` is out of range.

proc sensorOpen*(deviceIndex: cint): Sensor {.
    cdecl, importc: "SDL_SensorOpen", dynlib: SDL2_LIB.}
  ##  Open a sensor for use.
  ##
  ##  The index passed as an argument refers to the N'th sensor on the system.
  ##
  ##  ``Return`` a sensor identifier, or `nil` if an error occurred.

proc sensorFromInstanceID*(instanceId: SensorID): Sensor {.
    cdecl, importc: "SDL_SensorFromInstanceID", dynlib: SDL2_LIB.}
  ##  Return the SDL_Sensor associated with an instance id.

proc sensorGetName*(sensor: Sensor): cstring {.
    cdecl, importc: "SDL_SensorGetName", dynlib: SDL2_LIB.}
  ##  Get the implementation dependent name of a sensor.
  ##
  ##  ``Return`` The sensor name, or `nil` if the sensor is `nil`.

proc sensorGetType*(sensor: Sensor): SensorType {.cdecl,
    importc: "SDL_SensorGetType", dynlib: SDL2_LIB.}
  ##  Get the type of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Return`` The sensor type, or `SENSOR_INVALID` if the sensor is `nil`.

proc sensorGetNonPortableType*(sensor: Sensor): cint {.
    cdecl, importc: "SDL_SensorGetNonPortableType", dynlib: SDL2_LIB.}
  ##  Get the platform dependent type of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Rturn`` The sensor platform dependent type,
  ##  or `-1` if the sensor is `nil`.

proc sensorGetInstanceID*(sensor: Sensor): SensorID {.
    cdecl, importc: "SDL_SensorGetInstanceID", dynlib: SDL2_LIB.}
  ##  Get the instance ID of a sensor.
  ##
  ##  This can be called before any sensors are opened.
  ##
  ##  ``Return`` The sensor instance ID, or `-1` if the sensor is `nil`.

proc sensorGetData*(sensor: Sensor; data: ptr cfloat; numValues: cint): cint {.
    cdecl, importc: "SDL_SensorGetData", dynlib: SDL2_LIB.}
  ##  Get the current state of an opened sensor.
  ##
  ##  The number of values and interpretation of the data is sensor dependent.
  ##
  ##  ``sensor`` The sensor to query
  ##
  ##  ``data`` A pointer filled with the current sensor state
  ##
  ##  ``num_values`` The number of values to write to data
  ##
  ##  ``Return`` `0` or `-1` if an error occurred.

proc sensorClose*(sensor: Sensor) {.
    cdecl, importc: "SDL_SensorClose", dynlib: SDL2_LIB.}
  ##  Close a sensor previously opened with ``sensorOpen()``.

proc sensorUpdate*() {.
    cdecl, importc: "SDL_SensorUpdate", dynlib: SDL2_LIB.}
  ##  Update the current state of the open sensors.
  ##
  ##  This is called automatically by the event loop
  ##  if sensor events are enabled.
  ##
  ##  This needs to be called from the thread
  ##  that initialized the sensor subsystem.

