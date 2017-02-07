class webapp($version, $github_user, $github_project, $github_branch, $linux_user, $linux_group) {
  class { 'webapp::users':
    user  => $linux_user,
    group => $linux_group,
  }

  class { 'webapp::app':
    version        => $version,
    github_user    => $github_user,
    github_project => $github_project,
    github_branch  => $github_branch,
  }

  class { 'webapp::configuration':
    version => $version
  }

  include webapp::nginx
  include webapp::users
  include webapp::directories
  include webapp::app
  include webapp::configuration
}