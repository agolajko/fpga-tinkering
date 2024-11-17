#include <SoftwareSerial.h>

const uint8_t NUM_TESTS = 100;     // Number of timing tests to run
const unsigned long TIMEOUT = 800; // Timeout in ms to wait for response

// Arrays to store our timing data
unsigned long sendTimes[NUM_TESTS];    // When each number was sent
unsigned long receiveTimes[NUM_TESTS]; // When each number was received
bool validTests[NUM_TESTS];            // Track which tests were successful
uint8_t currentTest = 0;               // Keep track of which test we're on
int validTestCount = 0;                // Count of valid tests completed

// Setup software serial
SoftwareSerial receiveSerial(2, 4); // RX on 2, TX on 4

void setup()
{
    // Start both Serial ports
    Serial.begin(9600);        // Main serial port for results
    receiveSerial.begin(9600); // Software serial port for testing

    // Wait for main serial to be ready
    while (!Serial)
    {
        ;
    }

    // Initialize all tests as invalid
    for (int i = 0; i < NUM_TESTS; i++)
    {
        validTests[i] = false;
    }

    Serial.println("Starting UART timing test...");
}

void loop()
{
    if (currentTest < NUM_TESTS)
    {
        // Clear any leftover data in receive buffer
        while (receiveSerial.available())
        {
            receiveSerial.read();
        }

        // Send the current test number
        sendTimes[currentTest] = millis();
        receiveSerial.print(7);

        // Wait for response with timeout
        unsigned long startWait = millis();
        while (!receiveSerial.available())
        {
            if (millis() - startWait > TIMEOUT)
            {
                Serial.print("Timeout on test ");
                Serial.println(currentTest);
                currentTest++;
                return;
            }
        }

        // Read response and record time
        char received = receiveSerial.read();
        receiveTimes[currentTest] = millis();

        // Verify we got the right number back
        if (received == 55) // ASCII 7
        {
            validTests[currentTest] = true;
            validTestCount++;

            // Print progress
            if (currentTest % 10 == 0)
            {
                Serial.print("Completed test ");
                Serial.print(currentTest);
                Serial.println("/100");
            }
        }
        else
        {
            Serial.print("Data mismatch on test ");
            Serial.print(currentTest);
            Serial.print(": Expected ");
            Serial.print("55");
            Serial.print(", Got ");
            Serial.println(received);
        }

        currentTest++;
        delay(100);
    }
    else if (currentTest == NUM_TESTS)
    {
        // All tests complete, calculate and display results
        unsigned long totalTime = 0;
        unsigned long minTime = 0xFFFFFFFF; // Maximum possible unsigned long value
        unsigned long maxTime = 0;

        // First find valid min time to initialize minTime
        for (int i = 0; i < NUM_TESTS; i++)
        {
            if (validTests[i])
            {
                unsigned long roundtrip = receiveTimes[i] - sendTimes[i];
                minTime = roundtrip;
                break;
            }
        }

        // Now calculate all statistics
        for (int i = 0; i < NUM_TESTS; i++)
        {
            if (validTests[i])
            {
                unsigned long roundtrip = receiveTimes[i] - sendTimes[i];
                totalTime += roundtrip;

                minTime = min(minTime, roundtrip);
                maxTime = max(maxTime, roundtrip);
            }
        }

        if (validTestCount > 0)
        {
            float avgTime = (float)totalTime / validTestCount;

            Serial.println("\nSummary:");
            Serial.print("Valid tests completed: ");
            Serial.print(validTestCount);
            Serial.print("/");
            Serial.println(NUM_TESTS);
            Serial.print("Average roundtrip time: ");
            Serial.print(avgTime);
            Serial.println(" ms");
            Serial.print("Minimum roundtrip time: ");
            Serial.print(minTime);
            Serial.println(" ms");
            Serial.print("Maximum roundtrip time: ");
            Serial.print(maxTime);
            Serial.println(" ms");
            Serial.print("Jitter (max-min): ");
            Serial.print(maxTime - minTime);
            Serial.println(" ms");
        }
        else
        {
            Serial.println("No valid tests completed!");
        }

        currentTest++;
    }
}