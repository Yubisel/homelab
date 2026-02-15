# db — Databases

Database services for the homelab. All use the shared `proxy-net` network so other stacks can reach them by container name.

| Stack    | Description                    | Port(s) |
|----------|--------------------------------|---------|
| postgres | PostgreSQL (custom image, init SQL) | 5432    |
| mongodb  | MongoDB 7.0                    | 27017   |

**Usage:** From a stack folder (e.g. `db/postgres`), run `docker compose up -d`. Copy `.env.example` to `.env` and set credentials where required (e.g. Postgres).
