set(VCPKG_POLICY_SKIP_COPYRIGHT_CHECK enabled)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Farama-Foundation/Arcade-Learning-Environment
    REF v0.11.2
    SHA512 ce4a3b1ca95306678d1d782fcc4de30a2c4404d1035fc26c01cb0b9bff99652b0095694a06dfca3d48e9b6e3f69c7266d7034400bd15fed946a5bc5cc9afa23a
    HEAD_REF master
)

set(SDL_SUPPORT OFF)
if("sdl" IN_LIST FEATURES)
    set(SDL_SUPPORT ON)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DBUILD_CPP_LIB=ON
        -DBUILD_PYTHON_LIB=OFF
        -DSDL_SUPPORT=${SDL_SUPPORT}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/ale PACKAGE_NAME ale)

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/ale/python/roms")

file(INSTALL "${CMAKE_CURRENT_LIST_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}")
