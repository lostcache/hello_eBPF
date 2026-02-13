#!/usr/bin/env python3
import sys
import os

def generate(filename, target_size_mb):
    target_bytes = int(target_size_mb * 1024 * 1024)
    chunk_size = 1024 * 1024 # 1MB buffer
    
    # Pattern definition
    # We want a known number of Alphas.
    # Let's put one "Alpha" every 4096 bytes (4KB).
    # 4KB is a common page size, good for checking alignment issues too.
    # 4096 - 5 = 4091 padding bytes.
    
    padding_len = 4096 - 5
    block = (b"x" * padding_len) + b"Alpha" # 4096 bytes
    
    count = 0
    written = 0
    
    print(f"Generating {filename} with target size {target_size_mb} MB...")
    
    with open(filename, "wb") as f:
        while written < target_bytes:
            # How many 4KB blocks fit in our 1MB write buffer?
            # 1MB / 4KB = 256 blocks.
            blocks_per_chunk = 256
            
            # Check if we are near the end
            remaining_bytes = target_bytes - written
            if remaining_bytes < (blocks_per_chunk * 4096):
                # Calculate remaining blocks
                blocks_to_write = remaining_bytes // 4096
                remainder_padding = remaining_bytes % 4096
                
                if blocks_to_write > 0:
                    f.write(block * blocks_to_write)
                    written += blocks_to_write * 4096
                    count += blocks_to_write
                
                if remainder_padding > 0:
                    f.write(b"x" * remainder_padding)
                    written += remainder_padding
                
                break
            else:
                # Write full chunk
                f.write(block * blocks_per_chunk)
                written += blocks_per_chunk * 4096
                count += blocks_per_chunk

    print(f"Done. Size: {written} bytes. Expected 'Alpha' count: {count}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 generate_data.py <filename> <size_in_mb>")
        sys.exit(1)
    
    generate(sys.argv[1], float(sys.argv[2]))
