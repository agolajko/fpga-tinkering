import serial
import time
ser = serial.Serial('/dev/tty.usbserial-1301',
                    baudrate=9600,
                    bytesize=8,
                    parity='N',
                    stopbits=1)
# ser.write(b'P')

for i in range(10):
    print(ser.read())  # Should show what comes back
    time.sleep(2)


# ser.write(b'B')
# print(ser.read())

# ser.write(b'C')
# print(ser.read())
