cpuinfo.nim
===========
* proc simdGetAlignment
* proc simdAlloc
* proc sidmFree

hints.nim
=========
* const HINT_MOUSE_TOUCH_EVENTS
* const HINT_GAMECONTROLLERCONFIG_FILE
* const HINT_ANDROID_BLOCK_ON_PAUSE
* const HINT_RENDER_BATCHING
* const HINT_EVENT_LOGGING
* const HINT_WAVE_RIFF_CHUNK_SIZE
* const HINT_WAVE_TRUNCATION
* const HINT_WAVE_FACT_CHUNK
* deprecated HINT_ANDROID_SEPARATE_MOUSE_AND_TOUCH

rect.nim
========
* type FPoint
* type FRect

render.nim
==========
* renderDrawPointF
* renderDrawPointsF
* renderDrawLineF
* renderDrawLinesF
* renderDrawRectF
* renderDrawRectsF
* renderFillRectF
* renderFillRectsF
* renderCopyF
* renderCopyExF
* renderFlush

rwops.nim
=========
rw... and loadFile templates are now procedures

surface.nim
===========
* const SIMD_ALIGNED

touch.nim
=========
* type TouchDeviceType
* const MOUSE_TOUCHID
* proc getTouchDeviceType

