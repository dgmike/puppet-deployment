class webapp::nginx {
  package { 'epel-release':
    ensure        => present,
    allow_virtual => false,
  }

  package { 'nginx':
    ensure        => present,
    allow_virtual => false,
    require       => Package[epel-release],
  }

  service { 'nginx':
    ensure  => running,
    require => Package[nginx],
  }

  file { '/etc/nginx/conf.d/default.conf':
    owner    => root,
    require  => Package[nginx],
    content  => template('webapp/nginx/default.conf.erb'),
    notify   => Service['nginx'],
  }
}