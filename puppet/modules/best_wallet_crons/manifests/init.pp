
define add_cron($command, $hour = '*', $minute = '*', $month = '*', $ensure) {

  if ($ensure == true) {
    $crons_ensure = present
  } else {
    $crons_ensure = absent
  }

  cron { $command:
    command => $command,
    user    => www-data,
    ensure => $crons_ensure,
    hour    => $hour,
    minute  => $minute,
    month => $month
  }
}

class best_wallet_crons(
  $check_users_activation = false,
  $check_mserver_api = false,
  $check_services = false,
  $apns_feedback = false,
  $autopayment_events_processing = false,
  $autopayment_payments_checker = false,
  $drunken_do = false,
  $send_daily_transaction_log = false,
  $send_monthly_transaction_log = false,
  $wallet_intersecting_contacts = false,
  $sync_service_param_items = false,
  $check_services_new = false,
  $aggregate_services_statistics = false
) {
  $command = "/www/mbank.api/vendor/bin/pake -f /www/mbank.api/pakefile.php"


  add_cron{ aggregate_services_statistics:
    command => "${command} aggregate_services_statistics",
    hour => '4',
    minute  => '10',
    ensure => $aggregate_services_statistics
  }

  add_cron{ check_services_new:
    command => "${command} sync_mserver_services",
    hour    => ['10-21'],
    minute  => '30',
    ensure => $check_services_new
  }

  add_cron{ check_users_activation:
    command => "${command} check_users_activation",
    minute  => '0',
    ensure => $check_users_activation
  }

  add_cron{ check_mserver_api:
    command => "${command} check_mserver_api",
    hour    => '12',
    minute  => '0',
    ensure =>  $check_mserver_api
  }

  add_cron{ check_services:
    command => "${command} check_services",
    minute  => '0',
    ensure =>  $check_services
  }

  add_cron{ apns_feedback:
    command => "${command} apns_feedback",
    hour    => '12',
    minute  => '45',
    ensure =>  $apns_feedback
  }

  add_cron{ autopayment_events_processing:
    command => "${command} autopayment_events_processing --host=\"https://api.wallet.best/\"",
    ensure =>  $autopayment_events_processing
  }

  add_cron{ autopayment_payments_checker:
    command => "${command} autopayment_payments_checker --host=\"https://api.wallet.best/\"",
    ensure =>  $autopayment_payments_checker
  }

  add_cron { drunken_do:
    command => "/www/mbank.api/vendor/bin/drunken do --config=\"/www/mbank.api/drunken.config.php\"",
    ensure  => $drunken_do,
  }

  add_cron { send_daily_transaction_log:
    command => "${command} send_daily_transaction_log",
    hour    => '1',
    minute  => '0',
    ensure  => $send_daily_transaction_log,
  }

  add_cron { send_monthly_transaction_log:
    command => "${command} send_monthly_transaction_log",
    hour    => '0',
    minute  => '0',
    month   =>  '1',
    ensure  => $send_monthly_transaction_log,
  }

  add_cron { wallet_intersecting_contacts:
    command => "${command} wallet_intersecting_contacts",
    hour    => '3',
    minute  => '0',
    ensure  => $wallet_intersecting_contacts
  }
  add_cron { sync_service_param_items:
    command => "${command} sync_service_param_items",
    hour    => '*',
    minute  => '*/30',
    ensure  => $sync_service_param_items
  }
}