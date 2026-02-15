# systemd — Boot and service units

Systemd units used to start the homelab after a server reboot.

| File                    | Purpose |
|-------------------------|---------|
| homelab-boot.service    | One-shot service that runs after Docker and network are up: ensures `proxy-net` exists and runs `docker compose up -d` for each stack. |

**Usage:** See [BOOT.md](../BOOT.md) in the repo root. In short: set `LAB_ROOT` in the unit to your homelab path, copy the unit to `/etc/systemd/system/`, then `daemon-reload` and `enable homelab-boot.service`. When you add a new stack, add a matching `ExecStart` line to this service and run `daemon-reload` again.
