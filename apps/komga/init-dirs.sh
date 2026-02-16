#!/bin/sh
# Create volume dirs so they are owned by the current user (not root).
# Run this once before the first 'docker compose up'. Ensure USER_ID/GROUP_ID
# in .env match your user (e.g. id -u and id -g); default 1000:1000.
set -e
mkdir -p config data
echo "Created config and data. If the app has permission errors, run:"
echo "  sudo chown -R \${USER_ID:-1000}:\${GROUP_ID:-1000} config data"
