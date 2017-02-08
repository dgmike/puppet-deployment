class webapp::app($version, $github_user, $github_project, $github_branch) {
  $url         = "https://github.com/${github_user}/${github_project}/archive/${github_branch}.tar.gz"
  $output_path = "/srv/webapp/${environment}/src/${github_user}__${github_project}__${version}.tar.gz"
  $deploy_path = "/srv/webapp/${environment}/versions/${version}"

  $project_identifier = "${github_user}/${github_project}:${github_branch}::${version}"

  $curl_project_tag  = "curl project ${project_identifier}"
  $untar_project_tag = "untar project ${project_identifier}"

  exec { $curl_project_tag:
    command   => "curl --location --max-redirs 10 '${url}' -o '${output_path}'",
    path      => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates   => $output_path,
    user      => root,
    tries     => 5,
    try_sleep => 2,
    require   => File["/srv/webapp/${environment}/src"]
  }

  file { $deploy_path:
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => File["/srv/webapp/${environment}"],
  }

  exec { $untar_project_tag:
    command   => "tar -C ${deploy_path} --strip-components=1 -zvxf ${output_path}",
    path      => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates   => "${deploy_path}/index.html",
    user      => root,
    require   => [Exec[$curl_project_tag], File[$deploy_path]],
    tries     => 5,
    try_sleep => 2,
  }

  file { "/srv/webapp/${environment}/current":
    ensure  => link,
    target  => $deploy_path,
    require => [File[$deploy_path], Package['nginx']],
    notify  => Service['nginx'],
  }

  file { "${deploy_path}/config.js":
    owner    => $webapp::linux_user,
    group    => $webapp::linux_group,
    require  => [Exec[$untar_project_tag], File["/srv/webapp/${environment}/current"]],
    content  => template('webapp/configuration/config.js.erb'),
    notify   => Service['nginx'],
  }
}
