# Guard (recommended)
if(NOT DEFINED ENV{LIBTORCH_ROOT} OR "$ENV{LIBTORCH_ROOT}" STREQUAL "")
    message(FATAL_ERROR "libpolicyts: LIBTORCH_ROOT is missing inside vcpkg build env. Set it and passthrough via VCPKG_KEEP_ENV_VARS.")
endif()
if(NOT EXISTS "$ENV{LIBTORCH_ROOT}/Torch/TorchConfig.cmake")
    message(FATAL_ERROR "libpolicyts: expected $ENV{LIBTORCH_ROOT}/Torch/TorchConfig.cmake but it was not found.")
endif()

set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

# Where to find source
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tuero/libpolicyts
    REF "${VERSION}"
    SHA512 e3538d7012687820e96283ddf64a568c1769313abf8be425c0604d18f282ec06a5011beea224be49d7f8835ccfe029ff76dd1c11ae32e6cee8550caaac0017ff
    HEAD_REF master
)

# Features
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES 
    environment LIBPOLICYTS_BUILD_ENVIRONMENTS
    torch LIBPOLICYTS_BUILD_TORCH
)

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
