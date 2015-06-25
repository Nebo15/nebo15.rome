class install_sphinx_search{
  include apt
  apt::ppa { 'ppa:builds/sphinxsearch-rel22': }
  package { 'sphinxsearch':
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Ppa['ppa:builds/sphinxsearch-rel22']
  }

  file { ["/www/mbank.api/sphinx/", "/www/mbank.api/sphinx/index", "/www/mbank.api/sphinx/log"]:
    ensure => "directory",
    owner  => "sphinxsearch",
    group  => "sphinxsearch",
    mode   => 755,
    require => Package['sphinxsearch']
  }
  file_line { 'autostart_sphinx':
    path  => '/etc/default/sphinxsearch',
    line  => 'START=yes',
    match => '^START=*',
    require => Package['sphinxsearch']
  }

  file { "/etc/sphinxsearch/sphinx.conf":
    ensure => link,
    target => "/www/mbank.api/settings/sphinx.example.conf",
    require => Package['sphinxsearch']
  }

  service { 'sphinxsearch':
    ensure      => 'running',
    enable     => true,
    require => File['/etc/sphinxsearch/sphinx.conf'],
  }
}

class sethostname {
  file { "/etc/hostname":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "api.wallet.best\n",
    notify => Exec["set-hostname"],
  }
  exec { "set-hostname":
    command => "/bin/hostname -F /etc/hostname",
    unless => "/usr/bin/test `hostname` = `/bin/cat /etc/hostname`",
  }
}

node default {

  include install_sphinx_search
  include sethostname
  include best_wallet_crons

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
    server_tokens => 'off'
  }

  file { "/etc/nginx/sites-enabled/mbank.api.conf":
    ensure => link,
    target => "/www/mbank.api/settings/nginx/prod.conf",
    notify => Service["nginx"],
  }

  file { "/etc/nginx/sites-enabled/autodeployer.conf":
    ensure => link,
    target => "/www/nebo15.rome/www/config/nginx.conf",
    notify => Service["nginx"],
  }
}
