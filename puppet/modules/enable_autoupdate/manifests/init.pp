class enable_autoupdate {
  package { 'unattended-upgrades':
      ensure  => 'installed',
      install_options => ['-y', '--force-yes'],
  }
  file { "/etc/apt/apt.conf.d/10periodic":
    path => "/etc/apt/apt.conf.d/10periodic",
    content => template('enable_autoupdate/periodic.erb'),
    require => Package['unattended-upgrades']
  }
  file { "/etc/apt/apt.conf.d/20auto-upgrades":
    path => "/etc/apt/apt.conf.d/20auto-upgrades",
    content => template('enable_autoupdate/auto-upgrades.erb'),
    require => Package['unattended-upgrades']
  }
}