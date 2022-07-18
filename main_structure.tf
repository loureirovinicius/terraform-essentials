# Resource basic structure and resource dependency (implicit and explicit):
resource "resource_type" "resource_name" {
  argument           = value
  arguments_with_var = var.value                             # Get value from variables file
  argument2          = resource_type.resource_name.attribute # Implicit dependency
  depends_on = [                                             # Explicit dependency
    resource_type.resource_name
  ]
}

# Lifecycle rules example:
resource "resource_type" "resource_name_lifecycle" {
  argument1 = "value"
  argument2 = "value"
  argument3 = "value"
  argument4 = "value"
  argument5 = "value"

  lifecycle {
    create_before_destroy = true # Creates a new resource before destroying the old one
    prevent_destroy       = true # The new resource will be created and the old one won't be deleted.
    ignore_changes = [           # If we want Terraform to ignore an argument change when applying, we need to specify it within this list.
      argument4,
      argument5
    ]
  }
}

# Data Sources example:
data "resource_type" "data_source_name" {
  argument  = value
  argument2 = value
}

resource "resource_type" "using_data_source_inside_resource" {
  argument  = value
  argument2 = data.resource_type.data_source_name.attribute
}

# Count meta-argument: 
resource "resource_type" "count_resource_name" {
  argument  = value
  argument2 = var.list_variable_name[count.index]
  count     = length(var.list_variable_name)
}

# For-each meta-argument:
resource "resource_type" "for_each_resource_name" {
  argument  = value
  argument2 = each.key
  argument3 = each.value
  #map or set
  for_each = var.map_variable_name
}

# Provisioners:
resource "resource_type" "provisioner_resource_name" {
  argument = value
  argument2 = value

  # Remote-exec
  connection {
    type = "connection_type"
    user = "instance_user"
    password = "user_password"
    host = "instance_public_ip"
  }

  provisioner "remote-exec" {
    inline = [
      "echo Hello",
      "echo World"
    ]
  }

  # Local-exec
  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> my_ips.txt"
  }
}

# Provisioners Behaviors:
resource "resource_type" "provisioner_resource_name" {
  argument = value

  provisioner "local-exec" {
    when = destroy
    command = "echo ${resource_type.resource_name.public_ip} destroyed!"
  }

  provisioner "local-exec" {
    on_failure = fail
    command = "cat /home/user/my-ips.txt"
  }

  provisioner "local-exec" {
    on_failure = continue
    command = "cat /home/user/my-ips.txt"
  }
}

# Modules:
module "module_use" {
  source = "./modules/module_structure.tf"
  argument1 = "value1"
  argument3 = 3

  # Argument 2 is omitted because its value is a default value.
}

module "module_use_2" {
  source = "./modules/module_structure.tf"
  argument1 = "value2"
  argument3 = 4

  # Argument 2 is omitted because its value is a default value.
}

# Workspaces:
resource "resource_type" "workspace_resource_name" {
  argument1 = var.value1
  argument2 = lookup(var.workspace_example, terraform.workspace)
}