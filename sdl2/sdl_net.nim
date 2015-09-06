#
#  SDL_net:  An example cross-platform network library for use with SDL
#  Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>
#  Copyright (C) 2012 Simeon Maxein <smaxein@googlemail.com>
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

##  sdl_net.nim
##  ===========
##
##  Cross-platform networking library.

import
  sdl

# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 0

proc linkedVersion*(): ptr Version {.
    cdecl, importc: "SDLNet_Linked_Version", dynlib: SDL2_NET_LIB.}
  ##  This function gets the version of the dynamically linked SDL_net library.
  ##  It should NOT be used to fill a version structure, instead you should
  ##  use the ``version()`` template.

proc init*(): cint {.
    cdecl, importc: "SDLNet_Init", dynlib: SDL2_NET_LIB.}
  ##  Initialize the network API.
  ##
  ##  SDL must be initialized before calls to functions in this library,
  ##  because this library uses utility functions from the SDL library.

proc quit*() {.
    cdecl, importc: "SDLNet_Quit", dynlib: SDL2_NET_LIB.}
  ##  Cleanup the network API

#*********************************************************************
# IPv4 hostname resolution API                                        
#*********************************************************************

type
  IPaddress* = object
    host*: uint32 ##  32-bit IPv4 host address
    port*: uint16 ##  16-bit protocol port

when not(declared(INADDR_ANY)):
  const
    INADDR_ANY* = 0x00000000
when not(declared(INADDR_NONE)):
  const
    INADDR_NONE* = 0xFFFFFFFF
when not(declared(INADDR_LOOPBACK)):
  const
    INADDR_LOOPBACK* = 0x7F000001
when not(declared(INADDR_BROADCAST)):
  const
    INADDR_BROADCAST* = 0xFFFFFFFF

proc resolveHost*(address: ptr IPaddress; host: cstring; port: uint16): cint {.
    cdecl, importc: "SDLNet_ResolveHost", dynlib: SDL2_NET_LIB.}
  ##  Resolve a host name and port to an IP address in network form.
  ##
  ##  If the function succeeds, it will return `0`.
  ##
  ##  If the host couldn't be resolved, the host portion of the returned
  ##  address will be `INADDR_NONE`, and the function will return `-1`.
  ##
  ##  If ``host`` is `nil`, the resolved host will be set to `INADDR_ANY`.

proc resolveIP*(ip: ptr IPaddress): cstring {.
    cdecl, importc: "SDLNet_ResolveIP", dynlib: SDL2_NET_LIB.}
  ##  Resolve an ip address to a host name in canonical form.
  ##
  ##  If the ip couldn't be resolved, this function returns `nil`,
  ##  otherwise a pointer to a static buffer containing the hostname
  ##  is returned.
  ##
  ##  ``Note`` that this function is not thread-safe.

proc getLocalAddresses*(addresses: ptr IPaddress; maxcount: cint): cint {.
    cdecl, importc: "SDLNet_GetLocalAddresses", dynlib: SDL2_NET_LIB.}
  ##  Get the addresses of network interfaces on this system.
  ##
  ##  This returns the number of addresses saved in ``addresses``.

#*********************************************************************
# TCP network API                                                     
#*********************************************************************

type
  TCPsocket* = pointer

proc tcp_Open*(ip: ptr IPaddress): TCPsocket {.
    cdecl, importc: "SDLNet_TCP_Open", dynlib: SDL2_NET_LIB.}
  ##  Open a TCP network socket.
  ##
  ##  If ``ip.host`` is `INADDR_NONE` or `INADDR_ANY`, this creates a local
  ##  server socket on the given port, otherwise a TCP connection to the
  ##  remote host and port is attempted. The address passed in should already
  ##  be swapped to network byte order (addresses returned from
  ##  ``resolveHost()`` are already in the correct form).
  ##
  ##  The newly created socket is returned, or `nil` if there was an error.

proc tcp_Accept*(server: TCPsocket): TCPsocket {.
    cdecl, importc: "SDLNet_TCP_Accept", dynlib: SDL2_NET_LIB.}
  ##  Accept an incoming connection on the given server socket.
  ##
  ##  The newly created socket is returned, or `nil` if there was an error.

proc tcp_GetPeerAddress*(sock: TCPsocket): ptr IPaddress {.
    cdecl, importc: "SDLNet_TCP_GetPeerAddress", dynlib: SDL2_NET_LIB.}
  ##  Get the IP address of the remote system associated with the socket.
  ##
  ##  If the socket is a server socket, this function returns `nil`.

proc tcp_Send*(sock: TCPsocket; data: pointer; len: cint): cint {.
    cdecl, importc: "SDLNet_TCP_Send", dynlib: SDL2_NET_LIB.}
  ##  Send ``len`` bytes of ``data`` over the non-server socket ``sock``.
  ##
  ##  This function returns the actual amount of data sent.
  ##
  ##  If the return value is less than the amount of data sent, then either
  ##  the remote connection was closed, or an unknown socket error occurred.

proc tcp_Recv*(sock: TCPsocket; data: pointer; maxlen: cint): cint {.
    cdecl, importc: "SDLNet_TCP_Recv", dynlib: SDL2_NET_LIB.}
  ##  Receive up to ``maxlen`` bytes of data over the non-server socket
  ##  ``sock``, and store them in the buffer pointed to by ``data``.
  ##
  ##  This function returns the actual amount of data received.
  ##
  ##  If the return value is less than or equal to zero, then either
  ##  the remote connection was closed, or an unknown socket error occurred.

proc tcp_Close*(sock: TCPsocket) {.
    cdecl, importc: "SDLNet_TCP_Close", dynlib: SDL2_NET_LIB.}
  ##  Close a TCP network socket.

#*********************************************************************
# UDP network API                                                     
#*********************************************************************

const
  MAX_UDPCHANNELS* = 32  ##  \
    ##  The maximum channels on a a UDP socket

const
  MAX_UDPADDRESSES* = 4  ##  \
    ##  The maximum addresses bound to a single UDP socket channel

type
  UDPsocket* = pointer

  UDPpacket* = object
    channel*: cint      ##  The src/dst channel of the packet
    data*: ptr uint8    ##  The packet data
    len*: cint          ##  The length of the packet data
    maxlen*: cint       ##  The size of the data buffer
    status*: cint       ##  Packet status after sending
    address*: IPaddress ##  \
      ##  The source/dest address of an incoming/outgoing packet

proc allocPacket*(size: cint): ptr UDPpacket {.
    cdecl, importc: "SDLNet_AllocPacket", dynlib: SDL2_NET_LIB.}
  ##  Allocate a single UDP packet ``size`` bytes long.
  ##
  ##  The new packet is returned, or `nil` if the function ran out of memory.

proc resizePacket*(packet: ptr UDPpacket; newsize: cint): cint {.
    cdecl, importc: "SDLNet_ResizePacket", dynlib: SDL2_NET_LIB.}
  ##  Resize a single UDP packet ``size`` bytes long.
  ##
  ##  The new packet is returned, or `nil` if the function ran out of memory.

proc freePacket*(packet: ptr UDPpacket) {.
    cdecl, importc: "SDLNet_FreePacket", dynlib: SDL2_NET_LIB.}
  ##  Free a single UDP packet.

proc allocPacketV*(howmany: cint; size: cint): ptr ptr UDPpacket {.
    cdecl, importc: "SDLNet_AllocPacketV", dynlib: SDL2_NET_LIB.}
  ##  Allocate a UDP packet vector (array of packets) of ``howmany`` packets,
  ##  each ``size`` bytes long.
  ##
  ##  A pointer to the first packet in the array is returned, or `nil` if the
  ##  function ran out of memory.

proc freePacketV*(packetV: ptr ptr UDPpacket) {.
    cdecl, importc: "SDLNet_FreePacketV", dynlib: SDL2_NET_LIB.}
  ##  Free a UDP packet vector (array of packets).

proc udp_Open*(port: uint16): UDPsocket {.
    cdecl, importc: "SDLNet_UDP_Open", dynlib: SDL2_NET_LIB.}
  ##  Open a UDP network socket.
  ##
  ##  If ``port`` is non-zero, the UDP socket is bound to a local port.
  ##
  ##  The ``port`` should be given in native byte order, but is used
  ##  internally in network (big endian) byte order, in addresses, etc.
  ##  This allows other systems to send to this socket via a known port.

proc udp_SetPacketLoss*(sock: UDPsocket; percent: cint) {.
    cdecl, importc: "SDLNet_UDP_SetPacketLoss", dynlib: SDL2_NET_LIB.}
  ##  Set the percentage of simulated packet loss for packets sent
  ##  on the socket.

proc udp_Bind*(sock: UDPsocket; channel: cint; address: ptr IPaddress): cint {.
    cdecl, importc: "SDLNet_UDP_Bind", dynlib: SDL2_NET_LIB.}
  ##  Bind the address ``address`` to the requested channel on the UDP socket.
  ##
  ##  If the ``channel`` is `-1`, then the first unbound channel that has not
  ##  yet been bound to the maximum number of addresses will be bound with
  ##  the given address as it's primary address.
  ##
  ##  If the ``channel`` is already bound, this new address will be added to
  ##  the list of valid source addresses for packets arriving on the channel.
  ##
  ##  If the ``channel`` is not already bound, then the address becomes the
  ##  primary address, to which all outbound packets on the channel are sent.
  ##
  ##  This function returns the channel which was bound, or `-1` on error.

proc udp_Unbind*(sock: UDPsocket; channel: cint) {.
    cdecl, importc: "SDLNet_UDP_Unbind", dynlib: SDL2_NET_LIB.}
  ##  Unbind all addresses from the given channel.

proc udp_GetPeerAddress*(sock: UDPsocket; channel: cint): ptr IPaddress {.
    cdecl, importc: "SDLNet_UDP_GetPeerAddress", dynlib: SDL2_NET_LIB.}
  ##  Get the primary IP address of the remote system associated with the
  ##  ``socket`` and ``channel``.
  ##
  ##  If the ``channel`` is `-1`, then the primary IP port of the UDP socket
  ##  is returned -- this is only meaningful for sockets opened with a specific
  ##  port.
  ##
  ##  If the ``channel`` is not bound and not `-1`,
  ##  this function returns `nil`.

proc udp_SendV*(
    sock: UDPsocket; packets: ptr ptr UDPpacket; npackets: cint): cint {.
      cdecl, importc: "SDLNet_UDP_SendV", dynlib: SDL2_NET_LIB.}
  ##  Send a vector of packets to the the channels specified within the packet.
  ##
  ##  If the channel specified in the packet is `-1`, the packet will be sent
  ##  to the address in the ``src`` member of the packet.
  ##
  ##  Each packet will be updated with the status of the packet after it has
  ##  been sent, `-1` if the packet send failed.
  ##
  ##  This function returns the number of packets sent.

proc udp_Send*(sock: UDPsocket; channel: cint; packet: ptr UDPpacket): cint {.
    cdecl, importc: "SDLNet_UDP_Send", dynlib: SDL2_NET_LIB.}
  ##  Send a single ``packet`` to the specified ``channel``.
  ##
  ##  If the channel specified in the packet is `-1`, the packet will be sent
  ##  to the address in the ``src`` member of the packet.
  ##
  ##  The packet will be updated with the status of the packet after it has
  ##  been sent.
  ##
  ##  This function returns `1` if the packet was sent, or `0` on error.
  ##
  ##  ``Note:`` The maximum size of the packet is limited by the MTU (Maximum
  ##  Transfer Unit) of the transport medium.  It can be as low as `250` bytes
  ##  for some PPP links, and as high as `1500` bytes for ethernet.

proc udp_RecvV*(sock: UDPsocket; packets: ptr ptr UDPpacket): cint {.
    cdecl, importc: "SDLNet_UDP_RecvV", dynlib: SDL2_NET_LIB.}
  ##  Receive a vector of pending packets from the UDP socket.
  ##
  ##  The returned packets contain the source address and the channel they
  ##  arrived on.  If they did not arrive on a bound channel, the the channel
  ##  will be set to `-1`.
  ##
  ##  The channels are checked in highest to lowest order, so if an address is
  ##  bound to multiple channels, the highest channel with the source address
  ##  bound will be returned.
  ##
  ##  This function returns the number of packets read from the network,
  ##  or `-1` on error.
  ##
  ##  This function does not block, so can return `0` packets pending.

proc udp_Recv*(sock: UDPsocket; packet: ptr UDPpacket): cint {.
    cdecl, importc: "SDLNet_UDP_Recv", dynlib: SDL2_NET_LIB.}
  ##  Receive a single packet from the UDP socket.
  ##
  ##  The returned packet contains the source address and the channel it
  ##  arrived on. If it did not arrive on a bound channel, the the channel
  ##  will be set to `-1`.
  ##
  ##  The channels are checked in highest to lowest order, so if an address is
  ##  bound to multiple channels, the highest channel with the source address
  ##  bound will be returned.
  ##
  ##  This function returns the number of packets read from the network,
  ##  or `-1` on error.
  ##
  ##  This function does not block, so can return `0` packets pending.

proc udp_Close*(sock: UDPsocket) {.
    cdecl, importc: "SDLNet_UDP_Close", dynlib: SDL2_NET_LIB.}
  ##  Close a UDP network socket.

#*********************************************************************
# Hooks for checking sockets for available data                       
#*********************************************************************

type
  SocketSet* = pointer

type
  GenericSocket* = ptr GenericSocketObj

  GenericSocketObj* = object ##  \
    ##  Any network socket can be safely cast to this socket type
    ready*: cint

proc allocSocketSet*(maxsockets: cint): SocketSet {.
    cdecl, importc: "SDLNet_AllocSocketSet", dynlib: SDL2_NET_LIB.}
  ##  Allocate a socket set for use with ``checkSockets()``.
  ##
  ##  This returns a socket set for up to ``maxsockets`` sockets,
  ##  or `nil` if the function ran out of memory.

proc addSocket*(set: SocketSet; sock: GenericSocket): cint {.
    cdecl, importc: "SDLNet_AddSocket", dynlib: SDL2_NET_LIB.}
  ##  Add a socket to a set of sockets to be checked for available data.
  ##
  ##  See also:
  ##
  ##  ``tcp_AddSocket()``
  ##
  ##  ``udp_AddSocket()``

template tcp_AddSocket*(set: SocketSet; sock: TCPsocket): cint =
  addSocket(set, cast[GenericSocket](sock))

template udp_AddSocket*(set: SocketSet; sock: UDPsocket): cint =
  addSocket(set, cast[GenericSocket](sock))

proc delSocket*(set: SocketSet; sock: GenericSocket): cint {.
    cdecl, importc: "SDLNet_DelSocket", dynlib: SDL2_NET_LIB.}
  ##  Remove a socket from a set of sockets to be checked for available data.
  ##
  ##  See also:
  ##
  ##  ``tcp_DelSocket()``
  ##
  ##  ``udp_DelSocket()``

template tcp_DelSocket*(set: SocketSet; sock: TCPsocket): cint =
  delSocket(set, cast[GenericSocket](sock))

template udp_DelSocket*(set: SocketSet; sock: UDPsocket): cint =
  delSocket(set, cast[GenericSocket](sock))

proc checkSockets*(set: SocketSet; timeout: uint32): cint {.
    cdecl, importc: "SDLNet_CheckSockets", dynlib: SDL2_NET_LIB.}
  ##  This function checks to see if data is available for reading on the
  ##  given set of sockets.
  ##
  ##  If ``timeout`` is `0`, it performs a quick poll, otherwise the function
  ##  returns when either data is available for reading, or the timeout in
  ##  milliseconds has elapsed, which ever occurs first.
  ##
  ##  This function returns the number of sockets ready for reading,
  ##  or `-1` if there was an error with the ``select()`` system call.

template socketReady*(sock: GenericSocket): cint =
  (sock != nil) and (sock.ready)

template socketReady*(sock: expr): cint = ##  \
  ##  After calling ``checkSockets()``, you can use this template on a
  ##  socket that was in the socket set, to find out if data is available
  ##  for reading.
  socketReady((GenericSocket)(sock))


proc freeSocketSet*(set: SocketSet) {.
    cdecl, importc: "SDLNet_FreeSocketSet", dynlib: SDL2_NET_LIB.}
  ##  Free a set of sockets allocated by ``allocSocketSet()``.

#*********************************************************************
# Error reporting functions                                           
#*********************************************************************

proc setError*(fmt: cstring) {.
    varargs, cdecl, importc: "SDLNet_SetError", dynlib: SDL2_NET_LIB.}

proc getError*(): cstring {.
    cdecl, importc: "SDLNet_GetError", dynlib: SDL2_NET_LIB.}

#*********************************************************************
# Inline functions to read/write network data                         
#*********************************************************************

# Warning, some systems have data access alignment restrictions.
when defined(sparc) or defined(mips) or defined(arm):
  const
    SDL_DATA_ALIGNED* = 1
when not(declared(SDL_DATA_ALIGNED)):
  const
    SDL_DATA_ALIGNED* = 0

when not declared(WITHOUT_SDL) and (SDL_DATA_ALIGNED != 0):

  import endians

  template netWrite16(value: uint16; areap: pointer) =
    # cast[ptr uint16](areap)[] = SDL_swapBE16(value)
    bigEndian16(areap, value)

  template netWrite32(value: uint32; areap: pointer) =
    # cast[ptr uint32](areap)[] = SDL_swapBE32(value)
    bigEndian32(areap, value)

  template netRead16(areap: pointer): uint16 =
    # SDL_swapBE16(cast[ptr uint16](areap)[])
    bigEndian16(areap, areap)

  template netRead32(areap: pointer): uint32 =
    # SDL_swapBE32(cast[ptr uint32](areap)[])
    bigEndian32(areap, areap)

else:

  template netWrite16(value: uint16; areap: pointer) =
    var area: ptr uint8 = cast[ptr uint8](areap)
    area[0] = (value shr 8) and 0x000000FF
    area[1] = value and 0x000000FF

  template netWrite32(value: uint32; areap: pointer) =
    var area: ptr uint8 = cast[ptr uint8](areap)
    area[0] = (value shr 24) and 0x000000FF
    area[1] = (value shr 16) and 0x000000FF
    area[2] = (value shr 8) and 0x000000FF
    area[3] = value and 0x000000FF

  template netRead16(areap: pointer): uint16 =
    var area: ptr uint8 = cast[ptr uint8](areap)
    return (cast[uint16](area[0])) shl 8 or (cast[uint16](area[1]))

  template netRead32(areap: pointer): uint32 =
    var area: ptr uint8 = cast[ptr uint8](areap)
    return (cast[uint32](area[0])) shl 24 or (cast[uint32](area[1])) shl 16 or
        (cast[uint32](area[2])) shl 8 or (cast[uint32](area[3]))

template write16*(value, areap: expr): expr = ##  \
  ##  Write a 16-bit value to network packet buffer.
  netWrite16(value, areap)

template write32*(value, areap: expr): expr = ##  \
  ##  Write a 32-bit value to network packet buffer.
  netWrite32(value, areap)

template read16*(areap: expr): expr = ##  \
  ##  Read a 16-bit value from network packet buffer.
  netRead16(areap)

template read32*(areap: expr): expr = ##  \
  ##  Read a 32-bit value from network packet buffer.
  netRead32(areap)
