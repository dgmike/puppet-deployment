class webapp::directories {
  file { '/srv':
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => [User[$webapp::linux_user]],
  }

  file { '/srv/webapp':
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File['/srv'],
  }

  file { '/srv/webapp/production':
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File['/srv/webapp/'],
  }

  file { '/srv/webapp/production/src':
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File['/srv/webapp/production'],
  }

  file { '/srv/webapp/production/versions':
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File['/srv/webapp/production'],
  }
}