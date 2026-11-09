// Copyright 2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.
//
// Gives the fixture's UnityTestRunner a fixed stack allowance for the XCC linker
// (see unity_helper.h). Not needed with the RISC-V tools.
#if defined(__VX4B__) && defined(LIB_UNITY_USE_FIXTURE) && !defined(UNITY_HELPER_RV_TOOLS)

#include "unity_helper.h"

UNITY_STACKFUNCTION(UnityTestRunner, UNITY_TEST_RUNNER_STACK_SIZE);

#endif // defined(__VX4B__) && defined(LIB_UNITY_USE_FIXTURE) && !defined(UNITY_HELPER_RV_TOOLS)
