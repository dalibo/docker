#!/bin/bash
set -e

# Make sure pg is available on the network
gosu postgres echo "listen_addresses = '*'" >> $PGDATA/postgresql.conf

# setup temboard database and application
gosu postgres psql -c "CREATE DATABASE temboard"
gosu postgres psql -f /usr/local/src/temboard-master/share/sql/application.sql temboard
# and also supervision plugin
gosu postgres psql -f /usr/local/src/temboard-master/temboardui/plugins/supervision/sql/supervision.sql temboard
# finally, do the application configuration
gosu postgres psql -f /usr/local/src/setup_temboard.sql temboard
