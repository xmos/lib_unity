# Copyright 2021-2024 XMOS LIMITED.
# This Software is subject to the terms of the XMOS Public Licence: Version 1.
import pytest
import subprocess
from pathlib import Path

def pytest_configure():
    subprocess.run(["cmake", "-B", "build"], check=True)
    subprocess.run(["cmake", "--build", "build"], check=True)

def pytest_collect_file(parent, path):
    if path.ext == ".xe":
        return UnityTestSource.from_parent(parent, path=Path(path))

class UnityTestSource(pytest.File):
    def collect(self):
        yield UnityTestExecutable.from_parent(self, xe=self.path, name=self.path.stem)


class UnityTestExecutable(pytest.Item):
    def __init__(self, xe, **kwargs):
        super().__init__(**kwargs)
        self.xe=xe

    def runtest(self):
        proc = subprocess.run(["xsim", self.xe])
        if proc.returncode:
            raise UnityTestException

class UnityTestException(Exception):
    pass
