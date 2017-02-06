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

  file { '/etc/nginx/conf.d/000-webserver':
    owner    => root,
    require  => package[nginx],
    content  => template('webapp/nginx/000-webserver.erb'),
  }
}