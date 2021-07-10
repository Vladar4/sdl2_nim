# ex501_tcp.nim
# ================
# NETWORK / UDP sockets (server)
# ------------------------------


import sdl2nim/sdl, sdl2nim/sdl_net as net


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

  var
    port: uint16 = 9999
    socket: net.UDPsocket
    packet: ptr net.UDPpacket

  # Open socket
  socket = net.udpOpen(port)
  if socket == nil:
    sdl.logCritical(sdl.LogCategoryError,
                    "Can't open UDP socket: %s",
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
    # Wait for a packet
    if net.udpRecv(socket, packet) != 0:
      echo "-------------------"
      echo "UDP packet received"
      echo "|- channel: ", packet.channel
      echo "|- data:    ", cast[cstring](packet.data)
      echo "|- len:     ", packet.len
      echo "|- maxlen:  ", packet.maxlen
      echo "|- status:  ", packet.status
      echo "|- address: ", packet.address.host, ":", packet.address.port

      # quit on command
      if cmp($(cast[cstring](packet.data)), "quit") == 0:
        echo ""
        echo "Quit command received"
        done = true

  net.freePacket(packet)

# Shutdown
exit()

