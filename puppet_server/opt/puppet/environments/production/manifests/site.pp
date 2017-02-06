node default {}

node 'puppet_loadbalancer' {
  package { 'vim-enhanced':
    ensure => present,
    allow_virtual => false,
  }
}
