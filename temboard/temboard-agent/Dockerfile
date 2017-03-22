FROM python:2.7-slim

MAINTAINER Étienne BERSAC <etienne.bersac@dalibo.com>

RUN apt-get update -y \
    # For docker client \
    && apt-get install -y --no-install-recommends libltdl7 postgresql-client \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    ;

RUN useradd --home-dir /var/lib/temboard --create-home --system temboard
VOLUME /var/lib/temboard
WORKDIR /var/lib/temboard

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /usr/local/bin/wait-for-it
RUN chmod 0755 /usr/local/bin/wait-for-it

ENV TEMBOARD_HOSTNAME ""
ENV TEMBOARD_KEY ""
ENV TEMBOARD_USERS alice:alice bob:bob
ENV TEMBOARD_LOGGING_LEVEL INFO
ENV TEMBOARD_PLUGINS '["activity", "administration", "dashboard", "settings", "supervision"]'
ENV TEMBOARD_SSL_CA /usr/local/src/temboard-master/temboard-agent/share/temboard-agent_ca_certs_CHANGEME.pem
ENV TEMBOARD_SSL_CERT /usr/local/src/temboard-master/temboard-agent/share/temboard-agent_CHANGEME.pem
ENV TEMBOARD_SSL_KEY /usr/local/src/temboard-master/temboard-agent/share/temboard-agent_CHANGEME.key
ENV TEMBOARD_UI_URL ""
ENV TEMBOARD_UI_CREDENTIALS "admin:admin"
ENV TEMBOARD_GROUPS local_instances

ADD https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 /usr/local/bin/gosu
RUN chmod 0755 /usr/local/bin/gosu

COPY entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["gosu", "temboard", "docker-entrypoint.sh"]
CMD ["temboard-agent --config temboard-agent.conf"]

EXPOSE 2345

ADD https://github.com/dalibo/temboard/archive/master.zip /usr/local/src/temboard.zip
RUN python -m zipfile -e /usr/local/src/temboard.zip /usr/local/src/ \
    && pip install --no-cache-dir -e /usr/local/src/temboard-master/temboard-agent \
    && rm -f /usr/local/src/temboard.zip \
    ;
