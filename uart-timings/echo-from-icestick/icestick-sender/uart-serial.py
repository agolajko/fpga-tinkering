import serial
import time

ser = serial.Serial('/dev/tty.usbserial-1201',
                    baudrate=9600,
                    bytesize=8,
                    parity='N',
                    stopbits=1)

# Constants matching Verilog
CLK_FREQ = 12_000_000
NUM_SAMPLES = 10

# Initialize lists
unordered_list = [0] * 4
ordered_list = [0] * 4

# Read 4 bytes
for i in range(4):
    byte = ord(ser.read())  # Convert bytes to integer
    print(f"Received byte: {bin(byte)}")  # Print in binary for debugging
    unordered_list[i] = byte

# Order bytes based on first two bits
for i in range(4):
    first_two_bits = unordered_list[i] & 0b11000000
    position = first_two_bits >> 6  # Shift right to get position value (0-3)
    # Keep only lower 6 bits
    ordered_list[position] = unordered_list[i] & 0b00111111

# Combine the 6-bit values into final 24-bit number
total_cycles = (ordered_list[0] << 18) | (ordered_list[1] << 12) | (
    ordered_list[2] << 6) | ordered_list[3]

print(f"Total cycles: {total_cycles}")

# Convert cycles to milliseconds using the same formula as Verilog
# (total_cycles / NUM_SAMPLES * 1000) / CLK_FREQ
time_ms = (total_cycles / NUM_SAMPLES * 1000) / CLK_FREQ

print(f"Time in milliseconds: {time_ms:.3f} ms")
print(f"Time in seconds: {time_ms/1000:.3f} s")
