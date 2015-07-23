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

  class{'mbank_api_users':} ->
  class {'mbank_api_php56':} -> class{'mbank_api_mongo':} ->


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
