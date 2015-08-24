node default {
  include stdlib
  include apt

  package {'install uuid-runtime': name    => 'uuid-runtime',ensure  => installed,}
  package { "openssh-server": ensure => "installed" }

  $new_relic_licence_key = "fc04150b6b2478740bd6a6357087c1342bf99789"
  $new_relic_app_name = 'flash.production'
  class{'enable_autoupdate':} -> class {'mbank_api_php56':} ->
  class {'newrelic::server::linux':
    newrelic_license_key  => $new_relic_licence_key,
  } ~>
  class {'newrelic::agent::php':
    newrelic_license_key  => $new_relic_licence_key,
    newrelic_ini_appname  => $new_relic_app_name,
    newrelic_php_conf_dir => ['/etc/php5/mods-available'],
  }
  class{'composer':}
  class{'mbank_api_users':} ->
  file { ["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 755
  } ->
  file { "/etc/sudoers.d/www-data-user":
    content => "\
Cmnd_Alias        CMDS = /usr/bin/puppet
www-data  ALL=NOPASSWD: CMDS
",
    mode => 0440,
    owner => root,
    group => root,
  }

  service { "ssh":
    ensure => "running",
    enable => "true",
    require => Package["openssh-server"]
  }

  file_line { 'change_ssh_port':
    path  => '/etc/ssh/sshd_config',
    line  => 'Port 2020',
    match => '^Port *',
    notify => Service["ssh"]
  }

  $host_name = "ams-flash.wallet.best"
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
  class {'mariadbrepo' :
    version => '5.5',
  } -> package{'install maria db server': name    => 'mariadb-server', ensure  => installed,}
    -> package{'install maria db client': name    => 'mariadb-client', ensure  => installed,}

  class { 'nginx':
    daemon_user => 'www-data',
    worker_processes => 4,
    pid => '/run/nginx.pid',
    worker_connections => 4000,
    multi_accept => 'on',
    events_use => 'epoll',
    sendfile => 'on',
    http_tcp_nopush => 'on',
    http_tcp_nodelay => 'on',
    keepalive_timeout => '65',
    types_hash_max_size => '2048',
    server_tokens => 'off',
    ssl_dhparam => '/etc/ssl/dhparam.pem'
  } ->
  vcsrepo { '/www/flash':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.flash_flash:Nebo15/flash.git',
    user       => 'www-data',
    revision   => 'master',
    require => File["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]
  }

  file { '/etc/nginx/sites-enabled/flash.conf':
    ensure => 'link',
    target => '/www/flash/settings/nginx/prod.conf',
    require => Vcsrepo['/www/flash']
  }
}
