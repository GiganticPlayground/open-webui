#!/usr/bin/env bash

# Change into the backend directory
cd ./backend || { echo "Failed to change directory to ./backend"; exit 1; }

# Check if the virtual environment directory exists
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Please run _local_build.sh'."
    cd ..
    exit 1
fi

# Activate the virtual environment
source venv/bin/activate || { echo "Failed to activate virtual environment"; exit 1; }

# Run the start.sh script
./start.sh || { echo "Failed to execute start.sh"; exit 1; }

