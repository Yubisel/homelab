# db — Databases

Database services for the homelab. All use the shared `proxy-net` network so other stacks can reach them by container name.

| Stack    | Description                    | Port(s) |
|----------|--------------------------------|---------|
| postgres | PostgreSQL (custom image, init SQL) | 5432    |
| mysql    | MySQL 8 (custom image, init SQL)    | 3306    |
| redis    | Redis 7                         | 6379    |
| mongodb  | MongoDB 7.0                    | 27017   |

**Usage:** Enable the service first, then start it:
```bash
task db:enable -- postgres
task db:postgres
```
Or from the service folder:
```bash
touch .enabled && task up
```
Copy `.env.example` to `.env` and set credentials where required (e.g. Postgres).
