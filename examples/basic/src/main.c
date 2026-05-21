// Copyright 2020-2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#include <stdio.h>

#include "unity_fixture.h"

int main(int argc, const char* argv[])
{
  UnityGetCommandLineOptions(argc, argv);
  UnityBegin(argv[0]);

  printf("\n\n");

  RUN_TEST_GROUP(test_basic);
  return UNITY_END();
}
