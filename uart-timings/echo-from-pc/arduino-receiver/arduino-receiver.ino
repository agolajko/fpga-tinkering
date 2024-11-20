
#include <SoftwareSerial.h>

// Create software serial objects
SoftwareSerial receiveSerial(2, 4); // RX on 2, TX on 4

// Constants
const int LED_PIN = LED_BUILTIN;
const unsigned long LED_TIMEOUT = 100; // LED stays on for receiving data

// Variables
unsigned long lastReceiveTime = 0;
const unsigned long TIMEOUT = 800;

void setup()
{
    // USB serial for debugging
    Serial.begin(9600);

    // Initialize software serial ports
    receiveSerial.begin(9600);

    // Set up LED pin
    pinMode(LED_PIN, OUTPUT);
    digitalWrite(LED_PIN, LOW);
}

void loop()
{
    // Check for received data
    while (Serial.available())
    {
        unsigned long startWait = millis();

        char received_from_pc = Serial.read();
        receiveSerial.print(received_from_pc); // echo to FPGA

        // unsigned long startWait = millis();

        // wait for response from FPGA
        // while (!receiveSerial.available())
        // {
        //     if (millis() - startWait > 0)
        //     {
        //         Serial.print(9);

        //         return;
        //     }
        // };

        char received_from_fpga = receiveSerial.read();

        // unsigned long elapsed = millis() - startWait;

        // uint8_t elapsed_int = (uint8_t)elapsed;

        Serial.print(received_from_fpga); // forward each character to USB Serial
        // Serial.print(received_from_pc); // forward each character to USB Serial

        // Turn on LED and record time
        digitalWrite(LED_PIN, HIGH);
        lastReceiveTime = millis();
    }

    // Turn off LED if timeout has elapsed since last receive
    if (millis() - lastReceiveTime > LED_TIMEOUT)
    {
        digitalWrite(LED_PIN, LOW);
    }
}