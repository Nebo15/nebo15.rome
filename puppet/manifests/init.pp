node default {

  $host_name = "gandalf.nebo15.com"

  if (has_role("local")) {
    $dhparam = undef
    $revision = undef
  }
  if (has_role("prod")) {
    $dhparam = '/etc/ssl/dhparam.pem'
    $revision = "master"
  }
  if (has_role("develop")) {
    $dhparam = undef
    $revision = "develop"
  }

  include stdlib
  include apt

  package {'install uuid-runtime': name    => 'uuid-runtime',ensure  => installed,}
  package { "openssh-server": ensure => "installed" }

  class{'enable_autoupdate':} -> class{'nebo15_users':} ->

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
  } ->
  file { "/etc/sudoers.d/deploybot-user":
    content => "\
Cmnd_Alias        CMDSS = /usr/bin/puppet
deploybot  ALL=NOPASSWD: CMDSS
",
    mode => 0440,
    owner => root,
    group => root,
  }->

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
    ssl_dhparam => $dhparam
  }
}