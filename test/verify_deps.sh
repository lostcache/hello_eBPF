#!/bin/bash

# List of required binaries
BINARIES=("clang" "llvm-strip" "make" "bpftool" "pkg-config")

echo "Checking system dependencies..."

FAILED=0

for bin in "${BINARIES[@]}"; do
    if command -v "$bin" >/dev/null 2>&1; then
        echo "✅ $bin is installed: $($bin --version | head -n 1)"
    else
        echo "❌ $bin is NOT installed"
        FAILED=1
    fi
done

# Check for development headers using pkg-config
LIBRARIES=("libelf" "zlib")

for lib in "${LIBRARIES[@]}"; do
    if pkg-config --exists "$lib"; then
        echo "✅ $lib headers are installed"
    else
        echo "❌ $lib headers are NOT installed (pkg-config $lib failed)"
        FAILED=1
    fi
done

if [ $FAILED -eq 0 ]; then
    echo "All dependencies verified successfully."
    exit 0
else
    echo "Some dependencies are missing."
    exit 1
fi
