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
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCtY92QQmkfD7mxFw8mfZE8PCZIEhW97ZH0KU4M3x0MAV31a4NjLMzHY97kMk1kxxkR5ysvj2OFn9uU+Aw2tdJVd1ks91NgkaZGT4yKS156xXoir5n4dKs6UXx7nZMvAImQx6ixjIT+fm2I3l9NMW57jcAJQJYRvlVzvLf0+nHFSZFQ9WqsuMKkdLjP1p4L2Q6UsCTwtjFaY7DoRzak6JiQhT0ma1jNtERtKGxJOrdvlt4O5KHqqzP5d1HY38GVHKisKWx6mqJJxoJxnWD5mDJi5y/0C/8HVEP0QELeji381aYr57U28VG/RDqsBvERfT4iDQu17BnLd9yH14f5BZD7 kedome@icloud.com'
    ],
  }
  pe_accounts::user {'andrew':
    locked  => false,
    name => 'andrew',
    groups  => ['root','andrew','sudo'],
    password => 'Hfzmf5Mw',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCqqp5dmekEgbpGz/yOg5cET5SZAao+nltZzyAsRs45E26TBoOkrFIoN9qWeCtGHBZayaD+pQ/ygzMO+j3Ednzpe1WYXD6VuWmr5Qyk4rQdzWN1VbsyMrr1sw5C4VUE7S5L6PRk+cZHH6n0XIRoNIlL7nrXCMwSWDEIkIwqCagMOdAbix/g6wkiijir09JnqYbyE+nNTulvjW/mkIS3QYGj61p3XdfEZsySz8gqbMfJ0nf1o3LTwwShp5JZg+C8rMaGlPGuKGTHxT3s+v2Uywum5Q/HyCJ3IcVEl2jU62RjytAKRWA7eo9AY9J7cKb9bvCivkgmiD7J6JSTG7UlNvUP andrew@dryga.com'
    ],
  }
  pe_accounts::user {'samorai':
    locked  => false,
    name => 'samorai',
    groups  => ['root','samorai','sudo'],
    password => 'PK8nUJGc',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDucOfwLVBlWSf2xG9VuD+csO07t+Tk1LlUoU+fT/8fq3dssBH3fJH3dn0jFEbSGGoeJ2q3ljwFw4K9haPT8lELtIgDQUWqJzslqz2G1ObpcVOXD9HT3i0MC6f0pKn4XHkvqMNn3d9NFCNozR+F6NNXryjjR+NGc+wTgcqSYgYQbA6oFrhg30G0fantWqDVU+tWqxr9tbccVvnUq6FCtg8soDeuR5bEnabVFI+2dYDy8HGspQuYZWued0ePZHZ+egR7vJe4tyNOF0f8phLjQACSl7ukBzj6mL18DH4Sddtgu2qYhGCfl0MGc0I/1iMrrO1hMeSPOmjAC7pi2yw/B7bp oleg.samorai@gmail.com'
    ],
  }
  pe_accounts::user {'bardack':
    locked  => false,
    name => 'bardack',
    groups  => ['root','bardack','sudo'],
    password => 'resWu2re',
    sshkeys => [
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiOiaRLfU7iHjq2cvPPX+1eK1QDoJ7Yu0IrUrHuEWPxG5Mqui840A320y2Eb0Alr5rSeryZiYlIKxnoCWw2DgYBa5+wIbtEb6gIMszp39VF9qjNgXaAnWVKKWqN5JTLNOASG/Dxsw/DvtQ3M52+v4HYiZkZzGubUra5QqZNGndG7N8upvJYvgEwLaeTx/axwP91SdFBq1VqtGUgmrFbxFpX+4yx1jMVCoa/AIAEdHZIzu8ZlKduwhyT2vEOfg1xlsxq5vKZlthpGYQKtE4NI1dtJ/M+aYd96kG0UNmOOdvFq3dCD0P0MvhJf64Z9BMJXfhxHPTz9mknW/yKCfXfZ0t',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfDZkwERE9ZbWZZ1/XOmRkKdQ6mps3C4+LD6THKgfcpRKUui1BAsKwJmXSbApFgHOL5BmHHPUSOCCnl0knJYdjOxLwFgPfoZtDn3FES64/zQKGf1RqNOU1Ynw+hx+LFGKw5Af+cL88MUehbEFWI2M5prwC0rGgsNnwiQTcygP6TeCZJAegRMg626d5QU5MaOot/SsfRxrl45ii68oWyoz0CLRUKh2EOduz/hBf4jj83Kv2HDaZB1+qe7ttZqydaFZJvl5Ht0H7qgMwY1d0FC2jy3zEYXy5KrX5OdNrTgGIKxalp8gcOUANIU1Jhmr3ik4PYzr5NyIVfVwHZTz/dbPz paul@nebo15.com',
      'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPYaa4wPCTI4WRvIF1LhpProLCQ7hRxcViX18bZl5732tLftkzuac7jnVy7iDM0A8exC9pGGK5i4ffguC2sOA6nfRuUlQ5E53FtRVsFS3Ziiv7LSzYKxPW0IyqvUZ+ZAKqlZB0ZXxMiSk2H4MN/VJFc9nMujb0TSQNyWgQpW6EPS2O7gqx91kOfwbtINsWSiCEyd5RnodAAdF+pz8Jy6uWtznkNl3LuPi8O2a/jsEtvKLjkDCrKKn69Rn0yuF201AQtdNQ1LhkDAuH+MwSalVp48evWN30UiVOc0wptEDyI6gPNlYiyiFvjnazUH2naJUtpvPF6ttjAk+sHPfgGslD paul.bardack@gmail.com'
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
    owner => root,
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
