
#if defined(__VX4B__)

/**
 * @brief Macro to declare XMOS linker resource annotations for a function.
 */
#define UNITY_STACKFUNCTION(FN, BYTES) \
    asm(".resource_list_empty " #FN ", \"callees\""); \
    asm(".resource_list_empty " #FN ", \"tail_callees\""); \
    asm(".resource_list_empty " #FN ", \"parallel_callees\""); \
    asm(".resource_const " #FN ", \"stack_frame_bytes\", " #BYTES)

UNITY_STACKFUNCTION(UnityTestRunner, 1024);

#endif // defined(__VX4B__)
