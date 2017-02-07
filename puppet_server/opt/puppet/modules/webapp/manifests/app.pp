class webapp::app($main_version, $github_user, $github_project, $github_branch) {
  $version     = $main_version

  $url         = "https://github.com/${github_user}/${github_project}/archive/${github_branch}.tar.gz"
  $output_path = "/srv/webapp/production/src/${github_user}__${github_project}__${version}.tar.gz"
  $deploy_path = "/srv/webapp/production/versions/${version}"

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
    require   => file['/srv/webapp/production/src']
  }

  file { $deploy_path:
    group   => $webapp::linux_group,
    owner   => $webapp::linux_user,
    ensure  => directory,
    require => file['/srv/webapp/production'],
  }

  exec { $untar_project_tag:
    command   => "tar -C ${deploy_path} --strip-components=1 -zvxf ${output_path}",
    path      => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates   => "${deploy_path}/index.html",
    user      => root,
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
