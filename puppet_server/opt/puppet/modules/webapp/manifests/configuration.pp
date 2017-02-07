class webapp::configuration($version = '') {
  file { '/srv/webapp/production/current/config.js':
    owner    => $webapp::linux_user,
    group    => $webapp::linux_group,
    require  => file['/srv/webapp/production/current'],
    content  => template('webapp/configuration/config.js.erb'),
    notify   => service['nginx'],
  }
}