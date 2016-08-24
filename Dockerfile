FROM centos:centos6

RUN curl -L http://bootstrap.saltstack.com -o bootstrap_salt.sh ;\
    sh bootstrap_salt.sh -X -M ;\
    yum clean all

RUN echo "open_mode: True" >> /etc/salt/master.d/defaults.conf
RUN echo "order_masters: True" >> /etc/salt/master.d/defaults.conf
RUN echo "syndic_wait: 5" >> /etc/salt/master.d/defaults.conf
RUN echo "startup_states: highstate" >> /etc/salt/minion.d/defaults.conf

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]