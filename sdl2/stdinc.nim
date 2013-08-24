
template fourCC*(a, b, c, d: Uint8): Uint32 =
  ## Define a four character code as a Uint32
  ((Uint32(a) shl 0) or (Uint32(b) shl 8) or (Uint32(c) shl 16) or (Uint32(d) shl 24))

