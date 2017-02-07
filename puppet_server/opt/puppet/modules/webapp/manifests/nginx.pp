class webapp::nginx {
  package { 'epel-release':
    ensure        => present,
    allow_virtual => false,
  }

  package { 'nginx':
    ensure        => present,
    allow_virtual => false,
    require       => package[epel-release],
  }

  service { 'nginx':
    ensure  => running,
    require => package[nginx],
  }

  file { '/etc/nginx/conf.d/default.conf':
    owner    => root,
    require  => package[nginx],
    content  => template('webapp/nginx/default.conf.erb'),
    notify   => service['nginx'],
  }
}