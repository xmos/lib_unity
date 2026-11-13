###############################
lib_unity: Unity test framework
###############################

************
Introduction
************

``lib_unity`` adapts the `Unity unit test framework <https://github.com/ThrowTheSwitch/Unity>`_
for use with the `XCommon CMake <https://www.xmos.com/file/xcommon-cmake-documentation/?version=latest>`_
build system. It compiles and links Unity into an `xcore` application and can optionally generate
a test runner for each build configuration.

Third-party source
==================

This library uses the Unity test framework, unmodified, included as a Git submodule in
``third_party/Unity``.

- Upstream: https://github.com/ThrowTheSwitch/Unity
- Upstream version: v2.6.1

Unity is distributed under the MIT licence, see ``third_party/Unity/LICENSE.txt``.

Accessing the library software
==============================

There are two ways to access the software in this library:

- Download the latest release ZIP package from the `XMOS Website <https://www.xmos.com/libraries/>`_ and extract it to a chosen sandbox directory.
- Clone the Git repository from `XMOS GitHub <https://github.com/xmos>`_.

The ZIP file download is the recommended option for most users, as it is a quick way to get started with the library.

*****
Usage
*****

To use this library in an application include ``lib_unity`` in the application's
``APP_DEPENDENT_MODULES`` list in `CMakeLists.txt`, for example:

.. code-block:: cmake

    set(APP_DEPENDENT_MODULES "lib_unity")

.. note:: Dependent modules should be pinned to release versions where possible, otherwise the
   latest commit on the `develop` branch will be used.  For further details on managing modules,
   pinning to a release version and other options, please see the page `xcommon-cmake Dependency Management <https://www.xmos.com/documentation/XM-015090-PC/html/doc/dependency_management.html>`_.

Tests are written with the Unity API, available via the ``unity.h`` header file, and optionally
the Unity Fixture API, available via ``unity_fixture.h``:

.. code-block:: C

    #include "unity.h"
    #include "unity_fixture.h"

Configuration
=============

The following CMake options can be set in the application's ``CMakeLists.txt`` before
``XMOS_REGISTER_APP()``:

.. list-table::
   :header-rows: 1
   :widths: 30 15 55

   * - Option
     - Default
     - Description
   * - ``LIB_UNITY_USE_FIXTURE``
     - ``ON``
     - Include the Unity Fixture extras (``unity_fixture.h``).
   * - ``LIB_UNITY_USE_MEMORY``
     - ``ON``
     - Include the Unity Memory extras.
   * - ``LIB_UNITY_AUTO_TEST_RUNNER``
     - ``OFF``
     - Generate a test runner for each build configuration. Each configuration must have exactly
       one source file named ``test_*``. Requires Ruby.

Known issues
============

UnityTestRunner calls each test through a function pointer, so the linker's stack calculation
does not include the tests' stack usage. Tests with large stacks or in multi-threaded applications
may overflow their stack.

********************
Example applications
********************

Two examples are provided in the ``examples`` directory:

- ``basic``: a test group and a test runner written with the Unity Fixture API.
- ``uut_and_tests``: a unit under test with one build configuration per test file, using
  ``LIB_UNITY_AUTO_TEST_RUNNER`` to generate the test runners.

The ``basic`` test file (``examples/basic/src/test_basic.c``):

.. literalinclude:: ../../examples/basic/src/test_basic.c
    :language: c
    :start-after: #include "unity.h"

And its test runner (``examples/basic/src/main.c``):

.. literalinclude:: ../../examples/basic/src/main.c
    :language: c
    :start-after: #include "unity_fixture.h"

Building the example
====================

This section assumes that the `XMOS XTC Tools <https://www.xmos.com/software-tools/>`_ have been
downloaded and installed. The required version is specified in the accompanying ``README``.

Installation instructions can be found `here <https://xmos.com/xtc-install-guide>`_.

Special attention should be paid to the section on
`Installation of Required Third-Party Tools <https://www.xmos.com/documentation/XM-014363-PC/html/installation/install-configure/install-tools/install_prerequisites.html>`_.

To configure the build, the following commands should be run from an XTC command prompt:

.. code-block:: console

    cd lib_unity/examples/basic
    cmake -G "Unix Makefiles" -B build

If any dependencies are missing they will be retrieved automatically during this step.

The application binaries should then be built using ``xmake``:

.. code-block:: console

    xmake -j -C build

The binary ``test_basic.xe`` will be generated in the ``bin`` directory of the ``basic`` example.

Running the example
===================

From an XTC command prompt, the following command should be run from the ``examples/basic``
directory to run the tests on the simulator:

.. code-block:: console

    xsim bin/test_basic.xe

Or on hardware:

.. code-block:: console

    xrun --io bin/test_basic.xe

A passing test run produces:

.. code-block:: console

    3 Tests 0 Failures 0 Ignored
    OK
