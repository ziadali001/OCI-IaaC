
resource "oci_identity_compartment" "DemoTF-Compartment" {
  provider = oci.homeregion
  name = "DemoTF-Compartment"
  description = "DemoTF-Compartment"
  compartment_id = var.compartment_ocid

  provisioner "local-exec" {
    command = "sleep 60"
  }
}
