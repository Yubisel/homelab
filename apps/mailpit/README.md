# Mailpit

[Mailpit](https://mailpit.axllent.org) — SMTP server and web UI for capturing and testing emails in development. All outgoing mail is intercepted and stored locally; nothing is forwarded to real recipients.

## Ports

- **8025** — Web UI
- **1025** — SMTP

## First-time setup

```bash
cp .env.example .env
task apps:enable -- mailpit
task apps:mailpit
```

## Testing with swaks

Install swaks if needed: `brew install swaks` (Mac) or `apt install swaks` (Debian/Ubuntu).

**From inside the VM (or any host on `proxy-net`):**
```bash
swaks --to test@example.com \
      --from sender@example.com \
      --server localhost \
      --port 1025 \
      --body "Hello from mailpit"
```

**From your Mac (direct to VM IP):**
```bash
swaks --to test@example.com \
      --from sender@example.com \
      --server 192.168.1.150 \
      --port 1025 \
      --body "Hello from mailpit"
```

After sending, open `http://192.168.1.150:8025` (or `http://mailpit.lab:8025` if your DNS points to the VM) to see the captured email.

**From other Docker containers on `proxy-net`** (e.g. n8n, vikunja):
```
SMTP Host:     mailpit
SMTP Port:     1025
Encryption:    None
Auth:          any (MP_SMTP_AUTH_ACCEPT_ANY=1 accepts anything)
```

## Exposing SMTP externally with ngrok

Use this to receive emails from apps running outside your local network (external VPS, CI/CD, cloud services, etc.).

**1. Install ngrok:** https://ngrok.com/download

**2. Start a TCP tunnel to the SMTP port:**
```bash
ngrok tcp 1025
```

ngrok will output something like:
```
Forwarding  tcp://0.tcp.ngrok.io:12345 -> localhost:1025
```

**3. Configure the external app to use:**
```
SMTP Host:     0.tcp.ngrok.io
SMTP Port:     12345
Encryption:    None
User:          any
Password:      any
```

> **Note:** On the free tier, the host and port change every time ngrok restarts. To keep them stable, run ngrok as a persistent service or use a paid plan for a fixed TCP address.

**Keep ngrok running persistently (optional):**
```bash
# Run ngrok in the background and log output
nohup ngrok tcp 1025 > /tmp/ngrok.log 2>&1 &

# Check assigned address
curl -s http://localhost:4040/api/tunnels | python3 -m json.tool | grep public_url
```

## Web UI auth (recommended if exposed publicly)

If you expose the UI via Nginx Proxy Manager or Cloudflare Tunnel, set a password file to protect it:

```bash
# Generate an htpasswd entry
htpasswd -nb admin yourpassword >> ./data/authfile
```

Then set in `.env`:
```
MP_UI_AUTH_FILE=/data/authfile
```

Restart the container after editing `.env`:
```bash
task apps:mailpit:restart
```
