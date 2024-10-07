#!/bin/bash
# Compiles and installs yosys/nextpnr for ICE40-based FPGAs on macOS
# Bruno Levy, Nov. 2022 (modified for macOS)

# Ensure Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew is not installed. Please install it first: https://brew.sh/"
    exit 1
fi

# Create build directory
mkdir -p /tmp/BUILD
cd /tmp/BUILD

echo "Installing YOSYS dependencies"
brew install bison flex readline gawk tcl-tk libffi git \
    graphviz pkg-config python boost zlib

echo "Installing YOSYS"
git clone https://github.com/YosysHQ/yosys.git
(cd yosys && make config-clang && make -j 4 && sudo make install)

echo "Installing ICARUS/IVERILOG and VERILATOR"
brew install icarus-verilog verilator

echo "Installing ICESTORM dependencies"
brew install libftdi eigen boost-python3 qt@5 cmake

echo "Installing ICESTORM"
git clone https://github.com/YosysHQ/icestorm.git
(cd icestorm && make -j 4 && sudo make install)

echo "Installing NEXTPNR"
git clone --recursive https://github.com/YosysHQ/nextpnr.git
(cd nextpnr && cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local . && make -j 4 && make install)

echo "Installation complete!"

# Note: macOS doesn't use udev rules, so we skip that part

echo "You may need to add /usr/local/bin to your PATH if it's not already there."
echo "You can do this by adding the following line to your ~/.bash_profile or ~/.zshrc:"
echo "export PATH=/usr/local/bin:\$PATH"