# Minimal stub; we’ll add VSI next step
variable "name" { type = string }
variable "resource_group" { type = string }
variable "zone" { type = string }
# TODO: add VPC, subnet, instance, SSH keys
output "note" { value = "IBM VSI module stubbed" }
