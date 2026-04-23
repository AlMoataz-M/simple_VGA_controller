import secrets

FILENAME = "data.mem"
LINES = 307200

with open(FILENAME, "w") as f:
    for _ in range(LINES):
        # Generates a random integer from 0 to 255
        byte = secrets.randbelow(256)
        
        # Format as 8-bit binary (use '02x' for hex)
        binary_str = format(byte, '08b')
        
        f.write(binary_str + "\n")

print(f"File {FILENAME} created with {LINES} lines.")