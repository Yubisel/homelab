#!/bin/sh
# Create volume dirs so they are owned by the current user (not root).
# Run this once before the first 'docker compose up'. Ensure APP_USER_ID/APP_GROUP_ID
# in .env match your user (e.g. id -u and id -g); default 1000:1000.
set -e
mkdir -p data books bookdrop mariadb/config
echo "Created data, books, bookdrop, mariadb/config. If the app still gets AccessDeniedException, run:"
echo "  sudo chown -R \${APP_USER_ID:-1000}:\${APP_GROUP_ID:-1000} data books bookdrop mariadb/config"
