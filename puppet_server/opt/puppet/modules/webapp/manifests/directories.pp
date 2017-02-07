class webapp::directories {
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

  file { '/srv/webapp/production/src':
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => file['/srv/webapp/production'],
  }

  file { '/srv/webapp/production/versions':
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => file['/srv/webapp/production'],
  }
}