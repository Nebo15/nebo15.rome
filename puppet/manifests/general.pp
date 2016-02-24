class sethostname {

  $host_name = "sms.forza.md"
  file { "/etc/hostname":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "$host_name\n",
    notify => Exec["set-hostname"],
  }
  exec { "set-hostname":
    command => "/bin/hostname -F /etc/hostname",
    unless => "/usr/bin/test `hostname` = `/bin/cat /etc/hostname`",
  }
}

node default {

  include sethostname

  class{ 'best_wallet_crons':
    drunken_do => true
  }

  class { 'nginx':
    daemon_user => 'www-data',
    worker_processes => 4,
    pid => '/run/nginx.pid',
    worker_connections => 1024,
    multi_accept => 'on',
    events_use => 'epoll',
    sendfile => 'on',
    http_tcp_nopush => 'on',
    http_tcp_nodelay => 'on',
    keepalive_timeout => '65',
    types_hash_max_size => '2048',
    server_tokens => 'off',
  }

  vcsrepo { '/www/mbank.api.serega':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.mbank.api.serega:Nebo15/mbank.api.serega.git',
    user       => 'www-data',
    revision   => 'master'
  }

  file { "/etc/nginx/sites-enabled/mbank.api.serega.conf":
    ensure => file,
    content => "\
server{
        listen 80 default_server;
        server_name sms.forza.md;

        set \$php 127.0.0.1:9000;
        set \$root_path /www/mbank.api.serega;

        access_log /var/log/sandbox.sms.access.log;
        error_log /var/log/sandbox.sms.error.log;

        include /www/mbank.api.serega/nginx.conf;
}
",
    notify => Service["nginx"],
  }
}
