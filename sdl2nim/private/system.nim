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

##  system.nim
##  ==========
##
##  Include file for platform specific SDL API procedures.

# Platform specific procedures for Windows
when defined windows:

  type
    WindowsMessageHook* = proc (userdata: pointer; hWnd: pointer;
      message: cuint; wParam: uint64; lParam: int64) {.cdecl.}

  proc setWindowsMessageHook*(
    callback: WindowsMessageHook; userdata: pointer) {.
      cdecl, importc: "SDL_SetWindowsMessageHook", dynlib: SDL2_LIB.}
    ##  Set a procedure that is called for every windows message,
    ##  before ``translateMessage()``.

  proc direct3D9GetAdapterIndex*(displayIndex: cint): cint {.
      cdecl, importc: "SDL_Direct3D9GetAdapterIndex", dynlib: SDL2_LIB.}
    ##  Returns the D3D9 adapter index that matches the specified display
    ##  index. This adapter index can be passed to IDirect3D9::CreateDevice
    ##  and controls on which monitor a full screen application will appear.

  type
    IDirect3DDevice9* = pointer

  proc renderGetD3D9Device*(renderer: ptr Renderer): IDirect3DDevice9 {.
      cdecl, importc: "SDL_RenderGetD3D9Device", dynlib: SDL2_LIB.}
    ##  Returns the D3D device associated with a renderer, or `nil` if it's not
    ##  a D3D renderer. Once you are done using the device, you should release
    ##  it to avoid a resource leak.

  proc dXGIGetOutputInfo*(
    displayIndex: cint; adapterIndex: ptr cint; outputIndex: ptr cint): bool {.
      cdecl, importc: "SDL_DXGIGetOutputInfo", dynlib: SDL2_LIB.}
    ##  Returns the DXGI Adapter and Output indices for the specified display
    ##  index. These can be passed to EnumAdapters and EnumOutputs respectively
    ##  to get the objects required to create a DX10 or DX11 device and swap
    ##  chain.

when (defined linux) or (hostOS == "linux"):

  proc linuxSetThreadPriority*(threadID: int64; priority: cint): cint {.
    cdecl, importc: "SDL_LinuxSetThreadPriority", dynlib: SDL2_LIB.}
  ##  Sets the UNIX nice value for a thread,
  ##  using ``setpriority()`` if possible, and RealtimeKit if available.
  ##
  ##  ``Return`` `0` on success, or `-1` on error.


#FIXME: needs testing

# Platform specific procedures for iOS
when defined iphoneos:
  template iOSSetAnimationCallback*(
      window, interval, callback, callbackParam: untyped): untyped =
    iPhoneSetAnimationCallback(window, interval, callback, callbackParam)

  proc iPhoneSetAnimationCallback*(
      window: Window; interval: cint;
      callback: proc (a2: pointer) {.cdecl.};
      callbackParam: pointer): cint {.
        cdecl, importc: "SDL_iPhoneSetAnimationCallback", dynlib: SDL2_LIB.}

  template iOSSetEventPump*(enabled: untyped): untyped =
    iPhoneSetEventPump(enabled)

  proc iPhoneSetEventPump*(enabled: bool) {.
      cdecl, importc: "SDL_iPhoneSetEventPump", dynlib: SDL2_LIB.}

# ^ when defined iphoneos

# Platform specific procedures for Android
when defined android:

  proc androidGetJNIEnv*(): pointer {.
      cdecl, importc: "SDL_AndroidGetJNIEnv", dynlib: SDL2_LIB.}
    ##  Get the JNI environment for the current thread
    ##  This returns ``ptr JNIEnv``, but the prototype is ``pointer``
    ##  so we don't need jni.h

  proc androidGetActivity*(): pointer {.
      cdecl, importc: "SDL_AndroidGetActivity", dynlib: SDL2_LIB.}
    ##  Get the SDL Activity object for the application
    ##  This returns jobject, but the prototype is ``pointer``
    ##  so we don't need jni.h
    ##  The jobject returned by ``androidGetActivity()`` is a local reference.
    ##  It is the caller's responsibility to properly release it
    ##  (using env->Push/PopLocalFrame or manually with env->DeleteLocalRef)
    ##
    ##  See the official Android developer guide for more information:
    ##  http://developer.android.com/guide/topics/data/data-storage.html

  proc getAndroidSDKVersion*(): cint {.
      cdecl, importc: "SDL_GetAndroidSDKVersion", dynlib: SDL2_LIB.}
    ##  Return API level of the current device:
    ##  * API level 30: Android 11
    ##  * API level 29: Android 10
    ##  * API level 28: Android 9
    ##  * API level 27: Android 8.1
    ##  * API level 26: Android 8.0
    ##  * API level 25: Android 7.1
    ##  * API level 24: Android 7.0
    ##  * API level 23: Android 6.0
    ##  * API level 22: Android 5.1
    ##  * API level 21: Android 5.0
    ##  * API level 20: Android 4.4W
    ##  * API level 19: Android 4.4
    ##  * API level 18: Android 4.3
    ##  * API level 17: Android 4.2
    ##  * API level 16: Android 4.1
    ##  * API level 15: Android 4.0.3
    ##  * API level 14: Android 4.0
    ##  * API level 13: Android 3.2
    ##  * API level 12: Android 3.1
    ##  * API level 11: Android 3.0
    ##  * API level 10: Android 2.3.3

  proc isAndroidTV*(): bool {.
      cdecl, importc: "SDL_IsAndroidTV", dynlib: SDL2_LIB.}
    ##  ``Return`` `true` if the application is running on Android TV.

  proc isChromebook*(): bool {.
      cdecl, importc: "SDL_IsChromebook", dynlib: SDL2_LIB.}
    ##  ``Return`` `true` if the application is running on a Chromebook.

  proc isDeXMode*(): bool {.
      cdecl, importc: "SDL_IsDeXMode", dynlib: SDL2_LIB.}
    ##  ``Return`` `true` is the application is running on a Samsung DeX
    ##  docking station.

  proc androidBackButton*() {.
      cdecl, importc: "SDL_AndroidBackButton", dynlib: SDL2_LIB.}
    ##  Trigger the Android system back button behavior.

  const
    ANDROID_EXTERNAL_STORAGE_READ* = 0x00000001
    ANDROID_EXTERNAL_STORAGE_WRITE* = 0x00000002  ##  \
      ##  See the official Android developer guide for more information:
      ##  http://developer.android.com/guide/topics/data/data-storage.html

  proc androidGetInternalStoragePath*(): cstring {.
      cdecl, importc: "SDL_AndroidGetInternalStoragePath", dynlib: SDL2_LIB.}
    ##  Get the path used for internal storage for this application.
    ##  This path is unique to your application and cannot be written to
    ##  by other applications.

  proc androidGetExternalStorageState*(): cint {.
      cdecl, importc: "SDL_AndroidGetExternalStorageState", dynlib: SDL2_LIB.}
    ##  Get the current state of external storage, a bitmask of these values:
    ##  * `ANDROID_EXTERNAL_STORAGE_READ`
    ##  * `ANDROID_EXTERNAL_STORAGE_WRITE`
    ##
    ##  If external storage is currently unavailable, this will return `0`.

  proc androidGetExternalStoragePath*(): cstring {.
      cdecl, importc: "SDL_AndroidGetExternalStoragePath", dynlib: SDL2_LIB.}
    ##  Get the path used for external storage for this application.
    ##  This path is unique to your application, but is public and can be
    ##  written to by other applications.

  proc androidRequestPermission(permission: cstring): bool {.
      cdecl, importc: "SDL_AndroidRequestPermission", dynlib: SDL2_LIB.}
    ##  Request permissions at runtime.
    ##
    ##  This blocks the calling thread until the permission is granted or
    ##  denied. Returns `true` if the permission was granted.

# ^ when defined android

# Platform specific procedures for WinRT
when defined winrt:

  type
    WinRT_Path* {.size: sizeof(cint).} = enum ##  \
      ##  WinRT / Windows Phone path types
      WINRT_PATH_INSTALLED_LOCATION,##  The installed app's root directory.
        ##  Files here are likely to be read-only.
      WINRT_PATH_LOCAL_FOLDER,      ##  The app's local data store.
        ##  Files may be written here
      WINRT_PATH_ROAMING_FOLDER,    ##  The app's roaming data store.
        ##  Unsupported on Windows Phone.
        ##  Files written here may be copied to other machines
        ##  via a network connection.
      WINRT_PATH_TEMP_FOLDER        ##  The app's temporary data store.
        ##  Unsupported on Windows Phone.
        ##  Files written here may be deleted at any time.

  type
    WinRT_DeviceFamily* {.size: sizeof(cint).} = enum ##  \
      ##  WinRT Device Family
      WINRT_DEVICEFAMILY_UNKNOWN, ##  Unknown family
      WINRT_DEVICEFAMILY_DESKTOP, ##  Desktop family
      WINRT_DEVICEFAMILY_MOBILE,  ##  Mobile family (for example smartphone)
      WINRT_DEVICEFAMILY_XBOX     ##  XBox family

  proc winRTGetFSPathUNICODE*(pathType: WinRT_Path): ptr wchar_t {.
      cdecl, importc: "SDL_WinRTGetFSPathUNICODE", dynlib: SDL2_LIB.}
    ##  Retrieves a WinRT defined path on the local file system
    ##
    ##  ``Note`` Documentation on most app-specific path types on WinRT
    ##  can be found on MSDN, at the URL:
    ##  http://msdn.microsoft.com/en-us/library/windows/apps/hh464917.aspx
    ##
    ##  ``pathType`` The type of path to retrieve.
    ##
    ##  ``Return`` a UCS-2 string (16-bit, wide-char) containing the path,
    ##  or `nil` if the path is not available for any reason.
    ##  Not all paths are available on all versions of Windows.
    ##  This is especially true on Windows Phone.
    ##  Check the documentation for the given ``WinRT_Path``
    ##  for more information on which path types are supported where.

  proc winRTGetFSPathUTF8*(pathType: WinRT_Path): cstring {.
      cdecl, importc: "SDL_WinRTGetFSPathUTF8", dynlib: SDL2_LIB.}
    ##  Retrieves a WinRT defined path on the local file system
    ##
    ##  ``Note`` Documentation on most app-specific path types on WinRT
    ##  can be found on MSDN, at the URL:
    ##  http://msdn.microsoft.com/en-us/library/windows/apps/hh464917.aspx
    ##
    ##  ``pathType`` The type of path to retrieve.
    ##
    ##  ``Return`` a UTF-8 string (8-bit, multi-byte) containing the path,
    ##  or `nil` if the path is not available for any reason.
    ##  Not all paths are available on all versions of Windows.
    ##  This is especially true on Windows Phone.
    ##  Check the documentation for the given ``WinRT_Path``
    ##  for more information on which path types are supported where.

  proc winRTGetDeviceFamily(): WinRT_DeviceFamily {.
      cdecl, importc: "SDL_WinRTGetDeviceFamily", dynlib: SDL2_LIB.}
    ##  Detects the device family of WinRT plattform on runtime.
    ##
    ##  ``Return`` device family.

# ^ when defined winrt

proc isTablet*(): bool {.
    cdecl, importc: "SDL_IsTablet", dynlib: SDL2_LIB.}
  ##  ``Return`` `true` if the current device is a tablet.


# Procedures used by iOS application delegates to notify SDL about state changes

proc onApplicationWillTerminate*() {.
  cdecl, importc: "SDL_OnApplicationWillTerminate", dynlib: SDL2_LIB.}

proc onApplicationDidReceiveMemoryWarning*() {.
  cdecl, importc: "SDL_OnApplicationDidReceiveMemoryWarning", dynlib: SDL2_LIB.}

proc onApplicationWillResignActive*() {.
  cdecl, importc: "SDL_OnApplicationWillResignActive", dynlib: SDL2_LIB.}

proc onApplicationDidEnterBackground*() {.
  cdecl, importc: "SDL_OnApplicationDidEnterBackground", dynlib: SDL2_LIB.}

proc onApplicationWillEnterForeground*() {.
  cdecl, importc: "SDL_OnApplicationWillEnterForeground", dynlib: SDL2_LIB.}

proc onApplicationDidBecomeActive*() {.
  cdecl, importc: "SDL_OnApplicationDidBecomeActive", dynlib: SDL2_LIB.}

when defined iphoneos:
  proc onApplicationDidChangeStatusBarOrientation*() {.
    cdecl, importc: "SDL_OnApplicationDidChangeStatusBarOrientation",
    dynlib: SDL2_LIB.}
