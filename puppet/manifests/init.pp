node default {
  include stdlib
  include apt

  package {'install uuid-runtime': name    => 'uuid-runtime',ensure  => installed,}
  package {'npm': name    => 'npm',ensure  => installed,}
  package {'ruby-compass': name    => 'ruby-compass', ensure  => installed,}
  package { "openssh-server": ensure => "installed" }

  class {'mbank_api_php56':}
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
  } ->
  package {'npm':
    name    => 'npm',
    ensure  => installed,
  } ->
  file { '/usr/bin/node':
    ensure => 'link',
    target => '/usr/bin/nodejs',
  } ->
  package {'ruby-compass':
    name    => 'ruby-compass',
    ensure  => installed,
  } ->
  package { 'bower':
    provider => 'npm',
    require => Package['npm']
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

  $host_name = "wallet.best"
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
    ssl_dhparam => '/etc/ssl/dhparam.pem'
  } ->

  vcsrepo { '/www/mbank.web':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.mbank.web_master:Nebo15/mbank.web.git',
    user       => 'www-data',
    revision   => 'master',
    require => File["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]
  } ->

  vcsrepo { '/www/mbank.web.mobile':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.mbank.web.mobile_master:Nebo15/mbank.web.mobile.git',
    user       => 'www-data',
    revision   => 'master',
  } ->

  vcsrepo { '/www/mbank.web.admin':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.mbank.web.admin_master:Nebo15/mbank.web.admin.git',
    user       => 'www-data',
    revision   => 'master',
  } ->
  vcsrepo { '/www/mbank.web.b2b':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.mbank.web.b2b_master:Nebo15/mbank.web.b2b.git',
    user       => 'www-data',
    revision   => 'master',
  }

  file { '/etc/nginx/sites-enabled/mbank.web.conf':
    ensure => 'link',
    target => '/www/mbank.web/settings/nginx/prod.conf',
    require => Vcsrepo['/www/mbank.web']
  }
  file { '/etc/nginx/sites-enabled/mbank.web.mobile.conf':
    ensure => 'link',
    target => '/www/mbank.web.mobile/settings/nginx/prod.conf',
    require => Vcsrepo['/www/mbank.web.mobile']
  }
  file { '/etc/nginx/sites-enabled/mbank.web.mobile.bov.conf':
    ensure => 'link',
    target => '/www/mbank.web.mobile/settings/nginx/prod.bov.conf',
    require => Vcsrepo['/www/mbank.web.mobile']
  }
  file { '/etc/nginx/sites-enabled/wallet.balticps.lv.conf':
    ensure => 'link',
    target => '/www/mbank.web.mobile/settings/nginx/prod.balticps.conf',
    require => Vcsrepo['/www/mbank.web.mobile']
  }
  file { '/etc/nginx/sites-enabled/mbank.web.admin.conf':
    ensure => 'link',
    target => '/www/mbank.web.admin/settings/nginx/prod.conf',
    require => Vcsrepo['/www/mbank.web.admin']
  }
  file { '/etc/nginx/sites-enabled/mbank.web.b2b.conf':
    ensure => 'link',
    target => '/www/mbank.web.b2b/settings/nginx/prod.conf',
    require => Vcsrepo['/www/mbank.web.b2b']
  }
}
