# Timing echo signals between the Arduino and Icestick

The two files are used for timing:
1. `echo-from-arduino` uses the Arduino as the server, timing the FPGA return signal (the FPGA is the client)
2. `echo-from-icestick` uses the FPGA as the server, timing the Arduino return signal

## Results

1. `echo-from-arduino` 2.07 ms average time
2. `echo-from-icestick` 1.96 ms average time

