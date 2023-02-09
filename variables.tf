variable "network_security_group_name" {
  description = "name given to new network security group"
  type        = string
}

variable "resource_group_name" {
  description = "parent resource group of network security group inside"
  type        = string
}

variable "location" {
  description = "azure location to place network security group"
  type        = string
}

variable "custom_rules" {
  description = "list of maps for custom rules"
  type = list(object({
    access                       = optional(string)
    description                  = optional(string)
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    destination_port_ranges      = optional(list(string))
    destination_port_range       = optional(string)
    direction                    = optional(string)
    name                         = string
    priority                     = number
    protocol                     = optional(string)
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
  }))
  default = []
}

variable "tags" {
  description = "tags"
  type        = map(any)
  default     = {}
}

variable "subnet_ids" {
  description = "list of subnet ids to attach to network security group"
  type        = list(string)
  default     = []
}

variable "network_interface_ids" {
  description = "list of network interface ids to attach to network security group"
  type        = list(string)
  default     = []
}