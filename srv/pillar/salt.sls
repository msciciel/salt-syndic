{% set formulas = [] %}

salt:
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

    fileserver_backend:
      - roots
    file_roots:
      prod:
        - /srv/salt/prod/states
        - /srv/salt/prod/common
        - /srv/formulas/prod/salt-formula/
      itg:
        - /srv/salt/itg/states
        - /srv/salt/itg/common
        - /srv/formulas/itg/salt-formula/

    pillar_roots:
      base:
        - /srv/pillar/base/
        - /srv/pillar/common/

