#if defined(__VX4B__)

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

UNITY_STACKFUNCTION(UnityTestRunner, UNITY_TEST_RUNNER_STACK_SIZE);

#endif // defined(__VX4B__)
