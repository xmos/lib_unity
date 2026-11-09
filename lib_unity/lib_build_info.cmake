set(LIB_NAME lib_unity)
set(LIB_VERSION 2.7.0)
set(LIB_INCLUDES Unity/src)
set(LIB_C_SRCS Unity/src/unity.c)
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
set(LIB_COMPILER_FLAGS -Os -Werror ${WNO_FPTR})

# conditional sources and includes
if(LIB_UNITY_USE_FIXTURE)
    list(APPEND LIB_INCLUDES Unity/extras/fixture/src)
    list(APPEND LIB_C_SRCS Unity/extras/fixture/src/unity_fixture.c)
    list(APPEND LIB_COMPILER_FLAGS -DLIB_UNITY_USE_FIXTURE=1)
endif()

if(LIB_UNITY_USE_MEMORY)
    list(APPEND LIB_INCLUDES Unity/extras/memory/src)
    list(APPEND LIB_C_SRCS Unity/extras/memory/src/unity_memory.c)
endif()

# Unity Helper: describes UnityTestRunner's function pointer calls to the linker.
# Always built; the source itself is guarded (vx4 builds with the fixture enabled).
list(APPEND LIB_C_SRCS unity_helper.c)
if(XMOS_IS_RV)
    list(APPEND LIB_COMPILER_FLAGS -DUNITY_HELPER_RV_TOOLS=1)
endif()

XMOS_REGISTER_MODULE()

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

        # Build targets are <app>_<config>, or <app>_<config>_objlib with the RISC-V tools
        if(XMOS_IS_RV)
            set(target_suffix "_objlib")
        else()
            set(target_suffix "")
        endif()
        set(this_target ${APP_BUILD_TARGETS})
        list(FILTER this_target INCLUDE REGEX ".*_${config_suffix}${target_suffix}$")

        set(TEST_RUNNER ${CMAKE_CURRENT_BINARY_DIR}/${config_suffix}_runner.c)
        add_custom_command(
                         OUTPUT ${TEST_RUNNER}
                         COMMAND ${RUBY_EXE} ${CMAKE_CURRENT_LIST_DIR}/Unity/auto/generate_test_runner.rb ${config_sources} ${TEST_RUNNER}
                         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                         DEPENDS ${config_sources}
                         VERBATIM)

        set(runner_source ${TEST_RUNNER})
        if(APP_BUILD_ARCH STREQUAL "vx4b" AND NOT XMOS_IS_RV)
            # XCC: the runner's static run_test() must be described to the linker in its
            # own translation unit, so compile the runner through a wrapper that annotates
            # it (see unity_helper.h). The generated runner itself is not compiled.
            set(runner_source ${CMAKE_CURRENT_BINARY_DIR}/${config_suffix}_runner_wrapper.c)
            file(CONFIGURE OUTPUT ${runner_source} CONTENT
                 "#include \"${CMAKE_CURRENT_LIST_DIR}/unity_helper.h\"\nUNITY_STACKFUNCTION(run_test, UNITY_TEST_RUNNER_STACK_SIZE);\n#include \"${TEST_RUNNER}\"\n")
            set_source_files_properties(${TEST_RUNNER} PROPERTIES HEADER_FILE_ONLY TRUE)
            set_source_files_properties(${runner_source} PROPERTIES OBJECT_DEPENDS ${TEST_RUNNER})
        endif()

        if(APP_BUILD_ARCH STREQUAL "xs3a" OR APP_BUILD_ARCH STREQUAL "vx4b")
        set_source_files_properties(${runner_source} PROPERTIES COMPILE_OPTIONS ${WNO_FPTR})
        endif()
        get_target_property(target_sources ${this_target} SOURCES)
        list(APPEND target_sources ${TEST_RUNNER})
        if(NOT runner_source STREQUAL TEST_RUNNER)
            list(APPEND target_sources ${runner_source})
        endif()
        set_target_properties(${this_target} PROPERTIES SOURCES "${target_sources}")
    endforeach()
endif()
