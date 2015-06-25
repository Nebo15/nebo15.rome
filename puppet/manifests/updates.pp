

node default {
  include apt

  class {'newrelic::agent::php':
    newrelic_license_key  => 'fc04150b6b2478740bd6a6357087c1342bf99789',
    newrelic_ini_appname  => 'Best Wallet',
    newrelic_php_conf_dir => ['/etc/php5/mods-available','/etc/php5/fpm/conf.d'],
  }


}
