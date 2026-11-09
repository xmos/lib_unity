// Copyright 2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#include "unity.h"
#include "unity_fixture.h"

TEST_GROUP_RUNNER(test_basic) {
  RUN_TEST_CASE(test_basic, sum_test);
  RUN_TEST_CASE(test_basic, div_test);
  RUN_TEST_CASE(test_basic, float_test);
}

TEST_GROUP(test_basic);
TEST_SETUP(test_basic) {/*Optional setup*/}
TEST_TEAR_DOWN(test_basic) {/*Optional cleanup*/}

TEST(test_basic, sum_test) {
  int result = 2 + 3;
  TEST_ASSERT_EQUAL_INT(5, result);
}

TEST(test_basic, div_test) {
  int result = 20 / 4;
  TEST_ASSERT_EQUAL_INT(5, result);
}

TEST(test_basic, float_test) {
  const float radius = 2.0f;
  const float pi = 3.14159265f;
  float area = pi * radius * radius;
  TEST_ASSERT_FLOAT_WITHIN(0.0001f, 12.5663706f, area);
}
