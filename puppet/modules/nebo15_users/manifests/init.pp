class mbank_api_php56 {
  $enhancers = [
    'php5-fpm',
    'php5-cli',
    'php5-intl',
    'php5-curl',
    'php-pear',
    'php5-dev',
    'php5-mysql',
    'php5-apcu',
  ]
  include apt
  apt::ppa { 'ppa:ondrej/php5-5.6': }
  package { $enhancers:
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Ppa['ppa:ondrej/php5-5.6']
  }
  file { "/etc/php5/fpm/pool.d/www.conf":
    path => "/etc/php5/fpm/pool.d/www.conf",
    content => template('mbank_api_php56/php-fpm-www.conf.erb'),
    require => Package[$enhancers]
  }
  file { "/etc/php5/fpm/php.ini":
    path => "/etc/php5/fpm/php.ini",
    content => template('mbank_api_php56/php-fpm.ini.erb'),
    require => Package[$enhancers]
  }

  file { "/etc/php5/fpm/php-fpm.conf":
    path => "/etc/php5/fpm/php-fpm.conf",
    content => template('mbank_api_php56/php-fpm.conf.erb'),
    require => Package[$enhancers]
  }
}
