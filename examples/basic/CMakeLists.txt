cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(test_basic)

set(SUPPORTED_TARGETS "XK-EVK-XU316;XK-EVK-XU416")

if(NOT DEFINED APP_HW_TARGET)
    set(APP_HW_TARGET XK-EVK-XU316)
endif()

set(APP_INCLUDES              src)

set(APP_COMPILER_FLAGS        -g)

set(APP_DEPENDENT_MODULES    "lib_unity")

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../../..)

if(NOT APP_HW_TARGET IN_LIST SUPPORTED_TARGETS)
  message(FATAL_ERROR "Unsupported target ${APP_HW_TARGET}.")
endif()

XMOS_REGISTER_APP()
