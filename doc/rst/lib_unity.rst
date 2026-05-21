lib_unity
=========

.. warning:: This documentation is a work in progress.

Overview
--------

lib_unity is a small utility library that adapts the Unity unit test framework for use with the
xcommon_cmake-based XMOS build system.

For more information about the Unity test framework, see the upstream project:

https://github.com/ThrowTheSwitch/Unity/blob/master/docs/UnityGettingStartedGuide.md

How to use
----------

To use this library in an xcommon_cmake project, add the module to your application's
`APP_DEPENDENT_MODULES` list in `CMakeLists.txt`, for example:

.. code-block:: cmake

    set(APP_DEPENDENT_MODULES "lib_unity")

.. note:: Dependent modules should be pinned to release versions where possible; otherwise the
   latest commit on the `develop` branch will be used. See the xcommon-cmake documentation for
   dependency management details.

Example
-------

The repository includes a small example in `examples/basic` that demonstrates a minimal Unity
test group and a simple test runner.

A brief excerpt from the tests (examples/basic/src/test_basic.c):

.. literalinclude:: ../../examples/basic/src/test_basic.c
    :language: c
    :start-after: #include "unity.h"

And the corresponding test runner (examples/basic/src/main.c):

.. literalinclude:: ../../examples/basic/src/main.c
    :language: c
    :start-after: #include "unity_fixture.h"

How to build the example
------------------------

From the repository root, go to the example directory and run cmake and xmake:

.. code-block:: console

    cd examples/basic
    cmake -G "Unix Makefiles" -B build
    xmake -C build

How to run the example
----------------------

Run the generated binary with xsim:

.. code-block:: console

    xsim bin/test_basic.xe

Expected output
---------------

.. code-block:: console

    3 Tests 0 Failures 0 Ignored
    OK
