class mbank_api_mongo {
  $mongo_packages = ['php5-mongo', 'mongodb-org']

  include apt
  apt::source { 'install_mongo':
    location => 'http://repo.mongodb.org/apt/ubuntu/ trusty/mongodb-org/3.0',
    release  => 'multiverse',
    repos    => "multiverse",
    include  => {
      'deb' => true,
    },
  }
  package { $mongo_packages:
    ensure  => 'installed',
    install_options => ['-y', '--force-yes'],
    require => Apt::Source['install_mongo']
  }

  service { "mongod":
    ensure => "running",
    enable => "true",
    require => Package[$mongo_packages]
  }
}