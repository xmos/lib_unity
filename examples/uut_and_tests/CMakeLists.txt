
cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(unit_test)

set(APP_HW_TARGET XCORE-AI-EXPLORER)
set(XMOS_SANDBOX_DIR ${CMAKE_SOURCE_DIR}/../../..)
set(APP_DEPENDENT_MODULES lib_unity)

# add uut and test sources
file(GLOB APP_C_SRCS CONFIGURE_DEPENDS RELATIVE ${CMAKE_CURRENT_LIST_DIR} uut_src/* tests_src/*)
set(APP_INCLUDES uut_src)

set(COMPILER_FLAGS      -g
                        -report
                        -Wall 
                        -Wextra)

# Create config for each test
file(GLOB tests RELATIVE ${CMAKE_CURRENT_LIST_DIR} CONFIGURE_DEPENDS tests_src/test*.c)
foreach(test_file ${tests})
    get_filename_component(test_name ${test_file} NAME_WE)
    set(SOURCE_FILES_${test_name}       ${test_file})
    set(APP_COMPILER_FLAGS_${test_name} ${COMPILER_FLAGS})
endforeach()

# Enable auto gen of test runners
set(LIB_UNITY_AUTO_TEST_RUNNER ON)

# Disable unity features that we dont use
set(LIB_UNITY_USE_FIXTURE OFF)
set(LIB_UNITY_USE_MEMORY OFF)

XMOS_REGISTER_APP()
