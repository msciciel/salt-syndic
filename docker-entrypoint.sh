#!/bin/sh

if [ $SALT_MASTER ]; then
  echo "master: $SALT_MASTER" >> /etc/salt/minion.d/defaults.conf
fi

if [ $SALT_MASTER_ENABLE ]; then
  salt-master -d
fi

salt-minion
