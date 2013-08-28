#
# SDL_net:  An example cross-platform network library for use with SDL
# Copyright (C) 1997-2013 Sam Lantinga <slouken@libsdl.org>
# Copyright (C) 2012 Simeon Maxein <smaxein@googlemail.com>
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


type
  PNetVersion* = ptr TNetVersion
  TNetVersion* = object
    major*: Uint8
    minor*: Uint8
    patch*: Uint8


# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  NET_MAJOR_VERSION* = 2
  NET_MINOR_VERSION* = 0
  NET_PATCHLEVEL* = 0


template netVersion*(x: PNetVersion) =
  ## This template can be used to fill a version structure with the compile-time
  ## version of the SDL_net library.
  x.major = NET_MAJOR_VERSION
  x.minor = NET_MINOR_VERSION
  x.patch = NET_PATCHLEVEL


template netVersion*(x: TNetVersion) =
  netVersion(addr(x))


proc netLinkedVersion*(): PNetVersion {.cdecl, importc: "SDLNet_Linked_Version", dynlib: LibNetName.}
  ## This function gets the version of the dynamically linked SDL_net library.
  ## it should NOT be used to fill a version structure, instead you should
  ## use the netVersion() template.


proc netInit*(): int {.cdecl, importc: "SDLNet_Init", dynlib: LibNetName.}
  ## Initialize/Cleanup the network API
  ## SDL must be initialized before calls to functions in this library,
  ## because this library uses utility functions from the SDL library.


proc netQuit*() {.cdecl, importc: "SDLNet_Quit", dynlib: LibNetName.}
  ## Initialize/Cleanup the network API
  ## SDL must be initialized before calls to functions in this library,
  ## because this library uses utility functions from the SDL library.


#***********************************************************************
#* IPv4 hostname resolution API                                        *
#***********************************************************************


type
  PIPaddress* = ptr TIPaddress
  TIPaddress* = object
    host*: Uint32 ## 32-bit IPv4 host address
    port*: Uint16 ## 16-bit protocol port


const
  INADDR_ANY* = 0x00000000
  INADDR_NONE* = 0xFFFFFFFF
  INADDR_LOOPBACK* = 0x7f000001
  INADDR_BROADCAST* = 0xFFFFFFFF


proc netResolveHost*(address: PIPaddress, host: cstring, port: Uint16): int {.cdecl, importc: "SDLNet_ResolveHost", dynlib: LibNetName.}
  ## Resolve a host name and port to an IP address in network form.
  ## If the function succeeds, it will return 0.
  ## If the host couldn't be resolved, the host portion of the returned
  ## address will be INADDR_NONE, and the function will return -1.
  ## If 'host' is nil, the resolved host will be set to INADDR_ANY.


proc netResolveIP*(ip: PIPaddress): cstring {.cdecl, importc: "SDLNet_ResolveIP", dynlib: LibNetName.}
  ## Resolve an ip address to a host name in canonical form.
  ## If the ip couldn't be resolved, this function returns nil,
  ## otherwise a pointer to a static buffer containing the hostname
  ## is returned.  Note that this function is not thread-safe.


proc netGetLocalAddresses*(addresses: PIPaddress, maxcount: int): int {.cdecl, importc: "SDLNet_GetLocalAddresses", dynlib: LibNetName.}
  ## Get the addresses of network interfaces on this system.
  ## This returns the number of addresses saved in 'addresses'


#***********************************************************************
#* TCP network API                                                     *
#***********************************************************************


type
  PTCPsocket* = ptr TTCPsocket
  TTCPsocket* = object
    ready*: int
    channel*: int
    rempteAddress*: TIPaddress
    localAddress*: TIPaddress
    sflag*: int


proc netTCPOpen*(ip: PIPaddress): PTCPsocket {.cdecl, importc: "SDLNet_TCP_Open", dynlib: LibNetName.}
  ## Open a TCP network socket
  ## If ip.host is INADDR_NONE or INADDR_ANY, this creates a local server
  ## socket on the given port, otherwise a TCP connection to the remote
  ## host and port is attempted. The address passed in should already be
  ## swapped to network byte order (addresses returned from
  ## netResolveHost() are already in the correct form).
  ## The newly created socket is returned, or nil if there was an error.


proc netTCPAccept*(server: PTCPsocket): PTCPsocket {.cdecl, importc: "SDLNet_TCP_Accept", dynlib: LibNetName.}
  ## Accept an incoming connection on the given server socket.
  ## The newly created socket is returned, or nil if there was an error.


proc netTCPGetPeerAddress*(sock: PTCPsocket): PIPaddress {.cdecl, importc: "SDLNet_TCP_GetPeerAddress", dynlib: LibNetName.}
  ## Get the IP address of the remote system associated with the socket.
  ## If the socket is a server socket, this function returns nil.


proc netTCPSend*(sock: PTCPsocket, data: pointer, len: int): int {.cdecl, importc: "SDLNet_TCP_Send", dynlib: LibNetName.}
  ## Send ``len`` bytes of ``data`` over the non-server socket ``sock``
  ## This function returns the actual amount of data sent.  If the return value
  ## is less than the amount of data sent, then either the remote connection was
  ## closed, or an unknown socket error occurred.


proc netTCPRecv*(sock: PTCPsocket, data: pointer, maxlen: int): int {.cdecl, importc: "SDLNet_TCP_Recv", dynlib: LibNetName.}
  ## Receive up to ``maxlen`` bytes of data over the non-server socket
  ## ``sock``, and store them in the buffer pointed to by ``data``.
  ## This function returns the actual amount of data received.  If the return
  ## value is less than or equal to zero, then either the remote connection was
  ## closed, or an unknown socket error occurred.


proc netTCPClose*(sock: PTCPsocket) {.cdecl, importc: "SDLNet_TCP_Close", dynlib: LibNetName.}
  ## Close a TCP network socket


#***********************************************************************
#* UDP network API                                                     *
#***********************************************************************


const
  NET_MAX_UDPCHANNELS* = 32 ## The maximum channels on a a UDP socket
  NET_MAX_UDPADDRESSES* = 4 ## The maximum addresses bound to a single UDP socket channel

type
  
  TUDPchannel* = object
    numbound*: int
    address*: array[0..NET_MAX_UDPADDRESSES-1, TIPaddress]


  PUDPsocket* = ptr TUDPsocket
  TUDPsocket* = object
    ready*: int
    channel*: int
    address*: TIPaddress
    binding*: array[0..NET_MAX_UDPCHANNELS-1, TUDPchannel]


  PUDPpacket* = ptr TUDPpacket
  TUDPpacket* = object
    channel*: int ## The src/dst channel of the packet
    data*: ptr byte ## The packet data
    len*: int ## The length of the packet data
    maxlen*: int ## The size of the data buffer
    status*: int ## packet status after sending
    address*: PIPaddress ## The source/dest address of an incoming/outgoing packet


proc netAllocPacket*(size: int): PUDPpacket {.cdecl, importc: "SDLNet_AllocPacket", dynlib: LibNetName.}
  ## Allocate a single UDP packet ``size`` bytes long.
  ## The new packet is returned, or nil if the function ran out of memory.


proc netResizePacket*(packet: PUDPpacket, newsize: int): int {.cdecl, importc: "SDLNet_ResizePacket", dynlib: LibNetName.}
  ## Resize a single UDP packet ``size`` bytes long.
  ## The new packet is returned, or nil if the function ran out of memory.


proc netFreePacket*(packet: PUDPpacket) {.cdecl, importc: "SDLNet_FreePacket", dynlib: LibNetName.}
  ## Free a single UDP packet ``size`` bytes long.
  ## The new packet is returned, or nil if the function ran out of memory.


proc netAllocPacketV*(howmany, size: int): ptr PUDPpacket {.cdecl, importc: "SDLNet_AllocPacketV", dynlib: LibNetName.}
  ## Allocate a UDP packet vector (array of packets) of ``howmany`` packets,
  ## each ``size`` bytes long.
  ## A pointer to the first packet in the array is returned, or nil if the
  ## function ran out of memory.


proc netFreePacketV*(packetV: ptr PUDPpacket) {.cdecl, importc: "SDLNet_FreePacketV", dynlib: LibNetName.}
  ## Free a UDP packet vector (array of packets) of ``howmany`` packets,
  ## each ``size`` bytes long.
  ## A pointer to the first packet in the array is returned, or nil if the
  ## function ran out of memory.


proc netUDPOpen*(port: Uint16): PUDPsocket {.cdecl, importc: "SDLNet_UDP_Open", dynlib: LibNetName.}
  ## Open a UDP network socket
  ## If ``port`` is non-zero, the UDP socket is bound to a local port.
  ## The ``port`` should be given in native byte order, but is used
  ## internally in network (big endian) byte order, in addresses, etc.
  ## This allows other systems to send to this socket via a known port.


proc netUDPSetPacketLoss*(sock: PUDPsocket, percent: int) {.cdecl, importc: "SDLNet_UDP_SetPacketLoss", dynlib: LibNetName.}
  ## Set the percentage of simulated packet loss for packets sent on the socket.


proc netUDPBind*(sock: PUDPsocket, channel: int, address: PIPaddress): int {.cdecl, importc: "SDLNet_UPD_Bind", dynlib: LibNetName.}
  ## Bind the address ``address`` to the requested channel on the UDP socket.
  ## If the channel is -1, then the first unbound channel that has not yet
  ## been bound to the maximum number of addresses will be bound with
  ## the given address as it's primary address.
  ##
  ## If the channel is already bound, this new address will be added to the
  ## list of valid source addresses for packets arriving on the channel.
  ## If the channel is not already bound, then the address becomes the primary
  ## address, to which all outbound packets on the channel are sent.
  ## This function returns the channel which was bound, or -1 on error.


proc netUDPUnbind*(sock: PUDPsocket, channel: int) {.cdecl, importc: "SDLNet_UDP_Unbind", dynlib: LibNetName.}
  ## Unbind all addresses from the given channel


proc netUDPGetPeerAddress*(sock: PUDPsocket, channel: int): PIPaddress {.cdecl, importc: "SDLNet_UDP_GetPeerAddress", dynlib: LibNetName.}
  ## Get the primary IP address of the remote system associated with the
  ## socket and channel.  If the channel is -1, then the primary IP port
  ## of the UDP socket is returned -- this is only meaningful for sockets
  ## opened with a specific port.
  ##
  ## If the channel is not bound and not -1, this function returns nil.


proc netUDPSendV*(sock: PUDPsocket, packets: ptr PUDPpacket, npackets: int): int {.cdecl, importc: "SDLNet_UPD_SendV", dynlib: LibNetName.}
  ## Send a vector of packets to the the channels specified within the packet.
  ## If the channel specified in the packet is -1, the packet will be sent to
  ## the address in the ``src`` member of the packet.
  ## Each packet will be updated with the status of the packet after it has
  ## been sent, -1 if the packet send failed.
  ##
  ## This function returns the number of packets sent.


proc netUDPSend*(sock: PUDPsocket, channel: int, packet: PUDPpacket): int {.cdecl, importc: "SDLNet_UDP_Send", dynlib: LibNetName.}
  ## Send a single packet to the specified channel.
  ## If the channel specified in the packet is -1, the packet will be sent to
  ## the address in the 'src' member of the packet.
  ##  The packet will be updated with the status of the packet after it has
  ## been sent.
  ##
  ## This function returns 1 if the packet was sent, or 0 on error.
  ##
  ## The maximum size of the packet is limited by the MTU (Maximum Transfer Unit)
  ## of the transport medium.  It can be as low as 250 bytes for some PPP links,
  ##  and as high as 1500 bytes for ethernet.


proc netUDPRecvV*(sock: PUDPsocket, packets: ptr PUDPpacket): int {.cdecl, importc: "SDLNet_UDP_RecvV", dynlib: LibNetName.}
  ## Receive a vector of pending packets from the UDP socket.
  ## The returned packets contain the source address and the channel they
  ## arrived on.  If they did not arrive on a bound channel, the the channel
  ## will be set to -1.
  ## The channels are checked in highest to lowest order, so if an address is
  ## bound to multiple channels, the highest channel with the source address
  ## bound will be returned.
  ##
  ## This function returns the number of packets read from the network, or -1
  ## on error.  This function does not block, so can return 0 packets pending.


proc netUDPRecv*(sock: PUDPsocket, packet: PUDPpacket): int {.cdecl, importc: "SDLNet_UDP_Recv", dynlib: LibNetName.}
  ## Receive a single packet from the UDP socket.
  ## The returned packet contains the source address and the channel it arrived
  ## on.  If it did not arrive on a bound channel, the the channel will be set
  ## to -1.
  ## The channels are checked in highest to lowest order, so if an address is
  ## bound to multiple channels, the highest channel with the source address
  ## bound will be returned.
  ##
  ## This function returns the number of packets read from the network, or -1
  ## on error.  This function does not block, so can return 0 packets pending.


proc netUDPClose*(sock: PUDPsocket) {.cdecl, importc: "SDLNet_UDP_Close", dynlib: LibNetName.}
  ## Close a UDP network socket


#***********************************************************************
#* Hooks for checking sockets for available data                       *
#***********************************************************************


type

  PNetSocket* = ptr TNetSocket
  TNetSocket* = object
    ready*: int
    channel*: int
  
  PNetSocketSet* = ptr TNetSocketSet
  TNetSocketSet* = object
    numsockets*: int
    maxsockets*: int
    sockets*: ptr PNetSocket


  PNetGenericSocket* = ptr TNetGenericSocket
  TNetGenericSocket* = object
    ## Any network socket can be safely cast to this socket type
    ready*: int


proc netAllocSocketSet*(maxsockets: int): PNetSocketSet {.cdecl, importc: "SDLNet_AllocSocketSet", dynlib: LibNetName.}
  ## Allocate a socket set for use with netCheckSockets()
  ## This returns a socket set for up to ``maxsockets`` sockets, or nil if
  ## the function ran out of memory.


proc netAddSocket*(socketset: PNetSocketSet, sock: PNetGenericSocket): int {.cdecl, importc: "SDLNet_AddSocket", dynlib: LibNetName.}
  ## Add a socket to a set of sockets to be checked for available data


template netTCPAddSocket*(socketset: PNetSocketSet, sock: PTCPsocket): int =
  ## Add a socket to a set of sockets to be checked for available data
  netAddSocket(socketset, PNetGenericSocket(sock))


template netUDPAddSocket*(socketset: PNetSocketSet, sock: PUDPsocket): int =
  ## Add a socket to a set of sockets to be checked for available data
  netAddSocket(socketset, PNetGenericSocket(sock))


proc netDelSocket*(socketset: PNetSocketSet, sock: PNetGenericSocket): int {.cdecl, importc: "SDLNet_DelSocket", dynlib: LibNetName.}
  ## Remove a socket from a set of sockets to be checked for available data


template netTCPDelSocket*(socketset: PNetSocketSet, sock: PTCPsocket): int =
  ## Remove a socket from a set of sockets to be checked for available data
  netDelSocket(socketset, PNetGenericSocket(sock))


template netUDPDelSocket*(socketset: PNetSocketSet, sock: PUDPsocket): int =
  ## Remove a socket from a set of sockets to be checked for available data
  netDelSocket(socketset, PNetGenericSocket(sock))


proc netCheckSockets*(socketset: PNetSocketSet, timeout: Uint32): int {.cdecl, importc: "SDLNet_CheckSockets", dynlib: LibNetName.}
  ## This function checks to see if data is available for reading on the
  ## given set of sockets.  If ``timeout`` is 0, it performs a quick poll,
  ## otherwise the function returns when either data is available for
  ## reading, or the timeout in milliseconds has elapsed, which ever occurs
  ## first.  This function returns the number of sockets ready for reading,
  ## or -1 if there was an error with the select() system call.


template fNetSocketReady*(sock: PNetGenericSocket): bool =
    (sock != nil) and (sock.ready)

template netSocketReady*(sock: pointer): int =
  ## After calling netCheckSockets(), you can use this function on a
  ## socket that was in the socket set, to find out if data is available
  ## for reading.
  fNetSocketReady(PNetGenericSocket(sock))


proc SDLNet_FreeSocketSet*(socketset: PNetSocketSet) {.cdecl, importc: "SDLNet_FreeSocketSet", dynlib: LibNetName.}
  ## Free a set of sockets allocated by netAllocSocketSet()


#***********************************************************************
#* Error reporting functions                                           *
#***********************************************************************


proc netSetError*(fmt: cstring) {.cdecl, importc: "SDLNet_SetError", varargs, dynlib: LibNetName.}


proc netGetError*(): cstring {.cdecl, importc: "SDLNet_GetError", dynlib: LibNetName.}


#***********************************************************************
#* Inline functions to read/write network data                         *
#***********************************************************************


proc netWrite16*(value: Uint16, area: pointer) {.cdecl, importc: "SDLNet_Write16", dynlib: LibNetName.}


proc netWrite32*(value: Uint32, area: pointer) {.cdecl, importc: "SDLNet_Write32", dynlib: LibNetName.}
 

proc netRead16*(area: pointer): Uint16 {.cdecl, importc: "SDLNet_Read16", dynlib: LibNetName.}


proc netRead32*(area: pointer): Uint32 {.cdecl, importc: "SDLNet_Read32", dynlib: LibNetName.}


#proc netWrite16*(value: Uint16, areap: pointer) {.inline.} =
#  var
#    area: ptr array[0..1, Uint8] = cast[ptr array[0..1, Uint8]](areap)
#  area[0] = (value shr 8) and 0xFF
#  area[1] =  value and 0xFF
#
#
#proc netWrite32*(value: Uint32, areap: pointer) {.inline.} =
#  var
#    area: ptr array[0..3, Uint8] = cast[ptr array[0..3, Uint8]](areap)
#  area[0] = (value shr 24) and 0xFF
#  area[1] = (value shr 16) and 0xFF
#  area[2] = (value shr  8) and 0xFF
#  area[3] =  value and 0xFF
#
#
#proc netRead16*(areap: pointer): Uint16 {.inline.} =
#  var
#    area: ptr array[0..1, Uint8] = cast[ptr array[0..1, Uint8]](areap)
#  return ((Uint16(area[0])) shl 8 or (Uint16(area[1])))
#
#
#proc netRead32*(areap: pointer): Uint32 {.inline.} =
#  var
#    area: ptr array[0..3, Uint8] = cast[ptr array[0..3, Uint8]](areap)
#  return ((Uint32(area[0])) shl 24 or
#          (Uint32(area[1])) shl 16 or
#          (Uint32(area[2])) shl 8 or
#          (Uint32(area[3])))

