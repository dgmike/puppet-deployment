node default {}

node /^(production_)?balancer$/ {
  include balancer
}

node /^(production_)?app\d+$/ {
  include webapp
}
