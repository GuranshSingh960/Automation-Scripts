#!/bin/bash
# Threshold percentage
THRESHOLD=${1:-80}

# Log file path
LOG_FILE="/var/log/disk_alert.log"

# current date and time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Get root (/) usage percentage without the % symbol
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

# Hostname for identification
HOSTNAME=$(hostname)

# Email address to send alerts
ADMIN_EMAIL="gs477816@gmail.com"  

# Check if usage exceeds threshold
if [ "$USAGE" -ge "$THRESHOLD" ]; then
    SUBJECT="Disk Alert: Root partition usage is ${USAGE}% on $HOSTNAME"
    MESSAGE="ALERT: Root partition (/) usage has reached ${USAGE}%.
Threshold: ${THRESHOLD}%
Host: $HOSTNAME
Time: $TIMESTAMP"
    
    echo "$MESSAGE" | mail -s "$SUBJECT" "$ADMIN_EMAIL"
    echo "$TIMESTAMP - Usage: ${USAGE}% - ALERT sent to $ADMIN_EMAIL" >> "$LOG_FILE"
else
    echo "$TIMESTAMP - Usage: ${USAGE}% - OK" >> "$LOG_FILE"
fi
