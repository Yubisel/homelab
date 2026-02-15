# Homelab

Docker-based homelab configuration: databases, core infrastructure (reverse proxy, DNS, Docker UI), and self-hosted apps. All services use a shared `proxy-net` network and are set up to start on server boot.

## Quick start

1. **One-time setup** — create the shared Docker network:
   ```bash
   ./init.sh
   ```
2. **Start a stack** — from any stack directory, e.g. `core/portainer`:
   ```bash
   docker compose up -d
   ```
3. **Start on reboot** — see [BOOT.md](BOOT.md) to enable Docker and optionally the homelab boot service.

## Folder structure

```
homelab/
├── README.md           # This file
├── BOOT.md             # How to start services on server reboot
├── init.sh              # Creates the shared proxy-net Docker network
├── db/                  # Databases (PostgreSQL, MongoDB)
├── core/                # Infrastructure: proxy, DNS, Docker UIs
├── apps/                # Self-hosted applications
└── systemd/             # Systemd unit to start all stacks on boot
```

| Folder   | Purpose |
|----------|--------|
| [db/](db/) | Databases used by other services and apps. |
| [core/](core/) | Core infrastructure: reverse proxy (NPM), DNS (AdGuard), Docker UIs (Portainer, Dockge). |
| [apps/](apps/) | Self-hosted applications (e.g. Linkding). |
| [systemd/](systemd/) | Systemd service to bring up all stacks after reboot. |

Each stack lives in its own subfolder with a `docker-compose.yml` (and optional env files). Stacks are independent; start only what you need.
