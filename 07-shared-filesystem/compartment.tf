resource "oci_identity_compartment" "Terraform-Demo" {
  provider = oci.homeregion
  name = "Terraform-Demo"
  description = "Terraform-Demo"
  compartment_id = var.compartment_ocid
  
  provisioner "local-exec" {
    command = "sleep 60"
  }
}