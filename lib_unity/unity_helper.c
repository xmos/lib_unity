// Copyright 2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.
//
// UnityTestRunner calls each test's setup, body and teardown through function
// pointers, so the linker cannot work out its stack usage. Unity's sources are
// not modified; instead this file describes UnityTestRunner to the linker with
// resource directives.
#if defined(__VX4B__) && defined(LIB_UNITY_USE_FIXTURE)

#if defined(UNITY_HELPER_RV_TOOLS)
asm(".resource_list_concat UnityTestRunner, \"callees\", \"unity_test_functions\"");
#else
asm(".resource_const UnityTestRunner, \"stack_frame_bytes\", 64");
asm(".resource_list_add UnityTestRunner, \"callees\", strstr, UnityPrint, putchar, setjmp, UnityPointer_UndoAllSets, UnityConcludeFixtureTest");
asm(".resource_list_empty UnityTestRunner, \"tail_callees\"");
asm(".resource_list_empty UnityTestRunner, \"parallel_callees\"");
#endif

#endif // defined(__VX4B__) && defined(LIB_UNITY_USE_FIXTURE)
