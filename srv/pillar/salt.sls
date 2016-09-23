{% set formulas = ['abrt','adretail','anacron','apache','bacula','bind','btsync','cert','change_report','check_cst',
                   'cm','collectd','command','consul','couchbase','cron','daw','db','db_user','dell','eagle',
                   'elasticsearch','ethtool','fwbuilder','gearmand','git','gitlab','gitlab_runner','glusterfs',
                   'haproxy','hardwar','htp','httpd_stats','icecast','icinga','iplv2','ipsec','iptables',
                   'keepalived','logrotate','logstash','mcrouter','memcached','mh','motd','mount','mysql','nagios',
                   'network','nginx','ntp','openstack','percona_mongodb','pgsql','php','postfix','pound','proftpd',
                   'rabbitmq','rbenv','redis','resolver','rhn','rsyncd','rsyslog','rtraporty','rvm','salt','sensu',
                   'smartd','squid','ssh','ssl_certs_mail_notify','ssmtp','sssd','statystyki','strych','sudoers',
                   'sysctl','tinc','tokumx','users','uwsgi','varnish'] %}

salt:
  master_remove_config: True

  master:
    rest_cherrypy:
      port: 8080
      host: 0.0.0.0
      webhook_disable_auth: True
      webhook_url: /hook
      disable_ssl: True

    max_open_files: 8192
    worker_threads: 4
    keep_jobs: 2
    timeout: 30
    loop_interval: 600
    job_cache: False
    minion_data_cache: True
    open_mode: True
    auto_accept: True
    state_verbose: false
    pillar_opts: False
    log_level_logfile: warning
    yaml_utf8: True
    order_masters: True
    top_file_merging_strategy: same

    fileserver_backend:
      - roots
    file_roots:
      base:
        - /srv/local/salt
        - /srv/salt/base/states
        {% for formula in formulas %}
        - /srv/salt/base/{{ formula }}-formula
        {% endfor %}

      itg:
        - /srv/local/salt
        - /srv/salt/itg/states
        {% for formula in formulas %}
        - /srv/salt/itg/{{ formula }}-formula
        {% endfor %}

    pillar_roots:
      base:
        - /srv/local/pillar
        - /srv/pillar

  reactor:
    - 'git/salt/refresh':
      - salt://reactor/sync_git.sls
    - 'salt/netapi/hook/git/salt/refresh':
      - salt://reactor/sync_git.sls
    - 'minion_start':
      - salt://reactor/sync_grains.sls
    - 'icinga/refresh':
      - salt://reactor/icinga_refresh.sls
    - 'salt/key':
      - salt://reactor/minion_delete.sls
    - 'openstack/fix_rabbitmq_connections':
      - salt://reactor/fix_openstack_rabbitmq.sls

git:
  {% for formula in formulas %}
  {{ formula }}-base:
    name: git@git.icore:salt/{{ formula }}-formula.git
    rev: master
    branch: master
    target: /srv/salt/base/{{ formula }}-formula
    force_checkout: True
  {{ formula }}-itg:
    name: git@git.icore:salt/{{ formula }}-formula.git
    rev: itg
    branch: itg
    target: /srv/salt/itg/{{ formula }}-formula
    force_checkout: True
  {% endfor %}

  states-base:
    name: git@git.icore:salt/states.git
    rev: master
    branch: master
    target: /srv/salt/base/states
    force_checkout: True
  states-itg:
    name: git@git.icore:salt/states.git
    rev: itg
    branch: itg
    target: /srv/salt/itg/states
    force_checkout: True
  pillar:
    name: git@git.icore:salt/pillar.git
    rev: master
    branch: master
    target: /srv/pillar
    force_checkout: True

users:
  root:
    ssh_keys:
      privkey: |
        -----BEGIN RSA PRIVATE KEY-----
        MIIEoQIBAAKCAQEAw7vprMAjvVmewtHtrtinXNB4AVgLZl3NDY5Pc3fmR/7HtYOD
        OqkMJu0jG9SCkPxNUaHF1IPBf8ruD/5L507k+zn6fTU8IemuPP7ZQ7C9Uu6u6pi+
        AQYS34X9eH7O8VWSR5pZ3M6sf8rTPzT/yE2jFu0u8NNo+7RA4lLNY0YdYkMklhKt
        lnbuziApUiZ5RvHXxftPTbq0JdcHl3j1S3KZgDl78rWy7cxn6oBJqLRIZ7ztqpox
        GEoGHla5gcah4PR5zL3yQi2LTMEdWQrgdDu3c2WvqIEdZw9pF7uTgcoVea6bF6+/
        Qy+nCgzDvUW3dzp1j1An0DkiDgysgmbK3EgDfwIBIwKCAQEAgKAOlhfc+MXdW3QC
        l3ht+ynodelmk7n7xxRgGK3geHQ6GDHZ5Lg7L4Xj3xae8Y/bCcIUSdLs3vMReDll
        FFhqlnaOqg0KQivY5kESbk+SWxHgqMrGAKw4Sb5zXc+sj/ZncOHGBiFqCtW+BPbx
        OnwpWDV2nkHIpWfS3d6kOew/MfB0UcB0im8itfF92fb73vWNYJ2XFJjVUQR0kWBr
        +nU83pWJmPAmb05nrpn04b7sUWU9NTPc8Pu/AZKb/cthRUzVqUUx33tlLfWkJPMm
        BLs/XoN6SqMFrtlFlLjLsI9fxXnw/SDqSRE51EnhextSjp9Vj9MmmYnwkClSjWLw
        C700AwKBgQD00IYQWMgrfg2jADJn2oEkP+y1Uk6cD4/68QsHu6aTszBXWjabGDaB
        FzQgR9+hfgTs331kTV9AfEds1hn0u2bPqcUxcM7tX/KdjnOl3/RPR9bILEg+uzKa
        n9PXubSujC1QtbNWBZfxeR5LfyNSGVXDG4WO88pTeSXepvnxC9AQ6wKBgQDMrVF8
        l4s1ctqwi9VEOou6/inrurALII4uvhLZ8UYjm7ZIE/BBhT/7IqSpmgAHpYIeFfpm
        URKi+LXDd2DsmrSRhY907Je2CwrIygPUNAkS3oQL/4OTPZ1OUs6F0aqHRpATUBg8
        XxlSb0Zj5vjRebqUbGfjsAESmCJbXVC6cLESvQKBgD7zyrO/Duacwa2SVhq0h5ub
        aMDpR2n1X4mrsmES/vLHrVhKZdAcK0XEI1jCBk4ZFzWYjfU4d5Q9NvAZzCj8/S4V
        tl0rouyVA99fJQ1leVY3C1gLYwjRDQMwaayANcZ70SNh7ElR5T4X1JcSEGWRfHP/
        w0IELLZg+xv/DRIY+v0JAoGATAXccBsH0gYWtppWhw5uagah2za2aohvUzCn6ozQ
        6KeM2PF2frx22Z8nN646hn9NliVrolighazVzEJIkmVZAtnWMr5G+nkhQ0O4R4EK
        rzy0s//RyPmg0/Le/oETdBLlDnzVzUfk1XnJsBP2BKmOcaSbnbZmzGRkiFXcJ/34
        oI8CgYBjqITtBSHx4rcSFaXdMjMfe9VrjnfWEIa9B/9AQ9y55EV3ahXzD0Wg3AiJ
        92sImSOBURIV61KanDow/Rq1c9a3492dhimXj6Pu5EvmtwZJTIDea5ULDPbtZ4/8
        lsfK0c1z4PXiC1JGmRR/EZMwsyAK4jcJJypMEtpVIEsNkcirSQ==
        -----END RSA PRIVATE KEY-----
      pubkey: dupa
    ssh_known_hosts:
      - git.icore ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAtH+2uwced1XIbWG0/M7suHAXcezPx3aUJrw+VMw9a4IW6zOSfSDQAoayo9Jqa1GRW6JOXkGVecDQpdobnxmYU7snQ5fE7wDZpI48VfZPlQoDB7p4sH/MwbJByawgVsF3OLZBRl3vbFjaovBKKR7pmAzRGAZPbo5+5o0WnktYK6HWvnEGfmKK4QabLYBzj5ylXPTUYn74po9kh5ok4shsXUX0ClZw1Vdbn07V8CQVkKY8BMeTuMyunpBFXXRdazoEFd6kXL2MCTa0NerieCYYOt2F5bcQN7PIklJ6uEYYSlcxqwQmtAJNZ232UMXfqWvw5orktpg7UYFLHtQz14kxcw==