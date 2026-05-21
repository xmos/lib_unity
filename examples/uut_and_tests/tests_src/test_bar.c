// Copyright 2024-2026 XMOS LIMITED.
// This Software is subject to the terms of the XMOS Public Licence: Version 1.

#include <unity.h>
#include "uut.h"


void setUp(){}
void tearDown(){}

void test_bar0(void) {
    TEST_ASSERT_EQUAL(1, uut_returns_1());
}

void test_bar1(void) {
    TEST_ASSERT_EQUAL(1, uut_returns_1());
}

