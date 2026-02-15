# Starting homelab services on server reboot

Services will not start automatically after a reboot unless both **Docker** and (optionally) the **homelab boot service** are enabled.

## 1. Enable Docker to start on boot

On Linux (systemd):

```bash
sudo systemctl enable docker
```

After a reboot, Docker will start and will **restart any container that has a `restart` policy** (`restart: unless-stopped` or `restart: always`). All stacks in this repo already use that policy (including MongoDB after the fix).

So in theory, enabling Docker is enough: once Docker is up, it will bring back the containers that were running before the shutdown.

## 2. (Recommended) Use the homelab boot service

If you prefer a single place that explicitly starts every stack after boot (useful if you ever recreate containers without a restart policy, or if Docker’s restart behavior isn’t enough), use the provided systemd unit.

1. **Set the homelab path** in the service file:

   Edit `systemd/homelab-boot.service` and set `LAB_ROOT` to the path where this repo lives, e.g.:

   ```ini
   Environment="LAB_ROOT=/home/yubisel/homelab"
   ```

2. **Install and enable the service**:

   ```bash
   sudo cp systemd/homelab-boot.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable homelab-boot.service
   ```

3. **Optional: run once now** (without rebooting):

   ```bash
   sudo systemctl start homelab-boot.service
   ```

After a reboot, `homelab-boot.service` runs once: it ensures the `proxy-net` network exists and starts each stack with `docker compose up -d`.

## Summary

| Approach | What to do |
|----------|------------|
| **Minimal** | `sudo systemctl enable docker` — containers with `restart: unless-stopped` will come back when Docker starts. |
| **Explicit** | Install and enable `homelab-boot.service` as above — all listed stacks are started in order after Docker and network are up. |

You can use both: Docker’s restart policy plus the boot service for a reliable homelab startup.
