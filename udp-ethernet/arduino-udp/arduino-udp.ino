/*
 UDPSendReceiveString

 This sketch receives UDP message strings, prints them to the serial port
 and sends an "acknowledge" string back to the sender

 A Processing sketch is included at the end of file that can be used to send
 and receive messages for testing with a computer.

 created 21 Aug 2010
 by Michael Margolis

 This code is in the public domain.
 */

#include <Ethernet.h>
#include <EthernetUdp.h>

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network:
// byte mac[] = {
//   0x02, // Local bit set (02 indicates locally administered)
//   0x00,
//   0x00,
//   0x00,
//   0x00,
//   0x01
// };

// IPAddress ip(192, 168, 1, 177);

byte mac[] = {0xDE, 0xAD, 0xBE, 0xEF, 0xFE, 0xED}; // MAC address can stay the same
byte ip[] = {169, 254, 1, 177};                    // Use link-local addressing
byte subnet[] = {255, 255, 0, 0};

unsigned int localPort = 8888; // local port to listen on

// buffers for receiving and sending data
char packetBuffer[UDP_TX_PACKET_MAX_SIZE]; // buffer to hold incoming packet,
char ReplyBuffer[] = "acknowledged";       // a string to send back

// An EthernetUDP instance to let us send and receive packets over UDP
EthernetUDP Udp;

void setup()
{
    // You can use Ethernet.init(pin) to configure the CS pin
    Ethernet.init(10); // Most Arduino shields
    // Ethernet.init(5);   // MKR ETH Shield
    // Ethernet.init(0);   // Teensy 2.0
    // Ethernet.init(20);  // Teensy++ 2.0
    // Ethernet.init(15);  // ESP8266 with Adafruit FeatherWing Ethernet
    // Ethernet.init(33);  // ESP32 with Adafruit FeatherWing Ethernet

    // start the Ethernet
    Ethernet.begin(mac, ip, subnet);

    // Open serial communications and wait for port to open:
    Serial.begin(9600);
    while (!Serial)
    {
        ; // wait for serial port to connect. Needed for native USB port only
    }

    // Check for Ethernet hardware present
    if (Ethernet.hardwareStatus() == EthernetNoHardware)
    {
        Serial.println("Ethernet shield was not found.  Sorry, can't run without hardware. :(");
        while (true)
        {
            delay(1); // do nothing, no point running without Ethernet hardware
        }
    }
    if (Ethernet.linkStatus() == LinkOFF)
    {
        Serial.println("Ethernet cable is not connected.");
    }

    // start UDP
    Udp.begin(localPort);
}

void loop()
{
    // if there's data available, read a packet
    int packetSize = Udp.parsePacket();
    if (packetSize)
    {
        Serial.print("Received packet of size ");
        Serial.println(packetSize);
        Serial.print("From ");
        IPAddress remote = Udp.remoteIP();
        for (int i = 0; i < 4; i++)
        {
            Serial.print(remote[i], DEC);
            if (i < 3)
            {
                Serial.print(".");
            }
        }
        Serial.print(", port ");
        Serial.println(Udp.remotePort());

        // read the packet into packetBuffer
        Udp.read(packetBuffer, UDP_TX_PACKET_MAX_SIZE);
        Serial.println("Contents:");
        Serial.println(packetBuffer);

        // send a reply to the IP address and port that sent us the packet we received
        Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
        Udp.write(ReplyBuffer);
        Udp.endPacket();
    }
    delay(10);
}
