class balancer {
  $deploy_strategy = hiera('deploy_strategy')
  $domains = $deploy_strategy['groups']['group_a']['clients']

  package { 'haproxy':
    ensure        => present,
    allow_virtual => false,
  }

  service { 'haproxy':
    ensure  => running,
    require => package[haproxy],
  }

  file { '/etc/haproxy/haproxy.cfg':
    owner   => root,
    group   => root,
    notify  => service[haproxy],
    content => template('balancer/haproxy.cfg.erb'),
  }
}
