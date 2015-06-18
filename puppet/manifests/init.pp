$enhancers = [
  'php5-fpm',
  'php5-cli',
  'php5-intl',
  'php5-curl',
  'php-pear',
  'php5-dev'
]
class install_php56 {
  include apt
  apt::ppa { 'ppa:ondrej/php5-5.6': }
  package { $enhancers:
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Ppa['ppa:ondrej/php5-5.6']
  }

  file_line { 'php_fpm_change_listen':
    path  => '/etc/php5/fpm/pool.d/www.conf',
    line  => 'listen = 127.0.0.1:9000',
    match => 'listen = *',
    require => Package[$enhancers]
  }

  file_line { 'php_ini_change':
    path  => '/etc/php5/fpm/php.ini',
    line  => 'cgi.fix_pathinfo=0',
    match => '^?(;)cgi.fix_pathinfo=*',
    require => Package[$enhancers]
  }

}

class install_mongo {
  include apt
  apt::source { 'install_mongo':
    location => 'http://repo.mongodb.org/apt/ubuntu/ trusty/mongodb-org/3.0',
    release  => 'multiverse',
    repos    => "multiverse",
    include  => {
      'deb' => true,
    },
  }
  package { ['php5-mongo', 'mongodb-org']:
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Source['install_mongo']
  }
}

class users {
  Pe_accounts::User {
    shell => '/bin/bash',
  }

  pe_accounts::user {'kedome':
    locked  => false,
    name => 'kedome',
    groups  => ['root','kedome','sudo'],
    password => 'uZWNQdKm',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey4@puppetlabs.com'
    ],
  }
  pe_accounts::user {'andrew':
    locked  => false,
    name => 'andrew',
    groups  => ['root','andrew','sudo'],
    password => 'Hfzmf5Mw',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== sysop+moduledevkey@puppetlabs.com'
    ],
  }
  pe_accounts::user {'samorai':
    locked  => false,
    name => 'samorai',
    groups  => ['root','samorai','sudo'],
    password => 'PK8nUJGc',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== jeff+moduledevkey@puppetlabs.com'
    ],
  }
  pe_accounts::user {'bardack':
    locked  => false,
    name => 'bardack',
    groups  => ['root','bardack','sudo'],
    password => 'resWu2re',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwLBhQefRiXHSbVNZYKu2o8VWJjZJ/B4LqICXuxhiiNSCmL8j+5zE/VLPIMeDqNQt8LjKJVOQGZtNutW4OhsLKxdgjzlYnfTsQHp8+JMAOFE3BD1spVnGdmJ33JdMsQ/fjrVMacaHyHK0jW4pHDeUU3kRgaGHtX4TnC0A175BNTH9yJliDvddRzdKR4WtokNzqJU3VPtHaGmJfXEYSfun/wFfc46+hP6u0WcSS7jZ2WElBZ7gNO4u2Z+eJjFWS9rjQ/gNE8HHlvmN0IUuvdpKdBlJjzSiKZR+r/Bo9ujQmGY4cmvlvgmcdajM/X1TqP6p3OuouAk5QSPUlDRV91oEHw== dan+moduledevkey@puppetlabs.com'
    ],
  }

  pe_accounts::user {'delete_user':
    locked  => true,
    name => 'user_name',
    ensure => absent,
    managehome => true
  }
}

define sudo-include($name, $content) {
  file { "/etc/sudoers.d/$name":
    content => $content,
    mode => 0440,
    user => root,
    group => root,
  }
}

node default {

  package {'install uuid-runtime':
    name    => 'uuid-runtime',
    ensure  => installed,
  }

  #add php56
  include stdlib
  include install_php56
  include composer
  include install_mongo
  include users

  Class[install_php56] -> Class[install_mongo]
  class { 'newrelic':
    license_key => '1111222233334444555566667777888899990000',
    use_latest  => true
  }

  file { ["/www", "/var/backups/mbank.api", "/var/www", "/var/www/.ssh"]:
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
}
