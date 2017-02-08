class webapp::users($user, $group) {
  group { $group:
    ensure => present,
  }

  user { $user:
    ensure  => present,
    require => Group[$group],
  }
}
