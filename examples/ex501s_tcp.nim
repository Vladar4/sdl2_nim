# ex501_tcp.nim
# ================
# NETWORK / TCP sockets (server)
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

  var
    ip: net.IPaddress
    socket, clientSocket: net.TCPsocket
    port: uint16 = 9999
    buffer: array[BufMax, char]

  if net.resolveHost(addr(ip), nil, port) < 0:
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

  # Main loop
  while not done:
    # Check for a pending connection
    clientSocket = net.tcpAccept(socket)
    if clientSocket != nil:
      echo "Host connected"

      var receiving = true
      while receiving:
        if net.tcpRecv(clientSocket, addr(buffer[0]), BufMax) > 0:
          echo "Client send: ", buffer
          if cmp($buffer, "exit") == 0:
            receiving = false
          elif cmp($buffer, "quit") == 0:
            receiving = false
            done = true

      net.tcpClose(clientSocket)
      echo "Host disconnected"

  tcpClose(socket)
  echo "TCP socket closed"

# Shutdown
exit()

