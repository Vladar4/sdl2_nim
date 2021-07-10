# ex105_syswm.nim
# ===============
# BASICS / Getting window system info
# -----------------------------------


import sdl2nim/sdl, sdl2nim/sdl_syswm


proc subsys(kind: SysWMKind): string =
  case kind
  of SysWM_Unknown: "an unknown system"
  of SysWM_Windows: "Microsoft Windows"
  of SysWM_X11: "X Window System"
  of SysWM_DirectFB: "DirectFB"
  of SysWM_Cocoa: "Apple OS X"
  of SysWM_UIKit: "UIKit"
  of SysWM_Wayland: "Wayland"
  of SysWM_Mir: "Mir"
  of SysWM_WinRT: "Microsoft Windows RT"
  of SysWM_Android: "Android"
  of SysWM_Vivante: "Vivante"
  of SysWM_OS2: "OS/2"
  of SysWM_Haiku: "Haiku"



discard sdl.init(0)
var window = sdl.createWindow("", 0, 0, 0, 0, sdl.WindowHidden)
var info: SysWMinfo

version(info.version)

if getWindowWMInfo(window, addr(info)):
  echo "This program is running SDL version " &
    $info.version.major.int & "." &
    $info.version.minor.int & "." &
    $info.version.patch.int &
    " on " & subsys(info.subsystem) & "."

else:
  echo "Couldn't get window information : " & $sdl.geterror()

sdl.destroyWindow(window)
sdl.quit()

