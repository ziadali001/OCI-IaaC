
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

variable "availablity_domain_name" {
  default = ""
}

variable "VCN-CIDR" {
  default = "10.0.0.0/16"
}

variable "WebSubnet-CIDR" {
  default = "10.0.1.0/24"
}

variable "LBSubnet-CIDR" {
  default = "10.0.2.0/24"
}

variable "BastionSubnet-CIDR" {
  default = "10.0.3.0/24"
}

variable "FSSSubnet-CIDR" {
  default = "10.0.4.0/24"
}

variable "MountTargetIPAddress" {
  default = "10.0.4.25"
}

variable "Shape" {
  default = "VM.Standard.E3.Flex"
}

variable "FlexShapeOCPUS" {
  default = 2
}

variable "FlexShapeMemory" {
  default = 4
}

variable "instance_os" {
  default = "Oracle Linux"
}

variable "linux_os_version" {
  default = "8"
}

variable "webservice_ports" {
  default = ["80", "443"]
}

variable "bastion_ports" {
  default = ["22"]
}

variable "fss_ingress_tcp_ports" {
  default = ["111", "2048", "2049", "2050"]
}

variable "fss_ingress_udp_ports" {
  default = ["111", "2048"]
}

variable "fss_egress_tcp_ports" {
  default = ["111", "2048", "2049", "2050"]
}

variable "fss_egress_udp_ports" {
  default = ["111"]
}

variable "lb_shape" {
  default = "flexible"
}

variable "flex_lb_min_shape" {
  default = 10
}

variable "flex_lb_max_shape" {
  default = 100
}

# Dictionary Locals
locals {
  compute_flexible_shapes = [
    "VM.Standard.E3.Flex",
    "VM.Standard.E4.Flex",
    "VM.Standard.A1.Flex",
    "VM.Optimized3.Flex"
  ]
}

# Checks if is using Flexible Compute Shapes
locals {
  is_flexible_shape    = contains(local.compute_flexible_shapes, var.Shape)
  is_flexible_lb_shape = var.lb_shape == "flexible" ? true : false
}
