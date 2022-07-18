# Input variables are just like any other variables used in programming.
# In Terraform, we can create the variables structure (the declaration of it) in this file and pass a default value to it.
# But since there are variables we want a dynamic value and we can't pass a default value, we just define its structure here and pass its values in a .tfvars file, through the CLI or as env variables when applying the configs.
# Variables types are: string, numbers and boolean (primitives). List, tuple, map, object and set (complex types).

variable "string_variable_name" {
  type        = string
  default     = "value"
  description = "Strings are a sequence of unicode characters"
}

variable "number_variable_name" {
  type        = number
  default     = 1
  description = "Numbers are numeric values, such as 10 or 1.1111"
}

variable "boolean_variable_name" {
  type        = bool
  default     = false
  description = "Boolean are true or false values"
}

variable "list_variable_name" {
  type        = list(any) # Can be any type
  default     = ["item1", 2, true]
  description = "List are a sequence of values. Ex.: ['1', '2']"
}

variable "set_variable_name" {
  type        = set(any)
  default     = ["item1", "item2", "item3"]
  description = "Sets are unordered (items don't have a defined order), unchangeable (can't change items after they were created) and they don't allow duplicated values"
}

variable "map_variable_name" {
  type = map(string)
  default = {
    "item1" = "value"
    "item2" = "value"
  }
  description = "Maps are kinda like objects, but they allow only things of the same type. Ex.: Map of strings"
}

variable "object_variable_name" {
  type = object({
    item1 = string
    item2 = number
  })
  default = {
    item1 = "value"
    item2 = 2
  }
  description = "On the other hand, an object allow you to storage objects with different types inside of it."
}

variable "tuple_variable_name" {
  type = tuple([string, number, bool])
  default = [
    "item1",
    2,
    true
  ]
  description = "Tuples are just like a list, but their items are unchangeable and ordered. They also allow duplicated values."
}

variable "workspace_example" {
  type = map(string)
  default = {
    "workspace1" = "value1"
    "workspace2" = "value2"
  }
}