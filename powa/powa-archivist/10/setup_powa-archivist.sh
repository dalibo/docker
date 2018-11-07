#!/bin/bash
set -e

# Configure shared_preload_libraries
echo "shared_preload_libraries = 'pg_stat_statements,powa,pg_qualstats,pg_stat_kcache'" >> $PGDATA/postgresql.conf
echo "listen_addresses = '*'" >> $PGDATA/postgresql.conf

# restart pg
pg_ctl -D "$PGDATA" -w stop -m fast
pg_ctl -D "$PGDATA" -w start

psql -f /usr/local/src/install_all.sql
