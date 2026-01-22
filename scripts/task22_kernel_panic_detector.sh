#!/bin/bash
# Log file for storing panic events
LOG_FILE="/var/log/kernel_panic_monitor.log"

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Notification email 
ADMIN_EMAIL="gs477816@gmail.com"

# Panic search keywords
KEYWORDS="kernel panic|Oops|BUG:|stack trace"

# Temporary file to store matched log lines
TMP_FILE="/tmp/panic_scan_result.txt"

# Create log directory if needed
mkdir -p "$(dirname "$LOG_FILE")"

# Search recent logs for panic-related messages
journalctl -k -S "-1h" | grep -Ei "$KEYWORDS" > "$TMP_FILE"

# If any lines matched, log and notify
if [ -s "$TMP_FILE" ]; then
    echo "$TIMESTAMP - Kernel panic or related issue detected!" >> "$LOG_FILE"
    cat "$TMP_FILE" >> "$LOG_FILE"
    echo -e "Subject: KERNEL PANIC DETECTED on $(hostname)\n\nKernel panic messages found:\n\n$(cat "$TMP_FILE")" | sendmail "$ADMIN_EMAIL"
    echo "" >> "$LOG_FILE"
else
    echo "$TIMESTAMP - No kernel panic detected." >> "$LOG_FILE"
fi

# Clean up
rm -f "$TMP_FILE"

