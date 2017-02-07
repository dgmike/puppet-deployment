class webapp {
  include webapp::nginx
  include webapp::users
  include webapp::directories
  include webapp::app
}