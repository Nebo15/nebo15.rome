node default {

  $projects = ["gandalf.web", "gandalf.api"] #array of projects, should be similar with array from init.sh
  $project_owner_user = "deploybot"
  $project_owner_group = "deploybot"

  puppet::projects { $projects: }

  class {'php56':
    user => $project_owner_user,
    group => $project_owner_group
  } -> class{ 'mongo_3': }

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

  file { ["/www/${project}"]:
    ensure => "directory",
    owner  => "deploybot",
    group  => "deploybot",
    mode   => 755
  }
  #if you want clone project from git
#  vcsrepo { "/www/${project}":
#    ensure     => latest,
#    provider   => git,
#    source     => "git@gh.${project}:Nebo15/${project}.git",
#    user       => $project_owner_user,
#    revision   => $revision,
#    require    => File["/www", "/var/www", "/var/www/.ssh", "/var/log", "/var/log/www"]
#  }
}