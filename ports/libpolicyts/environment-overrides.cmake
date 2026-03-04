# Ensure LIBTORCH_ROOT is:
#  1) available to the build environment
#  2) tracked in the ABI so changes trigger rebuilds / avoid wrong binary cache reuse

if(DEFINED VCPKG_ENV_PASSTHROUGH)
    set(VCPKG_ENV_PASSTHROUGH "LIBTORCH_ROOT;${VCPKG_ENV_PASSTHROUGH}")
else()
    set(VCPKG_ENV_PASSTHROUGH "LIBTORCH_ROOT")
endif()
