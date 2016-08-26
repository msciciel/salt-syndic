FROM centos:centos6

RUN curl -L http://bootstrap.saltstack.com -o bootstrap_salt.sh ;\
    sh bootstrap_salt.sh -X -M ;\
    yum -y install git mc ;\
    yum clean all

ENV TERM linux
ENV GIT_SSL_NO_VERIFY true
COPY files/master /etc/salt/master
COPY files/minion /etc/salt/minion

RUN git clone https://git.icore/salt/salt-formula.git  /srv/formulas/salt-formula
RUN git clone https://git.icore/salt/users-formula.git  /srv/formulas/users-formula

RUN mkdir -p /srv/salt/prod/states /srv/salt/itg/states /srv/pillar/base/
COPY files/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]