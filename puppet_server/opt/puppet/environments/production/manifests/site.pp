node default {}

node /^(production_)?balancer$/ {
  include balancer
}

node /^(production_)?(app|blue|green)\d+$/ {
  include webapp
}
