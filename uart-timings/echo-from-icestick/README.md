# Timing the return trip sent from the Icestick to the Arduino

## Steps

1. Compile and upload the `icestick-simpler.v` code
2. Compile and upload the Arduino code
3. Connect to serial port to start timing test: `screen /dev/tty.usbmodem1301 9600`
4. Run the Python `uart-serial.py` code to get an average for the return trips