set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

# Where to find source
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tuero/boulderdash_cpp
    REF "${VERSION}"
    SHA512 1c4dbb8b1b72918224d7708fc452c9407f3348714c8fade6edb438ef08c7bd9677c9c97f56dd8801e061e85741c13ab6e8b7a235d96354b013440e084c6803fb 
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS ${FEATURE_OPTIONS}
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
