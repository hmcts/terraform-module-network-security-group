variable "network_security_group_name" {
  description = "[REQUIRED] - name given to new network security group"
  type        = string
}

variable "resource_group_name" {
  description = "[REQUIRED] - parent resource group of network security group inside"
  type        = string
}

variable "location" {
  description = "[REQUIRED] - azure location to place network security group"
  type        = string
}

variable "tags" {
  description = "tags"
  type        = map(any)
  default     = {}
}

variable "subnets" {
  description = "list of maps with subnet names & subnet ids to attach to nsg"
  type = list(object({
    name = string
    id   = string
  }))
  default = []
}

variable "network_interfaces" {
  description = "list of maps with network interface names & ids to attach to nsg"
  type = list(object({
    name = string
    id   = string
  }))
  default = []
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

  validation {
    error_message = "Network Security Name can not contain a space"
    condition = (
      alltrue([for rule in var.custom_rules :
        !can(regex(" ", rule.name))
      ])
    )
  }

  validation {
    error_message = "One of destination_address_prefix OR destination_address_prefixes must be entered"
    condition = (
      alltrue([for rule in var.custom_rules : (
        rule.destination_address_prefix != null || rule.destination_address_prefixes != null
      )])
    )
  }

  validation {
    error_message = "One of destination_port_range OR destination_port_ranges must be entered"
    condition = (
      alltrue([for rule in var.custom_rules : (
        rule.destination_port_range != null || rule.destination_port_ranges != null
      )])
    )
  }

  validation {
    error_message = "One of source_address_prefix OR source_address_prefixes must be entered"
    condition = (
      alltrue([for rule in var.custom_rules : (
        rule.source_address_prefix != null || rule.source_address_prefixes != null
      )])
    )
  }

  validation {
    error_message = "One of source_port_range OR source_port_ranges must be entered"
    condition = (
      alltrue([for rule in var.custom_rules : (
        rule.source_port_range != null || rule.source_port_ranges != null
      )])
    )
  }
}