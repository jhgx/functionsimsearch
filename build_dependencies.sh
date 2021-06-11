#!/bin/bash

set -o errexit

source_dir=$(pwd)

echo "WARNING: You will need GCC 7 or newer, GCC 6 does not implement C++17 yet!"

# Install gtest and gflags. It's a bit fidgety, but works:
sudo apt-get install -y wget cmake sudo libgtest-dev libgflags-dev libz-dev libelf-dev cmake g++ python3-pip
sudo apt-get install -y libboost-system-dev libboost-thread-dev libboost-date-time-dev

# Required for the training data generation python script.
pip3 install numpy absl-py

# Build the C++ libraries.
cd /usr/src/gtest
sudo cmake ./CMakeLists.txt
sudo make
sudo cp *.a /usr/lib

# Now get and the other dependencies
cd $source_dir
mkdir third_party
cd third_party

# Download PicoSHA.
git clone https://github.com/okdshin/PicoSHA2.git

# Build C++ JSON library.
mkdir json
mkdir json/src
cd json/src
wget https://github.com/nlohmann/json/releases/download/v3.1.2/json.hpp
cd ../..

# Build PE-Parse.
git clone https://github.com/trailofbits/pe-parse.git
cd pe-parse
git checkout 78869e53372424a1e46ff1996be6a1e136688719  # functionsimsearch doesn't work with the current pe-parse version
sed -i -e 's/-Wno-strict-overflow/-Wno-strict-overflow -Wno-ignored-qualifiers/g' ./cmake/compilation_flags.cmake
cmake ./CMakeLists.txt
make -j
cd ..

# Build SPII.
git clone https://github.com/PetterS/spii.git
cd spii
cmake ./CMakeLists.txt
make -j
sudo make install
cd ..

# Build Dyninst
wget https://github.com/dyninst/dyninst/archive/v9.3.2.tar.gz
tar xvf ./v9.3.2.tar.gz
cd dyninst-9.3.2
cmake ./CMakeLists.txt
# Need to limit parallelism because 8-core DynInst builds exhaust 30 Gigs of
# RAM on my test systems.
make -j 4
sudo make install
sudo ldconfig
cd ..
