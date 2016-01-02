# ex501_tcp.nim
# ================
# NETWORK / TCP sockets (client)
# ------------------------------


import sdl2/sdl, sdl2/sdl_net as net


# Initialization sequence
proc init(): bool =
  # Init SDL
  if sdl.init(sdl.InitVideo) != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL: %s",
                    sdl.getError())
    return false

  # Init SDL_net
  if net.init() != 0:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't initialize SDL_net: %s",
                    net.getError())
    return false

  sdl.logInfo(sdl.LogCategoryApplication, "SDL initialized successfully")
  return true


# Shutdown sequence
proc exit() =
  sdl.logInfo(sdl.LogCategoryApplication, "SDL shutdown completed")
  net.quit()
  sdl.quit()


########
# MAIN #
########

var
  done = false # Main loop exit condition

if init():

  const
    BufMax = 512
    Invite = "Your message: "

  var
    ip: net.IPaddress
    socket: net.TCPsocket
    port: uint16 = 9999
    msg: array[BufMax, char]

  if net.resolveHost(addr(ip), "localhost", port) == -1:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't resolve host: %s",
                    net.getError())
    done = true
  else:
    echo "Host resolved"

  socket = net.tcpOpen(addr(ip))
  if socket == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't open TCP socket: %s",
                    net.getError())
    done = true
  else:
    echo "TCP socket opened"
    echo "Type \"exit\" to disconnect or \"quit\" to stop server"

  # Main loop
  while not done:

    write(stdout, Invite)
    let line = readLine(stdin)
    for i in 0..line.high+1:
      msg[i] = line[i]

    if net.tcpSend(socket, addr(msg), msg.len) < msg.len:
      sdl.logError(sdl.LogCategoryError,
                   "Can't send message: ",
                   sdl.getError())

    if line == "exit" or line == "quit":
      done = true

  tcpClose(socket)

# Shutdown
exit()

