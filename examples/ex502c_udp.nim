# ex501_tcp.nim
# ================
# NETWORK / UDP sockets (client)
# ------------------------------

import sdl2_nim/sdl, sdl2_nim/sdl_net as net


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
    PacketSize = 512
    Invite = "Your message: "

  var
    port: uint16 = 9999
    socket: net.UDPsocket
    packet: ptr net.UDPpacket
    ip: IPaddress

  # Open socket on random port
  socket = net.udpOpen(0)
  if socket == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't open UDP socket: %s",
                    net.getError())
    done = true
  else:
    # Resolve server name
    if net.resolveHost(addr(ip), "localhost", port) == -1:
      sdl.logCritical(sdl.LogCategoryError,
                      "Can't resolve server name: %s",
                      net.getError())
      done = true
    else:
      # Allocate packet
      packet = net.allocPacket(PacketSize)
      if packet == nil:
        sdl.logCritical(sdl.LogCategoryError,
                        "Can't allocate UDP packet: %s",
                        net.getError())
        done = true

  # Main loop
  while not done:
    write(stdout, Invite)
    var line = readLine(stdin)
    packet.data = cast[ptr uint8](cstring(line))

    packet.address.host = ip.host
    packet.address.port = ip.port

    packet.len = line.len + 1

    discard net.udpSend(socket, -1, packet)

    if line == "quit":
      echo ""
      echo "Quit command received"
      done = true

  if packet != nil:
    net.freePacket(packet)
    packet = nil

# Shutdown
exit()

