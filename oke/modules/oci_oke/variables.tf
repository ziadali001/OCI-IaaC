variable "region" {
  default = ""
}

variable "compartment_ocid" {
  default = ""
}

variable "tenancy_ocid" {
  default = ""
}

variable "availability_domain" {
  default = ""
}

variable "use_existing_vcn" {
  default = true
}

variable "use_existing_nsg" {
  default = true
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_id" {
  default = ""
}

variable "nodepool_subnet_id" {
  default = ""
}

variable "nodepool_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "lb_subnet_id" {
  default = ""
}

variable "lb_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "api_endpoint_subnet_id" {
  default = ""
}

variable "api_endpoint_subnet_cidr" {
  default = "10.0.3.0/24"
}

variable "api_endpoint_nsg_ids" {
  default = []
}

variable "pods_subnet_id" {
  default = ""
}

variable "pods_nsg_ids" {
  default = []
}

variable "oke_cluster_name" {
  default = "OKECluster"
}

variable "vcn_native" {
  default = true
}

variable "is_api_endpoint_subnet_public" {
  default = false
}

variable "is_lb_subnet_public" {
  default = false
}

variable "is_nodepool_subnet_public" {
  default = false
}

variable "k8s_version" {
# default = "v1.26.2"
# default = "v1.28.2"
  default = "v1.30.1"
}

variable "pool_name" {
  default = "NodePool"
}

variable "node_shape" {
  default = "VM.Standard.E4.Flex"
}

variable "node_pool_image_id" {
  default = "Oracle Linux"
}

variable "node_pool_boot_volume_size_in_gbs" {
  default = 50
}

variable "node_ocpus" {
  default = 2
}

variable "node_memory" {
  default = 4
}

variable "oci_vcn_ip_native" {
  default = false
}

variable "max_pods_per_node" {
  default = 10
}

variable "pods_cidr" {
  default = "10.1.0.0/16"
}

variable "services_cidr" {
  default = "10.2.0.0/16"
}

variable "pods_subnet_cidr" {
  default = "10.0.4.0/24"
}

variable "virtual_node_pool" {
  default = false
}

variable "node_linux_version" {
  default = "8"
}

variable "node_pool_count" {
  default = 1
}

variable "node_count" {
  default = 3
}

variable "autoscaler_enabled" {
  default = false
}

variable "autoscaler_authtype_workload" {
  default = true
}

variable "autoscaler_scale_down_delay_after_add" {
  default = "15m"
}

variable "autoscaler_scale_down_unneeded_time" {
  default = "10m"
}

variable "autoscaler_node_pool_count" {
  default = 1
}

variable "autoscaler_min_number_of_nodes" {
  default = 1
}

variable "autoscaler_max_number_of_nodes" {
  default = 10
}

variable "node_pool_image_type" {
  default = "oke"
}

variable "virtual_nodepool_pod_shape" {
  default = "Pod.Standard.E4.Flex"
}

variable "virtual_nodepool_nsg_ids" {
  default = []
}

variable "cluster_type" {
  default         = "enhanced"
  description     = "The cluster type. See <a href=https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengworkingwithenhancedclusters.htm>Working with Enhanced Clusters and Basic Clusters</a> for more information."
  type            = string
  validation {
    condition     = contains(["basic", "enhanced"], lower(var.cluster_type))
    error_message = "Accepted values are 'basic' or 'enhanced'."
  }
}

variable "cluster_options_add_ons_is_kubernetes_dashboard_enabled" {
  default = true
}

variable "cluster_options_add_ons_is_tiller_enabled" {
  default = true
}

variable "cluster_options_admission_controller_options_is_pod_security_policy_enabled" {
  default = false
}

variable "node_pool_initial_node_labels_key" {
  default = "key"
}

variable "node_pool_initial_node_labels_value" {
  default = "value"
}

variable "cluster_kube_config_token_version" {
  default = "2.0.0"
}

variable "ssh_public_key" {
  default = ""
}

variable "node_eviction_node_pool_settings" {
  default = false
}

variable "eviction_grace_duration" {
  default = "PT60M"
}

variable "is_force_delete_after_grace_duration" {
  default = true
}

variable "oke_addon_map" {
   type = map(object({
    configurations = map(object({
      config_value = string
    }))
    addon_version = string
  }))
  default = {}
}
