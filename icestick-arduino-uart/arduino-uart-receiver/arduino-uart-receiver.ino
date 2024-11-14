
#include <SoftwareSerial.h>

// Create software serial objects
SoftwareSerial receiveSerial(2, 4); // RX on 2, TX not used but specified

// Constants
const int LED_PIN = LED_BUILTIN;
const unsigned long LED_TIMEOUT = 100;    // LED stays on for receiving data
const unsigned long SEND_INTERVAL = 2000; // Send every 1 second

// Variables
unsigned long lastReceiveTime = 0;
unsigned long lastSendTime = 0;
unsigned long messageCount = 0;

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
  // Send message every SEND_INTERVAL
  if (millis() - lastSendTime >= SEND_INTERVAL)
  {
    receiveSerial.println("Message #" + String(messageCount++));
    lastSendTime = millis();
  }

  // Check for received data
  if (receiveSerial.available())
  {
    char c = receiveSerial.read();
    Serial.write(c); // forward each character to USB Serial

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