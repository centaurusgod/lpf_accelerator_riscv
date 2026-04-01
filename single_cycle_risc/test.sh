#!/bin/bash

# Check if argument is provided
if [ -z "$1" ]; then
    echo "Usage: ./test.sh <verilog_file.v>"
    exit 1
fi

# Input file
INPUT_FILE="$1"

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: File '$INPUT_FILE' not found."
    exit 1
fi

# Run the Python script
python3 runner.py -i "$INPUT_FILE"
