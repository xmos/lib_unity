# lib name and version
set(LIB_NAME lib_unity)
set(LIB_VERSION 2.8.0)

# source code
set(LIB_UNITY_UNITY_DIR ../third_party/Unity)
set(LIB_INCLUDES ${LIB_UNITY_UNITY_DIR}/src)
set(LIB_C_SRCS ${LIB_UNITY_UNITY_DIR}/src/unity.c)
set(LIB_DEPENDENT_MODULES "")

# cmake options
option(LIB_UNITY_USE_FIXTURE "Include unity memory and fixtures extras" ON)
option(LIB_UNITY_USE_MEMORY "Include unity memory and memorys extras" ON)
option(LIB_UNITY_AUTO_TEST_RUNNER "Enable to generate a test runner for each build config" OFF)

# compiler flags (based on target)
if(APP_BUILD_ARCH STREQUAL "xs3a") # xs3
    set(WNO_FPTR -Wno-xcore-fptrgroup)
elseif(APP_BUILD_ARCH STREQUAL "vx4b") # vx4
    set(WNO_FPTR -Wno-fptrgroup)
else() # native
    set(WNO_FPTR "")
endif()
set(LIB_COMPILER_FLAGS -Os ${WNO_FPTR})

# Unity calls each test through not annotated function pointers
# Note: the error is also valid for xs3 but the report section will signal as MAYBE and cover the worst case. 
if (APP_BUILD_ARCH STREQUAL "vx4b")
    message(WARNING "lib_unity: UnityTestRunner stack usage is not calculable")
endif()

# conditional sources and includes
if(LIB_UNITY_USE_FIXTURE)
    list(APPEND LIB_INCLUDES ${LIB_UNITY_UNITY_DIR}/extras/fixture/src)
    list(APPEND LIB_C_SRCS ${LIB_UNITY_UNITY_DIR}/extras/fixture/src/unity_fixture.c)
    list(APPEND LIB_COMPILER_FLAGS -DLIB_UNITY_USE_FIXTURE=1)
endif()

if(LIB_UNITY_USE_MEMORY)
    list(APPEND LIB_INCLUDES ${LIB_UNITY_UNITY_DIR}/extras/memory/src)
    list(APPEND LIB_C_SRCS ${LIB_UNITY_UNITY_DIR}/extras/memory/src/unity_memory.c)
endif()

XMOS_REGISTER_MODULE()

# Auto test runner generation for each build config
if(LIB_UNITY_AUTO_TEST_RUNNER)
    find_program(RUBY_EXE ruby REQUIRED)

    # Find all the build configs
    get_cmake_property(all_vars VARIABLES)
    list(FILTER all_vars INCLUDE REGEX "SOURCE_FILES_.*")
    
    # remove private xcommon variable which happens to have this regex
    list(FILTER all_vars EXCLUDE REGEX "SOURCE_FILES_VARS")

    # Build targets are <app>_<config>, or <app>_<config>_objlib with the RISC-V tools
    if(XMOS_IS_RV)
        set(target_suffix "_objlib")
    else()
        set(target_suffix "")
    endif()

    foreach(source_config_var ${all_vars})
        string(REGEX MATCH "SOURCE_FILES_(.+)" ____ ${source_config_var})
        set(config_suffix ${CMAKE_MATCH_1})
        set(config_sources ${${source_config_var}})
        list(FILTER config_sources INCLUDE REGEX "test_.*")

        # check there is only one test file
        list(LENGTH config_sources num_test_files)
        if(NOT num_test_files MATCHES 1)
            message(FATAL_ERROR "More than 1 test file for config ${config_suffix}: ${config_sources}")
        endif()

        set(this_target ${APP_BUILD_TARGETS})
        list(FILTER this_target INCLUDE REGEX ".*_${config_suffix}${target_suffix}$$")

        set(TEST_RUNNER ${CMAKE_CURRENT_BINARY_DIR}/${config_suffix}_runner.c)
        add_custom_command(
                         OUTPUT ${TEST_RUNNER}
                         COMMAND ${RUBY_EXE} ${CMAKE_CURRENT_LIST_DIR}/${LIB_UNITY_UNITY_DIR}/auto/generate_test_runner.rb ${config_sources} ${TEST_RUNNER}
                         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                         DEPENDS ${config_sources}
                         VERBATIM)
        
        if(APP_BUILD_ARCH STREQUAL "xs3a" OR APP_BUILD_ARCH STREQUAL "vx4b")
        set_source_files_properties(${TEST_RUNNER} PROPERTIES COMPILE_OPTIONS ${WNO_FPTR})
        endif()
        get_target_property(target_sources ${this_target} SOURCES)
        list(APPEND target_sources ${TEST_RUNNER})
        set_target_properties(${this_target} PROPERTIES SOURCES "${target_sources}")
    endforeach()
endif()
