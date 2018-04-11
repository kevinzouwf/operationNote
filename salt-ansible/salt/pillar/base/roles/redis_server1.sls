redis-server1:
  redis-slave:
    port: 6380
    bind: 0.0.0.0
    timeout: 300
    loglevel: warning
    dir: /data/redis/
    maxclients: 3000
    maxmemory: 1Gb
    master: 127.0.0.1
    master_port: 6379
  redis-server:
    port: 6379
    bind: 0.0.0.0
    timeout: 300
    loglevel: warning
    dir: /data/redis/
    maxclients: 3000
    maxmemory: 1Gb
