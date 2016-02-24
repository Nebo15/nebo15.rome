
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
  $drunken_do = false,
) {

  add_cron{ check_users_activation:
    command => "/www/mbank.api.serega/vendor/bin/drunken --config=\"/www/mbank.api.serega/drunken.config.php\" do",
    ensure => $drunken_do
  }
}