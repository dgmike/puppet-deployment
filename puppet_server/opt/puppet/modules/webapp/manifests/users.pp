class webapp::users {
  group { 'www-data':
    ensure => present,
  }

  user { 'www-data':
    ensure  => present,
    require => group['www-data'],
  }
}