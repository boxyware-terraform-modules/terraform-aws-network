variable "name" {
  type = string
  description = "The VPC name and the prefix to be used for all the depending resources such as subnets."
}

variable "labels" {
  type = any
  default     = {}
  description = "The tags to be added to all the resources creates by this module."
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC IP address range."
}

variable "public_subnets" {
  type = list(object({
    suffix = string
    az     = string
    cidr   = string
  }))
  default     = []
  description = "Public subnets information."
}

variable "private_subnets" {
  type = list(object({
    suffix = string
    az     = string
    cidr   = string
  }))
  default     = []
  description = "Private subnets information."
}

variable "enable_nat" {
  type        = bool
  default     = true
  description = "Indicates if a NAT must be deployed or not."
}