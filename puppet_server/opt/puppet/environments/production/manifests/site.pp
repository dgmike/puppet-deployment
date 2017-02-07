node default {}

node 'balancer' {
}

node /^(production_)?app\d+$/ {
  include webapp
}
