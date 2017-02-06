node default {}

node 'balancer' {
}

node /^app\d+$/ {
  include webapp
}
