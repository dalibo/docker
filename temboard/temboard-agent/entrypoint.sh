#!/bin/bash -eu

export PGHOST=${PGHOST-${TEMBOARD_HOSTNAME-localhost}}
export PGPORT=${PGPORT-5432}
export PGUSER=${PGUSER-postgres}
PGPASSWORD=${PGPASSWORD-}
export PGDATABASE=${PGDATABASE-postgres}

COMPOSE_PROJECT=$(docker inspect --format "{{ index .Config.Labels \"com.docker.compose.project\"}}" $HOSTNAME)
links=($(docker inspect --format "{{range .NetworkSettings.Networks.${COMPOSE_PROJECT}_default.Links }}{{.}} {{end}}" $HOSTNAME))
links=(${links[@]%%:${TEMBOARD_HOSTNAME}})
PGCONTAINER=${links[@]%%*:*}
COMPOSE_SERVICE=$(docker inspect --format "{{ index .Config.Labels \"com.docker.compose.service\"}}" $HOSTNAME)

echo "Managing PostgreSQL container $PGCONTAINER." >&2

echo "Generating temboard-agent.conf" >&2

cat > temboard-agent.conf <<EOF
# Generated by $0

[temboard]
home = /var/lib/temboard
users = /var/lib/temboard/users
address = 0.0.0.0
port = 2345
ssl_cert_file = ${TEMBOARD_SSL_CERT}
ssl_key_file = ${TEMBOARD_SSL_KEY}
hostname = ${TEMBOARD_HOSTNAME-${hostname --fqdn}}
key = ${TEMBOARD_KEY}

[logging]
method = stderr
level = ${TEMBOARD_LOGGING_LEVEL}

[postgresql]
host = /var/run/postgresql/
port = ${PGPORT}
dbname = ${PGDATABASE}
user = ${PGUSER}
password = ${PGPASSWORD}
instance = ${PGINSTANCE-main}

[supervision]
collector_url = ${TEMBOARD_UI_URL%/}/monitoring/collector
ssl_ca_cert_file = ${TEMBOARD_SSL_CA}

[administration]
pg_ctl = docker %s ${PGCONTAINER}
EOF


touch users
for entry in ${TEMBOARD_USERS} ; do
    echo "Adding user ${entry%%:*}."
    sed -i /${entry%:*}/d users
    temboard-agent-password $entry >> users
done

hostportpath=${TEMBOARD_UI_URL#*://}
hostport=${hostportpath%%/*}
wait-for-it ${hostport}
wait-for-it ${PGHOST}:${PGPORT}

register() {
    wait-for-it localhost:2345
    python /usr/local/src/temboard-agent-master/temboard-agent-register \
           --host $COMPOSE_SERVICE \
           --port 2345 \
           --config temboard-agent.conf \
           --groups ${TEMBOARD_GROUPS} \
           ${TEMBOARD_UI_URL} <<EOF
${TEMBOARD_UI_CREDENTIALS%:*}
${TEMBOARD_UI_CREDENTIALS#*:}
EOF
}

# Requires https://github.com/dalibo/temboard/pull/88
# register &

set -x
exec ${*-temboard-agent --config temboard-agent.conf}
