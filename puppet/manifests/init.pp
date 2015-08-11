define sudo-include($name, $content) {
  file { "/etc/sudoers.d/$name":
    content => $content,
    mode => 0440,
    owner => root,
    group => root,
  }
}

node default {

  package {'install uuid-runtime':
    name    => 'uuid-runtime',
    ensure  => installed,
  }

  include stdlib
  include composer
  include apt

  if (has_role("prod") and !has_role("develop")) {
    $new_relic_licence_key = "fc04150b6b2478740bd6a6357087c1342bf99789"
    $new_relic_app_name = 'mbank.api.prod'
  } else {
    $new_relic_licence_key = "1234567890123456789012345678901234567890"
    $new_relic_app_name = 'mbank.api.dev'
  }

  class{'mbank_api_users':} ->
  class {'mbank_api_php56':} -> class{'mbank_api_mongo':} ->
  class {'newrelic::server::linux':
    newrelic_license_key  => $new_relic_licence_key,
  } ~>
  class {'newrelic::agent::php':
    newrelic_license_key  => $new_relic_licence_key,
    newrelic_ini_appname  => 'mbank.api',
    newrelic_php_conf_dir => ['/etc/php5/mods-available'],
  }

  file { ["/www", "/var/backups/mbank.api", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 755
  }

  sudo-include { 'init_www_data_user':
    name =>  "www-data-user",
    content => "\
Cmnd_Alias        CMDS = /usr/bin/puppet
www-data  ALL=NOPASSWD: CMDS
Defaults env_keep += \"FACTER_server_tags\"
"
  }
  
  package { "openssh-server": ensure => "installed" }

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
}
