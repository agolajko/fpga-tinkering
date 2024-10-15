# GTKWave Verilog Testing

'Hello World' of Verilog testing: setup for testing with GTKWave.

## Files

- `counter.v`: A 4-bit counter module
- `counter_tb.v`: Testbench for the counter module

## Counter Module

The `counter.v` file implements a simple 4-bit counter with the following features:

- Inputs: `clk` (clock), `reset`
- Output: `count` (4-bit register)
- Functionality: Increments the count on each clock cycle, resets to 0 when reset is high

## Testbench

`counter_tb.v` testbench for the counter module:

- Generates a 100MHz clock signal
- Applies reset at specific intervals
- Runs the simulation for 540ns
- Generates a VCD file for waveform viewing in GTKWave

## Usage

1. Compile the Verilog files and simulate:
   1. `apio build`
   2. `apio sim`