# core — Infrastructure

Core homelab services: reverse proxy, DNS/ad-blocking, and Docker management UIs. Everything here is on `proxy-net` so it can talk to databases and apps.

| Stack    | Description                          | Port(s) / UI        |
|----------|--------------------------------------|----------------------|
| portainer| Portainer CE — Docker GUI            | 9000, 9443           |
| npm      | Nginx Proxy Manager — reverse proxy & TLS | 80, 81, 443     |
| adguard  | AdGuard Home — DNS & ad-blocking      | 53, 3000, 8080, 445 |
| dockge   | Dockge — Compose stack manager       | 5001                 |

**Usage:** Enable the service first, then start it:
```bash
task core:enable -- adguard
task core:adguard
```
Or from the service folder:
```bash
touch .enabled && task up
```
For Dockge, set `DOCKGE_STACKS_DIR` (and the bind mount) to your homelab repo path so it can manage the other stacks.
