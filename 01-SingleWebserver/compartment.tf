/*
resource "oci_identity_compartment" "Demo-Compartment" {
  provider = oci.homeregion
  name = "Demo-Compartment"
  description = "Demo-Compartment"
  compartment_id = var.compartment_ocid

  provisioner "local-exec" {
    command = "sleep 60"
  }
}
*/