when defined(linux):
  import unicode

  # modified for linux (int32) WideCString from Nimrod's system/widestrs.nim

  type
    TUTF32Char* = distinct int32
    WideCString* = ref array[0..1_000_000, TUTF32Char]

  when not defined(c_strlen):
    proc c_strlen*(a: cstring): int {.nodecl, noSideEffect, importc: "strlen".}

  when true: # optimized procedure

    proc newWCS*(s: string): WideCString =
      if s.isNil: return nil
      let len = c_strlen(s)
      unsafeNew(result, len * 4 + 2)
      #result = cast[WideCString](alloc(len * 4 + 2))
      var d = 0
      for ch in runes(s):
        result[d] = TUTF32Char(ch)
        inc d
      result[d] = TUTF32Char(0'i32)

  else:
    const
      UNI_REPLACEMENT_CHAR = TUTF32Char(0xFFFD'i32)
      UNI_MAX_BMP = TRune(0x0000FFFF)
      UNI_MAX_UTF32 = TRune(0x7FFFFFFF)
      #UNI_MAX_LEGAL_UTF32 = TRune(0x0010FFFF)
      halfShift = 10
      halfBase = 0x0010000
      halfMask = 0x3FF
      UNI_SUR_HIGH_START = TRune(0xD800)
      #UNI_SUR_HIGH_END = TRune(0xDBFF)
      UNI_SUR_LOW_START = TRune(0xDC00)
      UNI_SUR_LOW_END = TRune(0xDFFF)

    proc newWCS*(s: string): WideCString =
      if s.isNil: return nil
      let len = c_strlen(s)
      unsafeNew(result, len * 4 + 2)
      #result = cast[WideCString](alloc(len * 4 + 2))
      var d = 0
      for ch in runes(s):
        if ch <=% UNI_MAX_BMP:
          if ch >=% UNI_SUR_HIGH_START and ch <=% UNI_SUR_LOW_END:
            result[d] = UNI_REPLACEMENT_CHAR
          else:
            result[d] = TUTF32Char(ch)
        elif ch >% UNI_MAX_UTF32:
          result[d] = UNI_REPLACEMENT_CHAR
        else:
          let ch = int32(ch) -% halfBase
          result[d] = TUTF32Char((ch shr halfShift) +% int32(UNI_SUR_HIGH_START))
          inc d
          result[d] = TUTF32Char((ch and halfMask) +% int32(UNI_SUR_LOW_START))
        inc d
      result[d] = TUTF32Char(0'i32)

else: # windows
  template newWCS*(s: string): WideCString =
    newWideCString(s)

