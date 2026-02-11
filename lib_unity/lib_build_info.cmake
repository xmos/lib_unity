set(LIB_NAME lib_unity)
set(LIB_VERSION 2.6.1)
set(LIB_INCLUDES Unity/src)
set(LIB_C_SRCS Unity/src/unity.c)
set(LIB_DEPENDENT_MODULES "")

# conditional depending on target
if(CMAKE_C_COMPILER_VERSION VERSION_EQUAL "3.6.0")
    set(__XS3__ ON) # XS3 (XTC 15.3.1)
else()
    set(__XS3__ OFF) # VX4
endif()

if(NOT BUILD_NATIVE)
    if(__XS3__) # xs3
        set(LIB_COMPILER_FLAGS 
                                -Os 
                                -Wno-xcore-fptrgroup
            )
    else() # vx4
        list(APPEND LIB_C_SRCS unity_helper.c)
        set(LIB_COMPILER_FLAGS 
                                -Os
                                -Wfptrgroup
                                -ffunction-sections
                                -fdata-sections
            )
    endif()
endif() # BUILD_NATIVE

option(LIB_UNITY_USE_FIXTURE "Include unity memory and fixtures extras" ON)
if(LIB_UNITY_USE_FIXTURE)
    list(APPEND LIB_INCLUDES Unity/extras/fixture/src)
    list(APPEND LIB_C_SRCS Unity/extras/fixture/src/unity_fixture.c)
endif()

option(LIB_UNITY_USE_MEMORY "Include unity memory and memorys extras" ON)
if(LIB_UNITY_USE_MEMORY)
    list(APPEND LIB_INCLUDES Unity/extras/memory/src)
    list(APPEND LIB_C_SRCS Unity/extras/memory/src/unity_memory.c)
endif()

XMOS_REGISTER_MODULE()

option(LIB_UNITY_AUTO_TEST_RUNNER
       "Enable to generate a test runner for each build config"
       OFF)
if(LIB_UNITY_AUTO_TEST_RUNNER)
    find_program(RUBY_EXE ruby REQUIRED)

    # Find all the build configs
    get_cmake_property(all_vars VARIABLES)
    list(FILTER all_vars INCLUDE REGEX "SOURCE_FILES_.*")
    # remove private xcommon variable which happens to have
    # this regex
    list(FILTER all_vars EXCLUDE REGEX "SOURCE_FILES_VARS")

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
        list(FILTER this_target INCLUDE REGEX ".*_${config_suffix}$$")

        set(TEST_RUNNER ${CMAKE_CURRENT_BINARY_DIR}/${config_suffix}_runner.c)
        add_custom_command(
                         OUTPUT ${TEST_RUNNER}
                         COMMAND ${RUBY_EXE} ${CMAKE_CURRENT_LIST_DIR}/Unity/auto/generate_test_runner.rb ${config_sources} ${TEST_RUNNER}
                         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                         DEPENDS ${config_sources}
                         VERBATIM)
        set_source_files_properties(${TEST_RUNNER} PROPERTIES COMPILE_OPTIONS -Wno-xcore-fptrgroup)
        get_target_property(target_sources ${this_target} SOURCES)
        list(APPEND target_sources ${TEST_RUNNER})
        set_target_properties(${this_target} PROPERTIES SOURCES "${target_sources}")
    endforeach()
endif()
