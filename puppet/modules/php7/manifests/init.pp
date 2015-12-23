class php7 {
  $enhancers = [
    'php7.0',
    'php7.0-fpm',
    'php7.0-cli',
    'php7.0-mysql',
    'php7.0-curl',
  ]
  include apt
  apt::ppa { 'ppa:ondrej/php-7.0': }
  package { $enhancers:
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Ppa['ppa:ondrej/php-7.0']
  }
  file { "/etc/php/7.0/fpm/pool.d/www.conf":
    path => "/etc/php/7.0/fpm/pool.d/www.conf",
    content => template('php7/php-fpm-www.conf.erb'),
    require => Package[$enhancers]
  }
  file { "/etc/php/7.0/fpm/php.ini":
    path => "/etc/php/7.0/fpm/php.ini",
    content => template('php7/php-fpm.ini.erb'),
    require => Package[$enhancers]
  }

  file { "/etc/php/7.0/fpm/php-fpm.conf":
    path => "/etc/php/7.0/fpm/php-fpm.conf",
    content => template('php7/php-fpm.conf.erb'),
    require => Package[$enhancers]
  }
}
