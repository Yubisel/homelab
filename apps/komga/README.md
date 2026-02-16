# Komga

[Komga](https://komga.org/) — comic and manga server. Based on the [official Docker instructions](https://komga.org/docs/installation/docker).

## First-time setup

1. Copy env and set timezone:
   ```bash
   cp .env.sample .env
   # Edit .env: set TZ (e.g. Europe/London) and USER_ID/GROUP_ID if not 1000:1000.
   ```
2. Create volume directories **before** the first `docker compose up` so they are owned by your user:
   ```bash
   chmod +x init-dirs.sh && ./init-dirs.sh
   ```
   If the app still has permission errors:
   ```bash
   sudo chown -R 1000:1000 config data
   ```
3. Start the stack:
   ```bash
   docker compose up -d
   ```

## Ports

- **25600** — Web UI and API

## Volumes

- `./config` — database and Komga configuration (use a local filesystem, not NFS/CIFS).
- `./data` — library content; put your books here and use it as the preferred import location for hardlinks.

## Optional: more memory

If you see `OutOfMemoryException` in logs, set in `.env`:

```bash
JAVA_TOOL_OPTIONS=-Xmx4g
```

## Permission errors after first run

If volume dirs were created by Docker as root, fix ownership then restart:

```bash
docker compose down
sudo chown -R 1000:1000 config data
docker compose up -d
```

Use your own UID/GID if your `.env` sets `USER_ID`/`GROUP_ID` to something other than 1000.
