# Timing the Icestick Echo signal sent from the computer via the Arduino

## Pieces of code
  - Python code: send and time receipt of signal
  - Arduino code: directly relay incoming signal to SoftwareSerial
  - FPGA code: Echo

## Results

Timing the following loop: PC -> Arduino -> FPGA -> Arduino -> PC

Average time over 100 runs was 7.1 ms