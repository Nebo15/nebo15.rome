node default {

  vcsrepo { '/www/mbank.web.b2b':
    ensure     => latest,
    provider   => git,
    source     => 'git@gh.mbank.web.b2b_master:Nebo15/mbank.web.b2b.git',
    user       => 'www-data',
    revision   => 'master',
  }
  file { '/etc/nginx/sites-enabled/mbank.web.b2b.conf':
    ensure => 'link',
    target => '/www/mbank.web.b2b/settings/nginx/prod.conf',
    require => Vcsrepo['/www/mbank.web.b2b']
  }

}
