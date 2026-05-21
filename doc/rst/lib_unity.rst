lib_unity
=========

.. warning:: This documentation is a work in progress.

Overview
--------

``lib_unity`` is a small utility library that adapts the `Unity unit test framework
<https://github.com/ThrowTheSwitch/Unity>`_ for use with the ``xcommon_cmake`` based XMOS build
system. It provides the necessary CMake integration to compile and link Unity into your XCore
application, along with helper fixtures for structuring test groups and a test runner.

Compatibility
-------------

- **Toolchain:** XMOS XTC Tools 15.3.1 or later
- **Unity version:** 2.6.0 (vendored)
- **Build system:** xcommon_cmake

How to use
----------

Add ``lib_unity`` to your application's ``APP_DEPENDENT_MODULES`` list in ``CMakeLists.txt``:

.. code-block:: cmake

    set(APP_DEPENDENT_MODULES "lib_unity")

Pin the dependency to a release tag where possible. If no version is specified, xcommon_cmake will
use the latest commit on the ``develop`` branch. 

See the `xcommon_cmake documentation <https://www.xmos.com/documentation/XM-014363-PC/html/>`_ for
dependency management details.

What the library provides
~~~~~~~~~~~~~~~~~~~~~~~~~

After adding the module, your application gains:

- The Unity and Unity Fixture headers (``unity.h``, ``unity_fixture.h``)
- A CMake target that compiles and links the Unity source files automatically
- No additional configuration is required; Unity's default settings are used

Example
-------

The repository includes a minimal working example in ``examples/basic`` that demonstrates a test
group and a test runner using the Unity Fixture API.

Test file (``examples/basic/src/test_basic.c``):

.. literalinclude:: ../../examples/basic/src/test_basic.c
    :language: c
    :start-after: #include "unity.h"

Test runner (``examples/basic/src/main.c``):

.. literalinclude:: ../../examples/basic/src/main.c
    :language: c
    :start-after: #include "unity_fixture.h"

How to build the example
------------------------

From the repository root, navigate to the example directory and run CMake followed by ``xmake``:

.. code-block:: console

    cd examples/basic
    cmake -B build -G "Unix Makefiles"
    xmake -C build

How to run the example
----------------------

Simulate the test binary using ``xsim``:

.. code-block:: console

    xsim bin/test_basic.xe

.. note:: Running on hardware is outside the scope of this example. To run on a development board,
   use ``xrun`` with an appropriate target adapter.

Expected output
---------------

A passing test run produces:

.. code-block:: console

    3 Tests 0 Failures 0 Ignored
    OK
