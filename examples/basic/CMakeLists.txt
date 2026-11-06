cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(test_basic)

if(NOT DEFINED APP_HW_TARGET AND NOT BUILD_NATIVE AND NOT XMOS_IS_RV)
    set(APP_HW_TARGET XK-EVK-XU316)
endif()

set(APP_INCLUDES              src)

set(APP_COMPILER_FLAGS        -g)

set(APP_DEPENDENT_MODULES    "lib_unity")

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..)

# sinf() is in libm, which the RISC-V tools do not link by default
if(XMOS_IS_RV)
    link_libraries(m)
endif()

XMOS_REGISTER_APP()
