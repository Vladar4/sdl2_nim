#
#  Simple DirectMedia Layer
#  Copyright (C) 2017, Mark Callow
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

##  vulkan.nim
##  ==========
##
##  Header file for procedures to creating Vulkan surfaces on SDL windows.

# #define VK_DEFINE_HANDLE(object) typedef struct object##_T* object;
#
# #if defined(__LP64__) || defined(_WIN64) || defined(__x86_64__) || defined(_M_X64) || defined(__ia64) || defined (_M_IA64) || defined(__aarch64__) || defined(__powerpc64__)
# #define VK_DEFINE_NON_DISPATCHABLE_HANDLE(object) typedef struct object##_T *object;
# #else
# #define VK_DEFINE_NON_DISPATCHABLE_HANDLE(object) typedef uint64_t object;
# #endif
#
# VK_DEFINE_HANDLE(VkInstance)
# VK_DEFINE_NON_DISPATCHABLE_HANDLE(VkSurfaceKHR)

# Avoid including vulkan.h, don't define VkInstance if it's already included
when not declared(VkInstance):
  type
    VkInstance* = pointer

when not declared(VkSurfaceKHR):
  type
    VkSurfaceKHR* = pointer

type
  VulkanInstance* = VkInstance
  VulkanSurface* = VkSurfaceKHR ##  for compatibility with Tizen


##  Vulkan support procedures
##
##  ``Note:`` ``vulkanGetInstanceExtensions`` & ``vulkan_CreateSurface`` API
##  is compatable with Tizen's implementation of Vulkan in SDL.


proc vulkanLoadLibrary*(path: cstring): cint {.
    cdecl, importc: "SDL_Vulkan_LoadLibrary", dynlib: SDL2_LIB.}
  ##  Dynamically load a Vulkan loader library.
  ##
  ##  ``path`` The platform dependent Vulkan loader library name, or `nil`.
  ##
  ##  ``Return`` `0` on success, or `-1` if the library couldn't be loaded.
  ##
  ##  If ``path`` is `nil` SDL will use the value of the environment variable
  ##  ``SDL_VULKAN_LIBRARY``, if set, otherwise it loads the default Vulkan
  ##  loader library.
  ##
  ##  This should be called after initializing the video driver, but before
  ##  creating any Vulkan windows. If no Vulkan loader library is loaded, the
  ##  default library will be loaded upon creation of the first Vulkan window.
  ##
  ##  ``Note:`` It is fairly common for Vulkan applications to link with
  ##  ``libvulkan`` instead of explicitly loading it at run time. This will
  ##  work with SDL provided the application links to a dynamic library and
  ##  both it and SDL use the same search path.
  ##
  ##  ``Note:`` If you specify a non-`nil` ``path``, an application should
  ##  retrieve all of the Vulkan procedures it uses from the dynamic library
  ##  using ``vulkanGetVkGetInstanceProcAddr()`` unless you can guarantee
  ##  ``path`` points to the same vulkan loader library the application
  ##  linked to.
  ##
  ##  ``Note:`` On Apple devices, if ``path`` is `nil`, SDL will attempt to find
  ##  the ``vkGetInstanceProcAddr`` address within all the mach-o images of
  ##  the current process. This is because it is fairly common for Vulkan
  ##  applications to link with libvulkan (and historically MoltenVK was
  ##  provided as a static library). If it is not found then, on macOS, SDL
  ##  will attempt to load ``vulkan.framework/vulkan``, ``libvulkan.1.dylib``,
  ##  followed by ``libvulkan.dylib``, in that order.
  ##  On iOS SDL will attempt to load ``libvulkan.dylib`` only. Applications
  ##  using a dynamic framework or .dylib must ensure it is included in its
  ##  application bundle.
  ##
  ##  ``Note`` On non-Apple devices, application linking with a static
  ##  libvulkan is not supported. Either do not link to the Vulkan loader or
  ##  link to a dynamic library version.
  ##
  ##  ``Note:`` This procedures will fail if there are no working Vulkan drivers
  ##  installed.
  ##
  ##  See also:
  ##
  ##  ``vulkanGetVkGetInstanceProcAddr()``
  ##
  ##  ``vulkanUnloadLibrary()``

proc vulkanGetVkGetInstanceProcAddr*(): pointer {.
    cdecl, importc: "SDL_Vulkan_GetVkGetInstanceProcAddr", dynlib: SDL2_LIB.}
  ##  Get the address of the ``vkGetInstanceProcAddr`` procedure.
  ##
  ##  ``Note:`` This should be called after either calling ``vulkanLoadLibrary``
  ##  or creating an SDL_Window with the `WINDOW_VULKAN` flag.

proc vulkanUnloadLibrary*() {.
    cdecl, importc: "SDL_Vulkan_UnloadLibrary", dynlib: SDL2_LIB.}
  ##  Unload the Vulkan loader library previously loaded by
  ##  ``vulkanLoadLibrary()``.
  ##
  ##  See also:
  ##
  ##  ``vulkanLoadLibrary()``

proc vulkanGetInstanceExtensions*(
    window: Window; pCount: ptr cuint; pNames: cstringArray): bool {.
    cdecl, importc: "SDL_Vulkan_GetInstanceExtensions", dynlib: SDL2_LIB.}
  ##  Get the names of the Vulkan instance extensions needed to create
  ##  a surface with ``vulkan_CreateSurface()``.
  ##
  ##  ``window`` `nil` or window for which the required Vulkan instance
  ##  extensions should be retrieved.
  ##
  ##  ``pCount`` Pointer to an ``cuint`` related to the number of
  ##  required Vulkan instance extensions.
  ##
  ##  ``pNames`` `nil` or a pointer to an array to be filled with the
  ##  required Vulkan instance extensions.
  ##
  ##  ``Return`` `true` on success, `false` on error.
  ##
  ##  If ``pNames`` is `nil`, then the number of required Vulkan instance
  ##  extensions is returned in ``pCount``. Otherwise, ``pCount`` must point
  ##  to a variable set to the number of elements in the ``pNames`` array,
  ##  and on return the variable is overwritten with the number of names
  ##  actually written to ``pNames``. If ``pCount`` is less than the number
  ##  of required extensions, at most ``pCount`` structures will be written.
  ##  If ``pCount`` is smaller than the number of required extensions,
  ##  `0` will be returned instead `1`, to indicate that not all the required
  ##  extensions were returned.
  ##
  ##  ``Note:`` If ``window`` is not `nil`, it will be checked against its
  ##  creation flags to ensure that the Vulkan flag is present. This parameter
  ##  will be removed in a future major release.
  ##
  ##  ``Note:`` The returned list of extensions will contain VK_KHR_surface
  ##  and zero or more platform specific extensions
  ##
  ##  ``Note:`` The extension names queried here must be enabled when calling
  ##  ``vkCreateInstance``, otherwise surface creation will fail.
  ##
  ##  ``Note:`` ``window`` should have been created with the
  ##  `WINDOW_VULKAN` flag or be `nil`.
  ##
  ##  .. code-block:: nim
  ##    var count: cuint
  ##
  ##    # get count of required extensions
  ##    if not vulkanGetInstanceExtensions(nil, addr(count), nil):
  ##      handleError()
  ##
  ##    var
  ##      additionalExtensions: ptr cstring = [
  ##        VK_EXT_DEBUG_REPORT_EXTENSION_NAME] # example additional extension
  ##
  ##      additionalExtensionsCount: csize = sizeof(
  ##        (additionalExtensions) div sizeof((additionalExtensions[0]))
  ##
  ##      extensionCount: csize = count + additionalExtensionsCount
  ##
  ##      names: cstringArray = malloc(sizeof(cast[cstring](extensionCount[])))
  ##
  ##    if not names:
  ##      handleError()
  ##
  ##    # get names of required extensions
  ##    if not vulkanGetInstanceExtensions(nil, addr(count), names):
  ##      handleError()
  ##
  ##    # copy additional extensions after required extensions
  ##    for i in 0..<additionalExtensionsCount:
  ##      names[i + count] = additionalExtensions[i]
  ##
  ##    var instanceCreateInfo: VkInstanceCreateInfo = []
  ##
  ##    instanceCreateInfo.enabledExtensionCount = extensionCount
  ##    instanceCreateInfo.ppEnabledExtensionNames = names
  ##    # fill in rest of instanceCreateInfo
  ##
  ##    var instance: VkInstance
  ##
  ##    # create the Vulkan instance
  ##    var result*: VkResult = vkCreateInstance(
  ##      addr(instanceCreateInfo), nil, addr(instance))
  ##
  ##    free(names)
  ##
  ##  See also:
  ##
  ##  ``vulkanCreateSurface()``

proc vulkanCreateSurface*(window: Window; instance: VkInstance;
                          surface: ptr VkSurfaceKHR): bool {.
    cdecl, importc: "SDL_Vulkan_CreateSurface", dynlib: SDL2_LIB.}
  ##  Create a Vulkan rendering surface for a window.
  ##
  ##  ``window``    ``Window`` to which to attach the rendering surface.
  ##
  ##  ``instance``  Handle to the Vulkan instance to use.
  ##
  ##  ``surface``   Pointer to a VkSurfaceKHR handle to receive
  ##  the handle of the newly created surface.
  ##
  ##  ``Return`` `true` on success, `false` on error.
  ##
  ##  .. code-block:: nim
  ##    var
  ##      instance: VkInstance
  ##      window: Wwindow
  ##
  ##    # create instance and window
  ##
  ##    # create the Vulkan surface
  ##    var surface: VkSurfaceKHR
  ##    if not vulkanCreateSurface(window, instance, addr(surface)):
  ##      handleError()
  ##
  ##  ``Note:`` ``window`` should have been created with the
  ##  `WINDOW_VULKAN` flag.
  ##
  ##  ``Note:`` ``instance`` should have been created with the
  ##  extensions returned by ``vulkanCreateSurface()`` enabled.
  ##
  ##  See also:
  ##
  ##  ``vulkanGetInstanceExtensions()``

proc vulkanGetDrawableSize*(window: Window; w: ptr cint; h: ptr cint) {.
    cdecl, importc: "SDL_Vulkan_GetDrawableSize", dynlib: SDL2_LIB.}
  ##  Get the size of a window's underlying drawable in pixels
  ##  (for use with setting viewport, scissor & etc).
  ##
  ##  ``window``  ``Window`` from which the drawable size should be queried.
  ##
  ##  ``w``       Pointer to variable for storing the width in pixels,
  ##  may be `nil`.
  ##
  ##  ``h``       Pointer to variable for storing the height in pixels,
  ##  may be `nil`.
  ##
  ##  This may differ from ``getWindowSize()`` if we're rendering to a high-DPI
  ##  drawable, i.e. the window was created with `WINDOW_ALLOW_HIGHDPI` on a
  ##  platform with high-DPI support (Apple calls this "Retina"),
  ##  and not disabled by the `HINT_VIDEO_HIGHDPI_DISABLED` hint.
  ##
  ##  ``Note:`` On macOS high-DPI support must be enabled for an application by
  ##  setting ``NSHighResolutionCapable`` to `true` in its ``Info.plist``.
  ##
  ##  See also:
  ##
  ##  ``getWindowSize()``
  ##
  ##  ``createWindow()``

