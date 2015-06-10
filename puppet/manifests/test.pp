node default {

  class { '::mongodb::server': }

  file_line { 'sudo_rule':
    path => '/etc/php5/fpm/php.ini',
    line => 'extension=mongo.so',

  }

  file_line { 'sudo_rule2':
    path => '/etc/php5/fpm/php.ini',
    line => 'extension=mongo.so',

  }
}
