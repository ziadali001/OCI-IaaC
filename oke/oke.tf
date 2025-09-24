module "ITR-oke" {
  source                        = "./modules/oci_oke"
  tenancy_ocid                  = var.tenancy_ocid      # Our tenancy OCID     
  compartment_ocid              = var.compartment_ocid  # Compartment OCID where OKE and network will be deployed
  cluster_type                  = "enhanced"            # Enhanced cluster
  node_shape                    = "VM.Standard.A1.Flex" # OCI Free Tier
  node_ocpus                    = 2                     # OCI Free Tier
  node_memory                   = 4                     # OCI Free Tier
  use_existing_vcn              = false                 # Module itself will create all necessary network resources
  is_api_endpoint_subnet_public = true                  # OKE API Endpoint will be public (Internet facing)
  is_lb_subnet_public           = true                  # OKE LoadBalanacer will be public (Internet facing)
  is_nodepool_subnet_public     = true                  # OKE NodePool will be public (Internet facing)
  #oke_addon_map                 = var.oke_addon_map
}
