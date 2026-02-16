# Booklore

[Booklore](https://github.com/booklore-app/booklore) — book library manager. Runs the app and MariaDB; the app needs write access to `./data`, `./books`, and `./bookdrop`.

## First-time setup

1. Copy env and set passwords:
   ```bash
   cp .env.sample .env
   # Edit .env: set DB and app passwords, and TZ if needed.
   ```
2. Create volume directories **before** the first `docker compose up` so they are owned by your user (otherwise Docker creates them as root and the app gets `AccessDeniedException` on `/app/data/icons`):
   ```bash
   chmod +x init-dirs.sh && ./init-dirs.sh
   ```
   If the app still fails with permission errors, fix ownership (use your UID/GID if not 1000:1000):
   ```bash
   sudo chown -R 1000:1000 data books bookdrop mariadb
   ```
3. Start the stack:
   ```bash
   docker compose up -d
   ```

## Ports

- **6060** — Web UI and API

## Volumes

- `./data` — app data (DB files, icons, etc.)
- `./books` — library books
- `./bookdrop` — drop folder for new books
- `./mariadb/config` — MariaDB config and data

## Permission errors after first run

If you see `AccessDeniedException: /app/data/icons` (or similar), the volume dirs were likely created by Docker as root. Fix ownership then restart:

```bash
docker compose down
sudo chown -R 1000:1000 data books bookdrop mariadb
docker compose up -d
```

Use your own UID/GID if your `.env` sets `APP_USER_ID`/`APP_GROUP_ID` to something other than 1000.
