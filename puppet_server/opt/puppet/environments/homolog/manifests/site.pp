node default {}

node /^(homolog_)?balancer$/ {
  include balancer
}

node /^(homolog_)?(app|blue|green)\d+$/ {
  include webapp
}
