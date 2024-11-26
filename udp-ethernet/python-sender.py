import socket

# Create and bind socket to port 6000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', 6000))

# Send to Arduino
message = b"Hello Arduino3"
sock.sendto(message, ("169.254.1.177", 8888))
# sock.sendto(message, ("192.168.1.177", 8888))
print(f"Sent message: {message}")

# Optionally wait for reply (since we're bound to port 6000)
data, addr = sock.recvfrom(1024)
print(f"Received reply: {data.decode()} from {addr}")
