# apps — Self-hosted applications

Self-hosted apps that run on `proxy-net` and can be exposed via Nginx Proxy Manager (core/npm) or used internally.

| Stack    | Description              | Port / UI |
|----------|--------------------------|-----------|
| linkding | Linkding — bookmark manager | 9090    |

**Usage:** From a stack folder (e.g. `apps/linkding`), copy `.env.sample` to `.env`, set variables if needed, then run `docker compose up -d`.
