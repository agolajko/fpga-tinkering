#include <SoftwareSerial.h>

// Create software serial object on pin 2
SoftwareSerial mySerial(2, 3); // RX, TX (we won't use TX pin but need to specify it)

// Constants
const int LED_PIN = LED_BUILTIN;       // Usually pin 13
const unsigned long LED_TIMEOUT = 100; // LED stays on for 100ms after receiving data

// Variables
unsigned long lastReceiveTime = 0;

void setup()
{
  // Initialize hardware serial (USB) for debugging
  Serial.begin(9600);

  // Initialize software serial for receiving data
  mySerial.begin(9600);

  // Set up LED pin
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
}

void loop()
{
  // If data is available from software serial
  if (mySerial.available())
  {
    // Read it and send to USB serial
    char c = mySerial.read();
    Serial.write(c);

    // Turn on LED and record the time
    digitalWrite(LED_PIN, HIGH);
    lastReceiveTime = millis();
  }

  // Turn off LED if timeout has elapsed since last receive
  if (millis() - lastReceiveTime > LED_TIMEOUT)
  {
    digitalWrite(LED_PIN, LOW);
  }
}