FROM centos:centos6

RUN curl -L http://bootstrap.saltstack.com -o bootstrap_salt.sh ;\
    sh bootstrap_salt.sh -X -M ;\
    yum -y install git ;\
    yum clean all

COPY files/master /etc/salt/master
COPY files/minion /etc/salt/minion

RUN git clone https://github.com/saltstack-formulas/salt-formula.git  /srv/formulas/prod/salt-formula
RUN git clone https://github.com/saltstack-formulas/salt-formula.git  /srv/formulas/itg/salt-formula

COPY files/docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]