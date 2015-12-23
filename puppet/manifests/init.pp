node default {
  include stdlib

  if (has_role("local")) {
    $revision = undef
  }
  if (has_role("prod")) {
    $revision = "master"
  }
  if (has_role("develop")) {
    $revision = "develop"
  }

    file { ["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]:
      ensure => "directory",
      owner  => "www-data",
      group  => "www-data",
      mode   => 755
    } ->

    file { "/etc/sudoers.d/www-data-user":
      content => "\
  Cmnd_Alias        CMDS = /usr/bin/puppet
  www-data  ALL=NOPASSWD: CMDS
  ",
      mode => 0440,
      owner => root,
      group => root,
    }

  if ($revision != undef) {
        vcsrepo { '/www/parasport.web':
          ensure     => latest,
          provider   => git,
          source     => 'git@gh.parasport.web:Nebo15/parasport.web.git',
          user       => 'www-data',
          revision   => $revision,
          require    => File["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]
        }
  }
}
