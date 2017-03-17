#!/bin/bash
set -e

# Make sure pg is available on the network
echo "listen_addresses = '*'" >> $PGDATA/postgresql.conf

# setup temboard database and application
psql -c "CREATE DATABASE temboard"
psql -f /usr/local/src/temboard-master/share/sql/application.sql temboard
# and also supervision plugin
psql -f /usr/local/src/temboard-master/temboardui/plugins/supervision/sql/supervision.sql temboard
# finally, do the application configuration
psql -f /usr/local/src/setup_temboard.sql temboard
