node default {
  $projects = ["gandalf.web", "gandalf.api"]
  puppet::projects { $projects: }

  class {'php56':} -> class{ 'mongo_3': }

  package {'libnotify-bin':
    name    => 'libnotify-bin',
    ensure  => installed,
  } ->
  package {'npm':
    name    => 'npm',
    ensure  => installed,
  } ->
  file { '/usr/bin/node':
    ensure => 'link',
    target => '/usr/bin/nodejs',
  } ->
  package { 'bower':
    provider => 'npm',
    require => Package['npm']
  } ->
  package { 'gulp':
    provider => 'npm',
    require => Package['npm']
  }


}


define puppet::projects ($project = $title  ) {
  vcsrepo { "/www/${project}":
    ensure     => latest,
    provider   => git,
    source     => "git@gh.${project}:Nebo15/${project}.git",
    user       => 'www-data',
    revision   => $revision,
    require => File["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]
  }
}