class webapp::app {
  $github_user     = 'dgmike'
  $github_project  = 'mustache-test'
  $github_branch   = 'master'
  $project_version = 'v1.0.13'

  $url         = "https://github.com/${github_user}/${github_project}/archive/${github_branch}.tar.gz"
  $output_path = "/srv/webapp/production/src/${github_user}__${github_project}__${project_version}.tar.gz"
  $deploy_path = "/srv/webapp/production/versions/${project_version}"

  $project_identifier = "${github_user}/${github_project}:${github_branch}::${project_version}"

  $curl_project_tag  = "curl project ${project_identifier}"
  $untar_project_tag = "untar project ${project_identifier}"

  exec { $curl_project_tag:
    command   => "curl --location --max-redirs 10 '${url}' > '${output_path}'",
    path      => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates   => $output_path,
    tries     => 3,
    try_sleep => 2,
  }

  file { $deploy_path:
    group   => www-data,
    owner   => www-data,
    ensure  => directory,
    require => file['/srv/webapp/production'],
  }

  exec { $untar_project_tag:
    command   => "tar -C ${deploy_path} --strip-components=1 -zvxf ${output_path}",
    path      => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates   => "${deploy_path}/index.html",
    require   => [exec[$curl_project_tag], file[$deploy_path]],
    tries     => 5,
    try_sleep => 2,
  }

  file { '/srv/webapp/production/current':
    ensure  => link,
    target  => $deploy_path,
    require => [file[$deploy_path], package['nginx']],
    notify  => service['nginx'],
  }
}
