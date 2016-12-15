#vim: set ft=dockerfile
FROM dalibo/powa-archivist-94
MAINTAINER Julien Rouhaud <julien.rouhaud@dalibo.com>

WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y wget unzip supervisor \
    && wget https://github.com/dalibo/temboard/archive/master.zip \
    && unzip master.zip && rm master.zip \
    && mkdir -p /etc/temboard-agent \
    && mkdir -p /var/lib/temboard-agent/main \
    && apt-get purge -y --auto-remove wget unzip \
    && rm -rf /var/lib/apt/lists/*

# configure powa-archivist
ADD setup_temboard-agent.sh /docker-entrypoint-initdb.d/
ADD temboard-agent.conf /etc/temboard-agent/
ADD users /etc/temboard-agent/
ADD supervisord.conf /etc/
EXPOSE 2345 5432
ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
