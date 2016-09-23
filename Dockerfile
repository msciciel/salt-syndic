FROM centos:centos6

RUN curl -L http://bootstrap.saltstack.com -o bootstrap_salt.sh ;\
    sh bootstrap_salt.sh -X -M ;\
    yum -y install git mc ;\
    yum clean all

ENV TERM linux
ENV GIT_SSL_NO_VERIFY true
COPY files/master /etc/salt/master
COPY files/minion /etc/salt/minion

RUN git clone https://git.icore/salt/salt-formula.git  /srv/salt/base/salt-formula
RUN git clone https://git.icore/salt/users-formula.git  /srv/salt/base/users-formula
RUN git clone https://git.icore/salt/git-formula.git  /srv/salt/base/git-formula

RUN mkdir -p /srv/local/salt /srv/local/pillar
COPY files/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]