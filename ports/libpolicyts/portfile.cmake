set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

# Where to find source
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tuero/libpolicyts
    REF "${VERSION}"
    SHA512 f2ee44982c52fe910ace5983d37a8eabcf3b8d1f8175fc9d058dfd4cb082919aac99fb0e62a5678d1a9ee98565e51245033e7445935ad551ed5eece8452e717b
    HEAD_REF master
)

# Features
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES 
    environment LIBPOLICYTS_BUILD_ENVIRONMENTS
    torch LIBPOLICYTS_BUILD_TORCH
)

# Torch is only required when the vcpkg feature "torch" is enabled
if("torch" IN_LIST FEATURES)
  if(NOT DEFINED ENV{LIBTORCH_ROOT} OR "$ENV{LIBTORCH_ROOT}" STREQUAL "")
    message(FATAL_ERROR
      "libpolicyts[torch]: Torch support is enabled, but LIBTORCH_ROOT is not set/passed through.\n"
      "Set LIBTORCH_ROOT (e.g. from conda torch.utils.cmake_prefix_path) and passthrough via VCPKG_KEEP_ENV_VARS or a triplet."
    )
  endif()

  if(NOT EXISTS "$ENV{LIBTORCH_ROOT}/Torch/TorchConfig.cmake")
    message(FATAL_ERROR
      "libpolicyts[torch]: expected TorchConfig.cmake at:\n"
      "  $ENV{LIBTORCH_ROOT}/Torch/TorchConfig.cmake\n"
      "but it was not found."
    )
  endif()

  list(APPEND FEATURE_OPTIONS
    "-DTorch_DIR=$ENV{LIBTORCH_ROOT}/Torch"
  )
endif()

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${FEATURE_OPTIONS} "-DTorch_DIR=$ENV{LIBTORCH_ROOT}/Torch"
)
vcpkg_cmake_install()

# For multi-config, vcpkg has to install into different prefixes `<installed>/` and `<installed>/debug`,
#   then move the cmake files into a single directory
# We thus tell vcpkg where our CMake config files are installed to so it can do the work
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

# Similar to the above for multi-config, this will delete the include directory from the debug 
#   installation to prevent overlap
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Usage file
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
