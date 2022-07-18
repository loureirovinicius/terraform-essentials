# In this file we specify the variables values in case we don't have a default value, you don't want to pass it through CLI or as env variables. To use this file as the .tfvars file, you need to specify it in the CLI when applying. Here is the syntax: "terraform apply -var-file="path/to/.tfvars"
# If your file is named as "terraform.tfvars", Terraform will automatically recognize it as a .tfvars file and you won't need to pass its path when applying, as showed above.

string_variable_name = "value"

number_variable_name = 2

boolean_variable_name = true

list_variable_name = ["value1", 2, true]

set_variable_name = ["item1", "item2", "item3"]

map_variable_name = {
  "item1" = "value1"
  "item2" = "value2"
}

object_variable_name = {
  item1 = "value1"
  item2 = 2
}

tuple_variable_name = ["item1", 2, true]