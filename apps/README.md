# apps — Self-hosted applications

Self-hosted apps that run on `proxy-net` and can be exposed via Nginx Proxy Manager (core/npm) or used internally.

| Stack    | Description                    | Port / UI |
|----------|--------------------------------|-----------|
| linkding | Linkding — bookmark manager    | 9090      |
| booklore | Booklore — book library manager | 6060    |
| komga    | Komga — comic/manga server     | 25600     |

**Usage:** Enable the service first, then start it:
```bash
task apps:enable -- immich
task apps:immich
```
Or from the service folder:
```bash
touch .enabled && task up
```
Copy `.env.sample` to `.env` and set variables if needed. For booklore, vikunja, and komga run `task setup` instead of `task up` on first start (creates required directories).