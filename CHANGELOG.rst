lib_unity change log
====================

UNRELEASED
----------

  * ADDED: Support for VX4 builds with the RISC-V (clang) tools.
  * ADDED: Linker stack information for the function pointer calls in the auto-generated test runners on VX4.
  * CHANGED: Examples build and tests run with all supported tools.
  * FIXED: Auto test runner generation with the RISC-V tools.
  * FIXED: uut_and_tests example used the wrong sandbox directory when built from the examples directory.

2.7.0
-----

  * ADDED: Initial support for vx4 builds.
  * CHANGED: Tools version to 15.3.1.
  * CHANGED: submodule of upstream Unity to tag v2.6.1

2.6.1
-----

  * FIXED:   build failures with XCommon CMake BUILD_NATIVE enabled

2.6.0
-----

  * ADDED: cmake for automatically generating test runners for XCommon CMake
    applications. Also an example of using this feature.
  * CHANGED: submodule of upstream Unity to tag v2.6.0

2.5.2
-----

  * Initial version of library with tag v2.5.2 of upstream Unity submodule

