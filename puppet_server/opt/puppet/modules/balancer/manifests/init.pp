class balancer {
  $deploy_strategy = hiera('deploy_strategy')
  $domains = $deploy_strategy['groups']['group_a']['clients']

  file { '/root/ips':
    owner   => root,
    group   => root,
    content => template('balancer/ips.erb'),
  }
}