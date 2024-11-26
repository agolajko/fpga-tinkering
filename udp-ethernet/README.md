# Ethernet hat on Arduino

## Connect to computer

IP addresses need to be allocated by a DHCP server, this can be a router or your computer. It's simpler to use the router.

Two options:
1. Connecting both the computer and the Arduino to a router works great. The router will sort out the IP address allocations
2. Connect the Arduino directly to the the computer via the Ethernet cable. Your computer needs to have an Auto-MDIX feature for this to work (most Apple PCs have this). Further you  need to configure a local network by:
   1. Open Network in System Settings
   2. Add a new network with the "+" 
   3. Choose "Ethernet" as the interface type
   4. Click "Add"
   5. Select the Ethernet interface from the list
   6. Set a manual IP:
      1. Click on the dropdown next to "Configure IPv4" or "IP Address"
      2. Select "Manually" and enter these settings:
      3. IP Address: 169.254.1.178
      4. Subnet Mask: 255.255.0.0
      5. Leave Router/Gateway blank
   7.  Click "Apply" or "OK" to save the settings