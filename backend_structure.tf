terraform {
  required_providers {
    local = {
      source  = "provider-name/resource-name"
      version = "{operator} version"
    }
  }
}

terraform {
  backend "type-of-backend" {
    configuration_variables = value
  }
}