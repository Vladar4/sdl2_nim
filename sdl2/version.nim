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
#  This header defines the current SDL version.
#


#
# Information the version of SDL in use.
#
# Represents the library's version as three levels: major revision
# (increments with massive changes, additions, and enhancements),
# minor revision (increments with backwards-compatible changes to the
# major revision), and patchlevel (increments with fixes to the minor
# revision).
#
# See also: version, getVersion
#

type
  PVersion* = ptr TVersion
  TVersion* = object
    major*: Uint8 ## major version
    minor*: Uint8 ## minor version
    patch*: Uint8 ## update version


# Printable format: "$1.$2.$3" % [MAJOR, MINOR, PATCHLEVEL]
const
  MAJOR_VERSION* = 2
  MINOR_VERSION* = 0
  PATCHLEVEL* = 0


template version*(x: PVersion) =
  ## Template to determine SDL version program was compiled against.
  ##
  ## This template fills in a SDL_version structure with the version of the
  ## library you compiled against. This is determined by what header the
  ## compiler uses. Note that if you dynamically linked the library, you might
  ## have a slightly newer or older version at runtime. That version can be
  ## determined with getVersion(), which, unlike version(),
  ## is not a template.
  ##
  ## ``x`` A pointer to a TVersion struct to initialize.
  ##
  ## See also: version, getVersion
  x.major = MAJOR_VERSION
  x.minor = MINOR_VERSION
  x.patch = PATCHLEVEL


template version*(x: TVersion) =
  version(addr(x))


template versionNum*(x, y, z: Uint8): expr =
  ## This template turns the version numbers into a numeric value:
  ##
  ##  (1,2,3) -> (1203)
  ##
  ##  This assumes that there will never be more than 100 patchlevels.
  ((x)*1000'u8 + (y)*100'u8 + (z))


template compiledVersion*(): expr =
  ## This is the version number template for the current SDL version.
  versionNum(MAJOR_VERSION, MINOR_VERSION, PATCHLEVEL)


template versionAtLeast*(x, y, z: Uint8): bool =
  ## This template will evaluate to true if compiled with SDL
  ## at least ``x``.``y``.``z``.
  (compiledVersion() >= versionNum(x, y, z))


proc getVersion*(ver: PVersion) {.cdecl, importc: "SDL_GetVersion", dynlib: LibName.}
  ##  Get the version of SDL that is linked against your program.
  ##
  ## If you are linking to SDL dynamically, then it is possible that the
  ## current version will be different than the version you compiled against.
  ## This function returns the current version, while version() is a
  ## template that tells you what version you compiled with.
  ##
  ##
  ## var
  ##
  ##   compiled, linked: TVersion
  ##
  ##
  ## version(compiled)
  ##
  ## getVersion(linked)
  ##
  ## echo "We compiled against SDL version $1.$2.$3 ..." % [$compiled.major, $compiled.minor, $compiled.patch]
  ##
  ## echo "But we linked against SDL version $1.$2.$3." % [$linked.major, $linked.minor, $linked.patch]
  ##
  ##
  ## This function may be called safely at any time, even before init().
  ##
  ## See also: version


proc getRevision*(void): cstring {.cdecl, importc: "SLD_GetRevision", dynlib: LibName.}
  ## Get the code revision of SDL that is linked against your program.
  ##
  ## Returns an arbitrary string (a hash value) uniquely identifying the
  ## exact revision of the SDL library in use, and is only useful in comparing
  ## against other revisions. It is NOT an incrementing number.


proc getRevisionNumber*(): int {.cdecl, importc: "SDL_GetRevisionNumber", dynlib: LibName.}
  ## Get the revision number of SDL that is linked against your program.
  ##
  ## Returns a number uniquely identifying the exact revision of the SDL
  ## library in use. It is an incrementing number based on commits to
  ## hg.libsdl.org.

