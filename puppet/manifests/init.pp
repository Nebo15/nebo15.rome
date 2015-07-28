node default {

  package {'install uuid-runtime':
    name    => 'uuid-runtime',
    ensure  => installed,
  }

  package {'npm':
    name    => 'npm',
    ensure  => installed,
  }

  package {'ruby-compass':
    name    => 'ruby-compass',
    ensure  => installed,
  }

  include stdlib
  include apt

  class{'mbank_api_users':} ->


  file { ["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 755
  }

  file { "/etc/sudoers.d/www-data-user":
    content => "\
Cmnd_Alias        CMDS = /usr/bin/puppet
www-data  ALL=NOPASSWD: CMDS
",
    mode => 0440,
    owner => root,
    group => root,
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

  $host_name = "sandbox-mobile.wallet.best"
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
