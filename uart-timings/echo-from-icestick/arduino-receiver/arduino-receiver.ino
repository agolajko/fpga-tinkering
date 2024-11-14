
#include <SoftwareSerial.h>

// Create software serial objects
SoftwareSerial receiveSerial(2, 4); // RX on 2, TX on 4

// Constants
const int LED_PIN = LED_BUILTIN;
const unsigned long LED_TIMEOUT = 100; // LED stays on for receiving data

// Variables
unsigned long lastReceiveTime = 0;

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
    if (receiveSerial.available())
    {
        char c = receiveSerial.read();
        receiveSerial.write(c); // echo back to sender
        Serial.write(c);        // forward each character to USB Serial

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