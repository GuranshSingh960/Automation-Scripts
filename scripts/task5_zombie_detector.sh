#!/bin/bash
# Log file path
LOG_FILE="/var/log/zombie_processes.log"

# Get current timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Find zombie processes
ZOMBIES=$(ps -eo pid,ppid,state,cmd | awk '$3 ~ /Z/')

# Create log directory if needed
mkdir -p "$(dirname "$LOG_FILE")"

# If zombies found
if [ -n "$ZOMBIES" ]; then
    echo "$TIMESTAMP - Zombie processes detected:" >> "$LOG_FILE"
    echo "$ZOMBIES" >> "$LOG_FILE"
    echo "" >> "$LOG_FILE"
else
    echo "$TIMESTAMP - No zombie processes found." >> "$LOG_FILE"
fi

