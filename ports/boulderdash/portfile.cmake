set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

# Where to find source
vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tuero/boulderdash_cpp
    REF "${VERSION}"
    SHA512 179af2a8fbf52d5bba11fce411fef489f8b53d73ce0b33b6eae2d1f51706c6c2b201b4735cd27436b2759bb548252b61f6e9e6fdabaeb06f0e1d784f859d9acb
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
