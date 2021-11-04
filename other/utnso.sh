#!/bin/bash -x

# CSpec
git clone https://github.com/mumuki/cspec.git
make -C cspec
sudo make install -C cspec
rm -rf cspec

# Commons
git clone https://github.com/sisoputnfrba/so-commons-library.git
make -C so-commons-library debug
sudo make install -C so-commons-library
rm -rf so-commons-library
