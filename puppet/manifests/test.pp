node default {


  file { ["/var/www", "/var/www/.ssh"]:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    force => true
  }
}
