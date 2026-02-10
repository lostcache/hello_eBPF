#!/bin/bash
cd examples/c
make hello
if [ $? -eq 0 ]; then
  echo "Build successful"
  exit 0
else
  echo "Build failed"
  exit 1
fi
