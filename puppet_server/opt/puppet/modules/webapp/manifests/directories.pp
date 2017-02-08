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

  file { "/srv/webapp/${environment}":
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File['/srv/webapp/'],
  }

  file { "/srv/webapp/${environment}/src":
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File["/srv/webapp/${environment}"],
  }

  file { "/srv/webapp/${environment}/versions":
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File["/srv/webapp/${environment}"],
  }
}
