// Copyright 2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.
//
// UnityTestRunner calls each test's setup, body and teardown through function
// pointers, so the XCC linker cannot work out its stack usage. UNITY_STACKFUNCTION
// gives it a fixed stack allowance with resource directives (see unity_helper.c).
#ifndef UNITY_HELPER_H
#define UNITY_HELPER_H

#ifndef UNITY_TEST_RUNNER_STACK_SIZE
#define UNITY_TEST_RUNNER_STACK_SIZE 1024
#endif

/* Stringify helpers to force macro expansion */
#define UNITY_STRINGIFY_(x) #x
#define UNITY_STRINGIFY(x) UNITY_STRINGIFY_(x)

/**
 * @brief Macro to declare XMOS linker resource annotations for a function.
 */
#define UNITY_STACKFUNCTION(FN, BYTES) \
    asm(".resource_list_empty " #FN ", \"callees\""); \
    asm(".resource_list_empty " #FN ", \"tail_callees\""); \
    asm(".resource_list_empty " #FN ", \"parallel_callees\""); \
    asm(".resource_const " #FN ", \"stack_frame_bytes\", " UNITY_STRINGIFY(BYTES))

#endif // UNITY_HELPER_H
