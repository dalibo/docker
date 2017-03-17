#vim:set ft=dockerfile
FROM centos:7
MAINTAINER Julien Rouhaud <julien.rouhaud@dalibo.com>

WORKDIR /usr/local/src

RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && yum -y install wget unzip python-pip postgresql-devel python-devel gcc\
    && wget https://github.com/dalibo/temboard/archive/master.zip \
    && unzip master.zip && rm master.zip \
    && pip install --editable ./temboard-master/ \
    && mkdir -p /etc/temboard \
    && yum remove -y wget unzip python-pip postgresql-devel python-devel gcc epel-release \
    && yum clean all

COPY temboard.conf /etc/temboard/
COPY try_temboard.sh /usr/local/bin

EXPOSE 8888
CMD ["/usr/local/bin/try_temboard.sh"]
