#!/bin/bash
set -e

# Target Info
NQN="nqn.2016-06.io.spdk:cnode1"
ADDR="127.0.0.1"
PORT="4420"

echo "Loading kernel modules..."
sudo modprobe nvme
sudo modprobe nvme-tcp

echo "Connecting to NVMe Target at $ADDR:$PORT..."
sudo nvme connect -t tcp -n "$NQN" -a "$ADDR" -s "$PORT"

echo "Connected. Checking devices..."
sudo nvme list
