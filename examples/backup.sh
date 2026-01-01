#!/bin/bash
# Example: Backup script with verification
# Demonstrates hashit, copycat, manifest, and checksums

set -e

BACKUP_ID=$(randomize 10000 99999)
BACKUP_DIR="backups/$(date +%Y%m%d_%H%M%S)_$BACKUP_ID"
SOURCE_DIR="data"

out "Starting backup process..."

# Ensure backup directory exists
touchup "$BACKUP_DIR/"

# Verify source files exist
out "Verifying source files..."
manifest "$SOURCE_DIR/" || {
  out "Source directory not found" 2
  exit 1
}

# Compute checksums of source files
out "Computing checksums..."
hashit --algorithm sha256 "$SOURCE_DIR"/*.txt > "$BACKUP_DIR/source_checksums.txt" 2>/dev/null || true

# Copy files
out "Copying files..."
for file in "$SOURCE_DIR"/*; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    copycat "$file" "$BACKUP_DIR/$filename" || {
      out "Failed to copy $filename" 2
      exit 1
    }
  fi
done

# Verify backup
out "Verifying backup..."
manifest "$BACKUP_DIR/" || {
  out "Backup verification failed" 2
  exit 1
}

# Compute checksums of backup files
out "Computing backup checksums..."
hashit --algorithm sha256 "$BACKUP_DIR"/*.txt > "$BACKUP_DIR/backup_checksums.txt" 2>/dev/null || true

# Compare checksums (simple verification)
if [ -f "$BACKUP_DIR/source_checksums.txt" ] && [ -f "$BACKUP_DIR/backup_checksums.txt" ]; then
  if diff -q "$BACKUP_DIR/source_checksums.txt" "$BACKUP_DIR/backup_checksums.txt" > /dev/null 2>&1; then
    out "Checksums match - backup verified!" 1
  else
    out "Checksum mismatch - backup may be corrupted" 2
    exit 1
  fi
fi

# Truncate old backup logs
out "Cleaning old backup logs..."
truncate "backups/backup.log" --backup 2>/dev/null || true

out "Backup completed: $BACKUP_DIR" 1

