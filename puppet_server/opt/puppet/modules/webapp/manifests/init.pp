class webapp {
  include webapp::nginx
  include webapp::users

  file { '/srv':
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => [user['www-data']],
  }

  file { '/srv/webapp':
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => file['/srv'],
  }

  file { '/srv/webapp/production':
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => file['/srv/webapp/'],
  }

  file { '/srv/webapp/production/v0.0.1':
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => file['/srv/webapp/production'],
  }

  file { '/srv/webapp/production/current':
    ensure  => link,
    target  => '/srv/webapp/production/v0.0.1',
    require => [file['/srv/webapp/production/v0.0.1'], package[nginx]],
    notify  => service[nginx],
  }
}