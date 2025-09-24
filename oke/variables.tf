variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "fingerprint" {}

variable "oke_addon_map" {
  type = map(object({
    configurations = map(object({
      config_value = string
    }))
    addon_version = string
  }))
  default = {
    "CertManager" = {
      configurations = {
        "numOfReplicas" = {
          config_value = "1"
        }
      }
      addon_version = "v1.13.3"
    },
    "OracleDatabaseOperator" = {
      configurations = {
        "numOfReplicas" = {
          config_value = "1"
        }
      }
      addon_version = "v1.0.0"
    }
  }
}