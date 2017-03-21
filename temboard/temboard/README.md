# Temboard

Temboard is a web application for managing clusters for PostgreSQL instances.


## Environment variables

`temboard.conf` is generated from environment variables.

- `TEMBOARD_COOKIE_SECRET`
- `TEMBOARD_SSL_CA`, `TEMBOARD_SSL_CERT` and `TEMBOARD_SSL_KEY` for HTTPS.
- `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER` and `PGPASSWORD` for access to
  repository.
