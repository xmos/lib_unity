set(LIB_NAME lib_unity)
set(LIB_VERSION 2.5.2)
set(LIB_INCLUDES Unity/src
                 Unity/extras/fixture/src
                 Unity/extras/memory/src)
set(LIB_C_SRCS Unity/src/unity.c
               Unity/extras/fixture/src/unity_fixture.c
               Unity/extras/memory/src/unity_memory.c)
set(LIB_DEPENDENT_MODULES "")
set(LIB_COMPILER_FLAGS -Wno-xcore-fptrgroup)

XMOS_REGISTER_MODULE()
