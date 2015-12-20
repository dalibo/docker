#!/bin/bash
set -e

# Configure shared_preload_libraries
gosu postgres echo "shared_preload_libraries = 'pg_stat_statements,powa,pg_qualstats,pg_stat_kcache'" >> $PGDATA/postgresql.conf

# restart pg
gosu postgres pg_ctl -D "$PGDATA" -w stop -m fast
gosu postgres pg_ctl -D "$PGDATA" -w start

gosu postgres psql -f /usr/local/src/install_all.sql
