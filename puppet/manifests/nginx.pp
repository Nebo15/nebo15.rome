
class sethostname {
  file { "/etc/hostname":
    ensure => present,
    owner => root,
    group => root,
    mode => 644,
    content => "ams-fonar.wallet.best\n",
    notify => Exec["set-hostname"],
  }
  exec { "set-hostname":
    command => "/bin/hostname -F /etc/hostname",
    unless => "/usr/bin/test `hostname` = `/bin/cat /etc/hostname`",
  }
}

node default {
  include nginx
  include sethostname
  file { "/etc/nginx/sites-enabled/mbank.api.fonar.conf":
    ensure => link,
    target => "/www/mbank.api.fonar/nginx.example.conf",
    notify => Service["nginx"],
  }

  file_line { 'change_nginx_conf':
    path  => '/etc/nginx/nginx.conf',
    line  => "http {
    fastcgi_cache_path /var/www/data/nginx levels=1:2 keys_zone=one:10m;
    ",
    match => '^http {',
    require => File[["/www", "/var/www", "/var/www/data", "/var/www/data/nginx"]],
    notify => Service["nginx"],
  }

  file { ["/www", "/var/www", "/var/www/data", "/var/www/data/nginx"]:
    ensure => "directory",
    owner  => "www-data",
    group  => "www-data",
    mode   => 755
  }

  file { "/etc/nginx/sites-enabled/autodeployer.conf":
    ensure => link,
    target => "/www/nebo15.rome/www/config/nginx.conf",
    notify => Service["nginx"],
  }

}
