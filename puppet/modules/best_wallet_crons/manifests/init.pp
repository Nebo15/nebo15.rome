class best_wallet_crons {
    $command = "/www/mbank.api/vendor/bin/pake -f /www/mbank.api/pakefile.php"
    cron { check_users_activation:
      command => "${command} check_users_activation",
      user    => www-data,
      ensure => absent,
      hour    => ['10-21'],
      minute  => '30'
    }
    cron { check_mserver_api:
      command => "${command} check_mserver_api",
      user    => www-data,
      ensure => absent,
      hour    => '12',
      minute  => '0'
    }

    cron { check_services:
      command => "${command} check_services",
      user    => www-data,
      ensure => present,
      hour    => [12,18],
      minute  => '15'
    }
    cron { apns_feedback:
      command => "${command} apns_feedback",
      user    => www-data,
      ensure => present,
      hour    => '12',
      minute  => '45'
    }
    cron { autopayment_events_processing:
      command => "${command} autopayment_events_processing --host=\"https://api.wallet.best/\"",
      user    => www-data,
      ensure => present
    }
    cron { autopayment_payments_checker:
      command => "${command} autopayment_payments_checker --host=\"https://api.wallet.best/\"",
      user    => www-data,
      ensure => present
    }

  cron { drunken_do:
    command => "/www/mbank.api/vendor/bin/drunken do",
    user    => www-data,
    ensure => present,
  }

  cron { send_daily_transaction_log:
    command => "${command} send_daily_transaction_log",
    user    => www-data,
    ensure => absent,
    hour    => '1',
    minute  => '0'
  }
  cron { send_monthly_transaction_log:
    command => "${command} send_monthly_transaction_log",
    user    => www-data,
    ensure => absent,
    hour    => '0',
    minute  => '0',
    month =>  '1'
  }
  cron { wallet_intersecting_contacts:
    command => "${command} wallet_intersecting_contacts",
    user    => www-data,
    ensure => absent,
    hour    => '3',
    minute  => '0'
  }
}