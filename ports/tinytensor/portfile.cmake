set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

# Where to find source
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tuero/tinytensor
    REF "${VERSION}"
    SHA512 aefd249e31415ac83522c1349d181c04fbf1959f0ccd906ac2e461ccdf1e8c1af91da8792a8d4e169e167650b62e17e7ff6e63e3ba0dc819328d85ccce900a00
    HEAD_REF master
)

# Features
vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES 
    cuda TT_BUILD_CUDA
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${FEATURE_OPTIONS}
)
vcpkg_cmake_install()

# CMake config files are installed to lib/cmake/tinytensor for both release and debug
# For multi-config, vcpkg has to install into different prefixes `<installed>/` and `<installed>/debug`,
#   then move the cmake files into a single directory
# We thus tell vcpkg where our CMake config files are installed to so it can do the work
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/${PORT})

# Similar to the above for multi-config, this will delete the include directory from the debug 
#   installation to prevent overlap
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

# Usage file
file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
