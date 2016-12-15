#vim: set ft=dockerfile
FROM postgres:9.6
MAINTAINER Julien Rouhaud <julien.rouhaud@dalibo.com>

WORKDIR /usr/local/src

RUN apt-get update && apt-get install -y wget unzip \
    && wget https://github.com/dalibo/temboard/archive/master.zip \
    && unzip master.zip && rm master.zip \
    && apt-get purge -y --auto-remove wget unzip \
    && rm -rf /var/lib/apt/lists/*

# setup the temboard database
ADD setup_temboard.sh /docker-entrypoint-initdb.d/
ADD setup_temboard.sql /usr/local/src/
