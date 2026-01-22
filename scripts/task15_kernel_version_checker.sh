#!/bin/bash
# Log file
LOG_FILE="/var/log/kernel_version_check.log"
mkdir -p "$(dirname "$LOG_FILE")"

# Email for alert
ADMIN_EMAIL="gs477816@gmail.com"

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Get current running kernel version
CURRENT_KERNEL=$(uname -r)

# Get latest available kernel 
LATEST_KERNEL=$(apt list --upgradable 2>/dev/null | grep -E "linux-image-[0-9]" | awk -F'/' '{print $1}' | sort -V | tail -1)

# If no upgrade found, log it
if [ -z "$LATEST_KERNEL" ]; then
    echo "$TIMESTAMP - No kernel updates available. Current: $CURRENT_KERNEL" >> "$LOG_FILE"
    exit 0
fi

# Extract latest version number
LATEST_VERSION=$(echo "$LATEST_KERNEL" | sed 's/linux-image-//')

# Compare current kernel with latest
if [[ "$CURRENT_KERNEL" < "$LATEST_VERSION" ]]; then
    SUBJECT="Kernel Update Available on $(hostname)"
    MESSAGE="Current kernel version: $CURRENT_KERNEL
Available kernel version: $LATEST_VERSION
Host: $(hostname)
Time: $TIMESTAMP

Please consider updating the kernel."

    echo "$TIMESTAMP - ALERT: New kernel available - $LATEST_VERSION" >> "$LOG_FILE"
    echo -e "$MESSAGE" | mail -s "$SUBJECT" "$ADMIN_EMAIL"
else
    echo "$TIMESTAMP - Kernel is up-to-date. Current: $CURRENT_KERNEL, Latest: $LATEST_VERSION" >> "$LOG_FILE"
fi

