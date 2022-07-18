# Output variables are used to storage values that are returned from resources. Usually, these outputs variables are used as value to another resource creation.
# Check docs for more details.

output "output_name" {
  value       = resource_type.resource_name.argument
  description = "Optional, but can be useful."
}

output "output_name2" {
  value       = resource_type.resource_name.argument2
  description = "Optional, but can be useful."
}