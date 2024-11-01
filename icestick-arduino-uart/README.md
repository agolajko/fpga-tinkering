# UART between the Icestick and Elegoo Uno R3


## Setting up Arduino

1. Install [Arduino CLI](https://arduino.github.io/arduino-cli/1.0/installation/) with brew
2. Plug in board and find it: `arduino-cli board list`
3. 
4. Compile and upload the Arduino Code
   ```
   arduino-cli compile --fqbn arduino:avr:uno --config-file arduino-cli.yaml --build-path build 

   arduino-cli upload -p /dev/tty.usbmodem1301 --fqbn arduino:avr:uno --config-file arduino-cli.yaml
   ```