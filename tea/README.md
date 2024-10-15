# Tiny Encryption Algorithm (TEA) in Verilog
Verilog implementation of the [Tiny Encryption Algorithm](https://en.wikipedia.org/wiki/Tiny_Encryption_Algorithm) designed for the constraints of a [Lattice Icestick FPGA](https://www.latticesemi.com/icestick).

## Overview

This implementation is meant to be used as a learning project for Verilog and basic encryption concepts. It goes without saying that this is not a secure encryption library and should not be used in any security-sensitive applications.

## Repository Contents

- `tea.v`: Main module
- `tea_encrypt.v`: Module for TEA encryption
- `tea_decrypt.v`: Module for TEA decryption
- `tea_tb.v`: Testbench for verifying the TEA implementation
- `tea-reference-code.c`: C code from Wikipedia
- `tea.pcf`: Pinout file

## TEA Algorithm

TEA operates on 64-bit blocks using a 128-bit key. It performs 32 rounds of simple operations, including XORs, additions, and bitshifts.

## Testing

The `tea_tb.v` file provides a basic testbench for verifying the correctness of the TEA implementation. 

## Running it

Simulate it with Apio and GTKWave
- `apio build`
- `apio sim`

The value to be encrypted as well as the key are hardcoded as I haven't got around to implementing an interface to the FPGA. Hence the most visible way of running the code is in simulation.


