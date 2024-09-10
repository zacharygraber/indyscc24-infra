variable "auto_allocated_network_id" {
    type = string
}

variable "subnet_pool_id" {
    type = string
}

variable "router_id" {
    type = string
}

variable "default_security_group_id" {
    type = string
}

variable "teams" {
    type = map(object({
        ssh_pubkeys = set(string)
    }))
}