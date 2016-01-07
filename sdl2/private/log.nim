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

##  log.nim
##  =======
##
##  Simple log messages with categories and priorities.
##
##  By default logs are quiet, but if you're debugging SDL you might want:
##
##      ``logSetAllPriority(LOG_PRIORITY_WARN)``
##
##  Here's where the messages go on different platforms:
##
##      Windows: debug output stream
##
##      Android: log output
##
##      Others: standard error output (stderr)

const
  MAX_LOG_MESSAGE* = 4096 ##  \
  ##  The maximum size of a log message
  ##
  ##  Messages longer than the maximum size will be truncated


type
  LogCategory* {.size: sizeof(cint).} = enum  ##  \
    ##  The predefined log categories
    ##
    ##  By default the application category is enabled at the `INFO` level,
    ##  the assert category is enabled at the `WARN` level, test is enabled
    ##  at the `VERBOSE` level and all other categories are enabled at the
    ##  `CRITICAL` level.
    LOG_CATEGORY_APPLICATION = 0,
    LOG_CATEGORY_ERROR = 1,
    LOG_CATEGORY_ASSERT = 2,
    LOG_CATEGORY_SYSTEM = 3,
    LOG_CATEGORY_AUDIO = 4,
    LOG_CATEGORY_VIDEO = 5,
    LOG_CATEGORY_RENDER = 6,
    LOG_CATEGORY_INPUT = 7,
    LOG_CATEGORY_TEST = 8, ## Reserved for future SDL library use
    LOG_CATEGORY_RESERVED1 = 9,
    LOG_CATEGORY_RESERVED2 = 10,
    LOG_CATEGORY_RESERVED3 = 11,
    LOG_CATEGORY_RESERVED4 = 12,
    LOG_CATEGORY_RESERVED5 = 13,
    LOG_CATEGORY_RESERVED6 = 14,
    LOG_CATEGORY_RESERVED7 = 15,
    LOG_CATEGORY_RESERVED8 = 16,
    LOG_CATEGORY_RESERVED9 = 17,
    LOG_CATEGORY_RESERVED10 = 18, ##  \
      ##  Beyond this point is reserved for application use, e.g.
      ##
      ##  .. code-block:: nim
      ##    type
      ##      MYAPP_CATEGORY = enum
      ##        MYAPP_CATEGORY_AWESOME1 = LOG_CATEGORY_CUSTOM,
      ##        MYAPP_CATEGORY_AWESOME2,
      ##        MYAPP_CATEGORY_AWESOME3
    LOG_CATEGORY_CUSTOM = 19

  LogPriority* {.size: sizeof(cint).} = enum ##  \
    ##  The predefined log priorities
    LOG_PRIORITY_VERBOSE = 1,
    LOG_PRIORITY_DEBUG,
    LOG_PRIORITY_INFO,
    LOG_PRIORITY_WARN,
    LOG_PRIORITY_ERROR,
    LOG_PRIORITY_CRITICAL,
    NUM_LOG_PRIORITIES

proc logSetAllPriority*(priority: LogPriority) {.
    cdecl, importc: "SDL_LogSetAllPriority", dynlib: SDL2_LIB.}
  ##  Set the priority of all log categories.

proc logSetPriority*(category: LogCategory; priority: LogPriority) {.
    cdecl, importc: "SDL_LogSetPriority", dynlib: SDL2_LIB.}
  ##  Set the priority of a particular log category.

proc logGetPriority*(category: LogCategory): LogPriority {.
    cdecl, importc: "SDL_LogGetPriority", dynlib: SDL2_LIB.}
  ##  Get the priority of a particular log category.

proc logResetPriorities*() {.
    cdecl, importc: "SDL_LogResetPriorities", dynlib: SDL2_LIB.}
  ##  Reset all priorities to default.
  ##
  ##  This is called in ``quit()``.

proc log*(fmt: cstring) {.
    varargs, cdecl, importc: "SDL_Log", dynlib: SDL2_LIB.}
  ##  Log a message with `LOG_CATEGORY_APPLICATION` and `LOG_PRIORITY_INFO`.

proc logVerbose*(category: LogCategory; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogVerbose", dynlib: SDL2_LIB.}
  ##  Log a message with `LOG_PRIORITY_VERBOSE`.

proc logDebug*(category: LogCategory; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogDebug", dynlib: SDL2_LIB.}
  ##  Log a message with `LOG_PRIORITY_DEBUG`.

proc logInfo*(category: LogCategory; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogInfo", dynlib: SDL2_LIB.}
  ##  Log a message with `LOG_PRIORITY_INFO`.

proc logWarn*(category: LogCategory; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogWarn", dynlib: SDL2_LIB.}
  ##  Log a message with LOG_PRIORITY_WARN.

proc logError*(category: LogCategory; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogError", dynlib: SDL2_LIB.}
  ##  Log a message with `LOG_PRIORITY_ERROR`.

proc logCritical*(category: LogCategory; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogCritical", dynlib: SDL2_LIB.}
  ##  Log a message with `LOG_PRIORITY_CRITICAL`.

proc logMessage*(category: LogCategory; priority: LogPriority; fmt: cstring) {.
    varargs, cdecl, importc: "SDL_LogMessage", dynlib: SDL2_LIB.}
  ##  Log a message with the specified category and priority.

#TODO deal with va_list
#  proc logMessageV*(
#      category: LogCategory; priority: LogPriority;
#      fmt: cstring; ap: va_list) {.
#        cdecl, importc: "SDL_LogMessageV", dynlib: SDL2_LIB.}
#    ##  Log a message with the specified category and priority.

type
  LogOutputFunction* = proc (userdata: pointer; category: LogCategory;
      priority: LogPriority; message: cstring) {.cdecl.}
    ##  The prototype for the log output procedure.

proc logGetOutputFunction*(
    callback: ptr LogOutputFunction; userdata: ptr pointer) {.
    cdecl, importc: "SDL_LogGetOutputFunction", dynlib: SDL2_LIB.}
  ##  Get the current log output procedure.

proc logSetOutputFunction*(callback: LogOutputFunction; userdata: pointer) {.
    cdecl, importc: "SDL_LogSetOutputFunction", dynlib: SDL2_LIB.}
  ##  This procedure allows you to replace the default log output
  ##  procedure with one of your own.
