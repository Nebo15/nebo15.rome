
#sudo puppet apply --modulepath ./modules manifests/init.pp
node default {
  include apt

  apt::ppa { 'ppa:ondrej/php5-5.6': }
  package { [
    'php5-fpm',
    'php5-cli',
    'php5-intl',
    'php5-curl',
    'php-pear',
    'php5-dev'
  ]:
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Ppa['ppa:ondrej/php5-5.6']
  }
}