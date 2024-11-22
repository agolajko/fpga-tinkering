
#include <SoftwareSerial.h>

// Create software serial objects
SoftwareSerial receiveSerial(2, 4); // RX on 2, TX on 4
void setup()
{
    // USB serial for debugging
    Serial.begin(9600);
    // Initialize software serial ports
    receiveSerial.begin(9600);
}

void loop()
{

    if (Serial.available())
    {
        int received_from_pc = Serial.read();
        receiveSerial.write(received_from_pc);
        int received_from_fpga = receiveSerial.read();

        Serial.write(received_from_fpga); // forward each character to USB Serial
    }

    //------

    // if (Serial.available())
    // {
    //     int c = Serial.read();
    //     // receiveSerial.write(c); // echo back to sender
    //     Serial.write(c); // forward each character to USB Serial
    // }

    //-------
}