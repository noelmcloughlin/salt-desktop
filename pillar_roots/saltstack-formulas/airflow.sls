# -*- coding: utf-8 -*-
# vim: ft=yaml
---
airflow:
  identity:
    airflow:
      user: airflow       # local or ldap username
      group: airflow       # local or ldap groupname
      skip_user_state: false   # false if local user; true if ldap user
  database:
    airflow:
      user: airflow
      pass: airflow
      email: airflow@localhost
  config:
    airflow:
      flask:
        auth_type: AUTH_DB # AUTH_LDAP, etc

        ## Microsoft AD Example ##
        # https://flask-appbuilder.readthedocs.io/en/latest/security.html#authentication-ldap
        auth_ldap_server: ldap://ldapserver.new    # must include protocol (ldap or ldaps)
        auth_ldap_append_domain: example.com
        auth_ldap_uid_field: sAMAccountName  # or uid or userPrincipalName or ?
        auth_ldap_search: OU=ouEngineers_myteam,dc=example,dc=com
        auth_ldap_group_field: memberOf
        auth_ldap_allow_self_signed: False

        ## https://confluence.atlassian.com/kb/how-to-write-ldap-search-filters-792496933.html
        auth_ldap_search_filter: (&(objectCategory=Person)(sAMAccountName=*)(|(memberOf=cn=grpRole_myteam,OU=ouEngineers_myteam,dc=example,dc=com)(memberOf=cn=grpRole_yourteam,OU=ouEngineers_yourteam,dc=example,dc=com)))
        # auth_ldap_search_filter: (memberOf=CN=myGrpRole,OU=myOrg,DC=example,DC=com)

        auth_roles_sync_at_login: True
        # permanent_session_lifetime: 1800
        auth_user_registration_role: Admin    # change to 'Viewer' after post-install admin-onboarding
        auth_user_registration: True  # allow users not already in FAB DB
        webserver:
          web_server_host: 0.0.0.0
          web_server_port: 8080

      content:
        api: {}
        celery_kubernetes_executor: {}
        celery:
          # https://docs.celeryproject.org/en/v5.0.2/getting-started/brokers
          default_queue: /airflow
          broker_url: amqp://airflow:airflow@127.0.0.1:5672/airflow  # port 5672 here
          # broker_url: redis://127.0.0.1:6379/0
          result_backend: db+postgresql://airflow:airflow@127.0.0.1/airflow

        cli: {}
        core:
          authentication: True  # gone in v2
          dags_folder: /home/airflow/dags
          plugins_folder: /home/airflow/plugins
          executor: CeleryExecutor
          default_timezone: utc
          load_examples: True
          # https://stackoverflow.com/questions/45455342
          sql_alchemy_conn: postgresql+psycopg2://airflow:airflow@127.0.0.1/airflow
          security: ''
        webserver:
          secret_key: {{ range(1,2000) | random }}
      state_colors:
        # https://airflow.apache.org/docs/apache-airflow/stable/howto/customize-state-colors-ui.html
        queued: 'darkgray'
        running: '#01FF70'
        success: '#2ECC40'
        failed: 'firebrick'
        up_for_retry: 'yellow'
        up_for_reschedule: 'turquoise'
        upstream_failed: 'orange'
        skipped: 'darkorchid'
        scheduled: 'tan'
  service:
    airflow:
      enabled:
        - airflow-celery-flower
        - airflow-scheduler
        - airflow-webserver
        - airflow-celery-worker
  pkg:
    airflow:
      version: 2.1.0
          {%- if grains.osfinger == 'CentOS Linux-7' %}
          # because centos7 OS default is python2, need to be explicit
      uri_c: https://raw.githubusercontent.com/apache/airflow/constraints-VERSION/constraints-3.6.txt
          {%- endif %}
      extras:
        # https://airflow.apache.org/docs/apache-airflow/stable/installation.html#extra-packages
        # https://airflow.apache.org/docs/apache-airflow/stable/extra-packages-ref.html

        # Services Extras
        - async
        - crypto
        - dask
        - datadog           # Datadog hooks and sensors
        - devel
        - devel_ci
        - devel_azure
        - google            # Google Cloud
        - google_auth       # Google auth backend
        - hashicorp         # Hashicorp Services (Vault)
        - jira              # Jira hooks and operators
        - sendgrid          # Send email using sendgrid
        - slack             # airflow.providers.slack.operators.slack.SlackAPIOperator

        ## Software Extras
        - celery            # CeleryExecutor
        - cncf.kubernetes   # Kubernetes Executor and operator
        - docker            # Docker hooks and operators
        - elasticsearch     # Elasticsearch hooks and Log Handler
        - ldap              # LDAP authentication for users
        - microsoft.azure
        - microsoft.mssql   # Microsoft SQL server
        - mysql             # MySQL operators and hook, support as Airflow backend (mysql 5.6.4+)
        - postgres          # PostgreSQL operators and hook, support as an Airflow backend
        - password          # Password authentication for users
        - rabbitmq          # RabbitMQ support as a Celery backend
        - redis             # Redis hooks and sensors
        - samba
        - statsd            # Needed by StatsD metrics
        - virtualenv

        ## Standard protocol Extras
        # cgroups           # Needed To use CgroupTaskRunner
        - ftp
        - grpc              # Grpc hooks and operators
        - http              # http hooks and providers
        - imap              # IMAP hooks and sensors
        - kerberos          # Kerberos integration
        - sftp
        - snowflake
        - sqlite
        - ssh               # SSH hooks and Operator
        - microsoft.winrm   # WinRM hooks and operators

  linux:
    altpriority: 0   # zero disables alternatives
...
