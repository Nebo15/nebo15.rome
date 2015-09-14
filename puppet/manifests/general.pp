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
    require => Package['sphinxsearch'] }

  service { 'sphinxsearch':
    ensure      => 'running',
    enable     => true,
    require => File['/etc/sphinxsearch/sphinx.conf'],
  }
}

class sethostname {

  if (has_role("prod") and !has_role("develop")) {
    $host_name = "msk.api.wallet.best"
  } else {
    $host_name = "sandbox.wallet.best"
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
}

node default {

  include install_sphinx_search
  include sethostname
  if (has_role("prod") and !has_role("develop")) {
    $check_services = false
    $apns_feedback = true
    $autopayment_events_processing = false
    $autopayment_payments_checker = false
    $drunken_do = true
    $send_daily_transaction_log = false
    $send_monthly_transaction_log = false
    $wallet_intersecting_contacts = true
    $sync_service_param_items = false
    $check_services_new = true
    $aggregate_services_statistics = true
  } else {
    $check_services = false
    $apns_feedback = true
    $autopayment_events_processing = true
    $autopayment_payments_checker = true
    $drunken_do = true
    $send_daily_transaction_log = true
    $send_monthly_transaction_log = true
    $wallet_intersecting_contacts = true
    $sync_service_param_items = false
    $check_services_new = false
    $aggregate_services_statistics = true
  }

  class { 'best_wallet_crons':
    check_services => $check_services,
    apns_feedback => $apns_feedback,
    autopayment_events_processing => $autopayment_events_processing,
    autopayment_payments_checker => $autopayment_payments_checker,
    drunken_do => $drunken_do,
    send_daily_transaction_log => $send_daily_transaction_log,
    send_monthly_transaction_log => $send_monthly_transaction_log,
    wallet_intersecting_contacts => $wallet_intersecting_contacts,
    sync_service_param_items => $sync_service_param_items,
    check_services_new => $check_services_new,
    aggregate_services_statistics => $aggregate_services_statistics
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
    ssl_dhparam => '/etc/ssl/dhparam.pem'
  }
  if (has_role("prod") and !has_role("develop")) {
    $nginx = "prod.conf"
  } else {
    $nginx = "demo.conf"
  }
  file { "/etc/nginx/sites-enabled/mbank.api.conf":
    ensure => link,
    target => "/www/mbank.api/settings/nginx/$nginx",
    notify => Service["nginx"],
  }

  file { "/etc/nginx/sites-enabled/autodeployer.conf":
    ensure => link,
    target => "/www/nebo15.rome/www/config/nginx.conf",
    notify => Service["nginx"],
  }

  logrotate::rule { 'best_wallet_rotate_log':
    path         => '/www/mbank.api/var/main.log',
    rotate       => 5,
    rotate_every => 'week',
  }
}
