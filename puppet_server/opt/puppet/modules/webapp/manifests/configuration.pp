class webapp::configuration($version = '') {
  file { '/srv/webapp/production/current/config.js':
    owner    => 'www-data',
    group    => 'www-data',
    require  => file['/srv/webapp/production/current'],
    content  => template('webapp/configuration/config.js.erb'),
    notify   => service['nginx'],
  }
}