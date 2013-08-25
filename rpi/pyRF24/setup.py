# setup.py, file based on Golgauth's answer
# http://stackoverflow.com/questions/16993927/using-cython-to-link-python-to-a-shared-library
import os
import shutil

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

# clean previous build
for root, dirs, files in os.walk(".", topdown=False):
    for name in files:
        if (name.startswith("pyRF24") and not(name.endswith(".pyx") or name.endswith(".pxd"))):
            os.remove(os.path.join(root, name))
    for name in dirs:
        if (name == "build"):
            shutil.rmtree(name)

# build "pyRF24.so" python extension to be added to "PYTHONPATH" afterwards...
setup(
    cmdclass = {'build_ext': build_ext},
    ext_modules = [
    Extension("pyRF24", 
              sources=["pyRF24.pyx"],
              libraries=["librf24"],          # refers to installed "librf24.so"
              language="c++",
              extra_compile_args=["-I../librf24", "-fopenmp", "-O3"],
              extra_link_args=["-L./usr/local/lib"]
              )
    ]
)