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
# Simple log messages with categories and priorities.
#
# By default logs are quiet, but if you're debugging SDL you might want:
#
#   logSetAllPriority(LOG_PRIORITY_WARN)
#
# Here's where the messages go on different platforms:
#   Windows: debug output stream
#   Android: log output
#   Others: standard error output (stderr)
#


const
  MAX_LOG_MESSAGE* = 4096
    ## The maximum size of a log message
    ##
    ## Messages longer than the maximum size will be truncated

  # The predefined log categories
  #
  # By default the application category is enabled at the INFO level,
  # the assert category is enabled at the WARN level, test is enabled
  # at the VERBOSE level and all other categories are enabled at the
  # CRITICAL level.

  LOG_CATEGORY_APPLICATION* = 0
  LOG_CATEGORY_ERROR* = 1
  LOG_CATEGORY_ASSERT* = 2
  LOG_CATEGORY_SYSTEM* = 3
  LOG_CATEGORY_AUDIO* = 4
  LOG_CATEGORY_VIDEO* = 5
  LOG_CATEGORY_RENDER* = 6
  LOG_CATEGORY_INPUT* = 7
  LOG_CATEGORY_TEST* = 8

  # Reserved for future SDL library use
  LOG_CATEGORY_RESERVED1* = 9
  LOG_CATEGORY_RESERVED2* = 10
  LOG_CATEGORY_RESERVED3* = 11
  LOG_CATEGORY_RESERVED4* = 12
  LOG_CATEGORY_RESERVED5* = 13
  LOG_CATEGORY_RESERVED6* = 14
  LOG_CATEGORY_RESERVED7* = 15
  LOG_CATEGORY_RESERVED8* = 16
  LOG_CATEGORY_RESERVED9* = 17
  LOG_CATEGORY_RESERVED10* = 18

  # Beyond this point is reserved for application use
  LOG_CATEGORY_CUSTOM* = 19


type
  TLogPriority* = enum ## The predefined log priorities
    LOG_PRIORITY_VERBOSE = 1,
    LOG_PRIORITY_DEBUG,
    LOG_PRIORITY_INFO,
    LOG_PRIORITY_WARN,
    LOG_PRIORITY_ERROR,
    LOG_PRIORITY_CRITICAL,
    NUM_LOG_PRIORITIES


proc logSetAllPriority*(priority: TLogPriority) {.cdecl, importc: "SDL_LogSetAllPriority", dynlib: LibName.}
  ## Set the priority of all log categories


proc logSetPriority*(category: int, priority: TLogPriority) {.cdecl, importc: "SDL_LogSetPriority", dynlib: LibName.}
  ## Set the priority of a particular log category


proc logGetPriority*(category: int): TLogPriority {.cdecl, importc: "SDL_LogGetPriority", dynlib: LibName.}
  ## Get the priority of a particular log category


proc logResetPriorities*() {.cdecl, importc: "SDL_LogResetPriorities", dynlib: LibName.}
  ## Reset all priorities to default.
  ##
  ## This is called in quit().


proc log*(fmt: cstring) {.cdecl, importc: "SDL_Log", varargs, dynlib: LibName.}
  ## Log a message with LOG_CATEGORY_APPLICATION and LOG_PRIORITY_INFO


proc logVerbose*(category: int, fmt: cstring) {.cdecl, importc: "SDL_LogVerbose", varargs, dynlib: LibName.}
  ## Log a message with LOG_PRIORITY_VERBOSE


proc logDebug*(category: int, fmt: cstring) {.cdecl, importc: "SDL_LogDebug", varargs, dynlib: LibName.}
  ## Log a message with LOG_PRIORITY_DEBUG


proc logInfo*(category: int, fmt: cstring) {.cdecl, importc: "SDL_LogInfo", varargs, dynlib: LibName.}
  ## Log a message with LOG_PRIORITY_INFO


proc logWarn*(category: int, fmt: cstring) {.cdecl, importc: "SDL_LogWarn", varargs, dynlib: LibName.}
  ## Log a message with LOG_PRIORITY_WARN


proc logError*(category: int, fmt: cstring) {.cdecl, importc: "SDL_LogError", varargs, dynlib: LibName.}
  ## Log a message with LOG_PRIORITY_ERROR


proc logCritical*(category: int, fmt: cstring) {.cdecl, importc: "SDL_LogCritical", varargs, dynlib: LibName.}
  ## Log a message with LOG_PRIORITY_CRITICAL


proc logMessage*(category: int, priority: TLogPriority,
    fmt: cstring) {.cdecl, importc: "SDL_LogMessage", varargs, dynlib: LibName.}
  ## Log a message with the specified category and priority.


proc logMessageV*(category: int, priority: TLogPriority,
    fmt: cstring) {.cdecl, importc: "SDL_LogMessageV", varargs, dynlib: LibName.}
  ## Log a message with the specified category and priority.


type
  PLogOutputFunction* = proc(userdata: pointer, category: int, priority: TLogPriority, message: cstring) ## The prototype for the log output function


proc logGetOutputFunction*(callback: PLogOutputFunction, userdata: ptr pointer) {.cdecl, importc: "SDL_LogGetOutputFunction", dynlib: LibName.}
  ## Get the current log output function.


proc logSetOutputFunction*(callback: PLogOutputFunction, userdata: pointer) {.cdecl, importc: "SDL_LogSetOutputFunction", dynlib: LibName.}
  ## This function allows you to replace the default log output
  ## function with one of your own.

