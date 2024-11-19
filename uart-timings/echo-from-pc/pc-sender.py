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

for i in range(20):

    send_time = time.time()
    receive_time = 0
    ser.write(b'7')

    # time.sleep(0.1)

    for j in range(100000):
        if ser.in_waiting > 0:
            receive_time = time.time()
            message = ser.read(1)
            ser.reset_input_buffer()
            print(f"Received byte: {message, i}")
            break

        time.sleep(0.00001)

    return_waits.append(j)
    return_times.append(receive_time - send_time)

ser.close()

print("Done")
print(return_times)
print(return_waits)

net_times = []

for k in range(20):
    if return_times[k] > 0 and return_waits[k] < 9999:
        net_times.append(return_times[k]*1000 - return_waits[k]*0.1)

print("Net times: ")
print(net_times)
avg_times = np.mean(net_times)
print("Average time: ")
print(avg_times)
