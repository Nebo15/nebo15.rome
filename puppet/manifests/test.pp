node default {
  include apt

  class { locales:
    default_environment_locale => "en_US.UTF-8",
    locales => ["en_US ISO-8859-1",
      "en_US.UTF-8 UTF-8",],
  }
  class { 'timezone':
    timezone => 'Europe/Kiev',
  }

#  exec { "apt-update":
#    command => "/usr/sbin/dpkg-reconfigure locales"
#  }
}
