import serial
import time
import numpy as np

# ser = serial.Serial('/dev/tty.usbmodem1301',
ser = serial.Serial('/dev/cu.usbmodem1301',
                    baudrate=9600,
                    bytesize=8,
                    parity='N',
                    stopbits=1)
message = b''
message2 = b''

return_times = []
return_waits = []

for i in range(100):
    ser.send_break(duration=0.25)

    send_time = time.perf_counter()

    receive_time = 0
    ser.write(bytes([55]))

    for j in range(100000):
        if ser.in_waiting > 0:
            message = ser.read(1)
            receive_time = time.perf_counter()

            print(f"Received byte: {message, i}")

            break

        time.sleep(0.00001)

    return_waits.append(j)
    return_times.append(receive_time - send_time)


# ser.write(b'11')
ser.reset_input_buffer()

ser.reset_output_buffer()

ser.close()

print("Done")


print("Net times: ")
# print(net_times)
ms_times = np.array(return_times)*1000
mask = (ms_times >= 15) | (ms_times < 0)
filtered_times = ms_times[~mask]

print(filtered_times)
avg_times = np.mean(filtered_times)
print("Average time: ")
print(avg_times)
