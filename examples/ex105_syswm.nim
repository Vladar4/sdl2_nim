# ex105_syswm.nim
# ===============
# BASICS / Getting window system info
# -----------------------------------


import sdl2/sdl, sdl2/sdl_syswm

discard sdl.init(0)
var window = sdl.createWindow("", 0, 0, 0, 0, sdl.WindowHidden)
var info: SysWMinfo

version(info.version)

if getWindowWMInfo(window, addr(info)):
  var subsys: string
  case info.subsystem:
  of SysWM_Unknown: subsys = "an unknown system"
  of SysWM_Windows: subsys = "Microsoft Windows"
  of SysWM_X11: subsys = "X Window System"
  of SysWM_DirectFB: subsys = "DirectFB"
  of SysWM_Cocoa: subsys = "Apple OS X"
  of SysWM_UIKit: subsys = "UIKit"
  of SysWM_Wayland: subsys = "Wayland"
  of SysWM_Mir: subsys = "Mir"
  of SysWM_WinRT: subsys = "Microsoft Windows RT"
  of SysWM_Android: subsys = "Android"

  echo "This program is running SDL version " &
    $info.version.major.int & "." &
    $info.version.minor.int & "." &
    $info.version.patch.int &
    " on " & $subsys & "."

else:
  echo "Couldn't get window information : " & $sdl.geterror()

sdl.destroyWindow(window)
sdl.quit()

