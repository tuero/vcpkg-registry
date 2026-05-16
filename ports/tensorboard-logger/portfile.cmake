set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO RustingSword/tensorboard_logger
    REF 69267c5782775a97bc9c01bec3fa537b739f79fd
    SHA512 c1c8d825f0e8f94826e2a7d6b93a482ab745e01f9314ee15a18a8cc72e173ff22df42ac7f81b48d08fdad264803fb0ee5014db9cb8b50042650e7b62803b7650
    PATCHES
        fix-protobuf-linkage.patch
        fix-cmake-config-dependencies.patch
    HEAD_REF master
)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(
    PACKAGE_NAME tensorboard_logger
    CONFIG_PATH cmake
)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/vcpkg-parallel-configure")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
