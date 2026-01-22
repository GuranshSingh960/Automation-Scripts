#!/bin/bash
# source and archive directories 
SOURCE_DIR="${1:-/home/$USER}"
ARCHIVE_DIR="${2:-/home/$USER/old_file_archive}"
LOG_FILE="/var/log/file_archiver.log"

# Timestamp
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Create archive and log directories if they dont exist
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Find and move files older than 30 days
find "$SOURCE_DIR" -type f -mtime +30 | while read -r FILE; do
    REL_PATH="${FILE#$SOURCE_DIR/}"
    DEST_PATH="$ARCHIVE_DIR/$REL_PATH"
    DEST_DIR="$(dirname "$DEST_PATH")"
    
    mkdir -p "$DEST_DIR"
    mv "$FILE" "$DEST_PATH"

    echo "$TIMESTAMP - Archived: $FILE --> $DEST_PATH" >> "$LOG_FILE"
done

