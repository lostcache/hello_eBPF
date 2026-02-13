#!/bin/bash
set -e

# Default SPDK directory relative to project root
SPDK_DIR=${SPDK_DIR:-./spdk}
RPC_PY="$SPDK_DIR/scripts/rpc.py"

# Check if RPC script exists
if [ ! -f "$RPC_PY" ]; then
    echo "Error: SPDK RPC script not found at $RPC_PY"
    exit 1
fi

echo "Using SPDK at: $SPDK_DIR"

# 1. Setup Hugepages (Requires sudo)
echo "Setting up hugepages..."
sudo "$SPDK_DIR/scripts/setup.sh"

# 2. Start Target
if pgrep -x "nvmf_tgt" > /dev/null; then
    echo "nvmf_tgt is already running."
else
    echo "Starting nvmf_tgt..."
    # Run in background, redirect output to log
    sudo "$SPDK_DIR/build/bin/nvmf_tgt" --json <(echo "{}") > spdk_tgt.log 2>&1 &
    TARGET_PID=$!
    echo "Started nvmf_tgt with PID $TARGET_PID. Waiting for startup..."
    sleep 3
fi

# 3. Configure Target via RPC

# Create Malloc Bdev (Ramdrive)
# Size: 64MB, Block Size: 512
# We check if it exists first to avoid errors on re-run
if ! sudo "$RPC_PY" bdev_get_bdevs -b Malloc0 > /dev/null 2>&1; then
    echo "Creating 64MB Malloc Bdev 'Malloc0'..."
    sudo "$RPC_PY" bdev_malloc_create -b Malloc0 64 512
else
    echo "Malloc0 already exists."
fi

# Create NVMe-oF Subsystem
SUBSYS_NQN="nqn.2016-06.io.spdk:cnode1"
if ! sudo "$RPC_PY" nvmf_get_subsystems | grep -q "$SUBSYS_NQN"; then
    echo "Creating Subsystem $SUBSYS_NQN..."
    sudo "$RPC_PY" nvmf_create_subsystem "$SUBSYS_NQN" -a -s SPDK00000000000001 -d SPDK_Controller1
else
    echo "Subsystem already exists."
fi

# Add Namespace (Bdev) to Subsystem
# We assume NSID 1. Check if attached?
# Just try adding it, ignore if fails (or check). 
# Safer: Just add it. If it fails, it might be already added.
echo "Adding Malloc0 to Subsystem..."
sudo "$RPC_PY" nvmf_subsystem_add_ns "$SUBSYS_NQN" Malloc0 || echo "Namespace add failed (might be already added)"

# Create Transport Listener
# TCP, 127.0.0.1:4420
echo "Adding TCP Listener at 127.0.0.1:4420..."
# Ensure TCP transport exists? older SPDK versions need `nvmf_create_transport`. 
# Modern ones create it automatically? Better to create explicit.
sudo "$RPC_PY" nvmf_create_transport -t TCP -u 16384 -m 8 -c 8192 || echo "Transport create failed (might exist)"

sudo "$RPC_PY" nvmf_subsystem_add_listener "$SUBSYS_NQN" -t tcp -a 127.0.0.1 -s 4420 || echo "Listener add failed (might exist)"

echo "---------------------------------------------------"
echo "SPDK NVMe-oF Target is READY."
echo "Subsystem NQN: $SUBSYS_NQN"
echo "Address:       127.0.0.1:4420"
echo "---------------------------------------------------"
