node default {}

node /^(staging_)?balancer$/ {
  include balancer
}

node /^(staging_)?(app|blue|green)\d+$/ {
  include webapp
}
