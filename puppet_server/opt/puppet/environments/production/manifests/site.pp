node default {}

node 'balancer' {
  package { 'vim-enhanced':
    ensure => present,
    allow_virtual => false,
  }
}
